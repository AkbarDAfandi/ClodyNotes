import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cloudynotesv3/editor.dart';
import 'package:cloudynotesv3/splashscreen.dart';
import 'package:cloudynotesv3/create.dart';

final supabase = Supabase.instance.client;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Stream<List<Map<String, dynamic>>>> _noteStreamFuture;
  late SearchController _searchController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
    _noteStreamFuture = _initNoteStream();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<Stream<List<Map<String, dynamic>>>> _initNoteStream() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      return supabase
          .from('notes')
          .stream(primaryKey: ['note_id']).eq('user_id', userId);
    } else {
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  hintText: 'Search Notes',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  fillColor: Colors.purple.shade50,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.grey),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  supabase.auth.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SplashScreen(),
                                    ),
                                  );
                                },
                                child: const Text("Logout"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<Stream<List<Map<String, dynamic>>>>(
                    future: _noteStreamFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final noteStream = snapshot.data!;
                      return StreamBuilder<List<Map<String, dynamic>>>(
                        stream: noteStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final notes = snapshot.data!;
                          final filteredNotes = notes.where((note) {
                            final noteTitle =
                                note['judul'].toString().toLowerCase();
                            final noteBody =
                                note['isi'].toString().toLowerCase();
                            return noteTitle.contains(searchQuery) ||
                                noteBody.contains(searchQuery);
                          }).toList();

                          return ListView.builder(
                            itemCount: filteredNotes.length,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            itemBuilder: (context, index) {
                              final note = filteredNotes[index];
                              final noteId = note['note_id'].toString();

                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditPage(noteId: noteId),
                                  ),
                                ),
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      note['judul'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      note['isi'],
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
