import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloudynotesv3/home.dart';

final supabase = Supabase.instance.client;

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePage();
}

class _CreatePage extends State<CreatePage> {
  Future<void> createNote(String note, String title) async {
    final userId = supabase.auth.currentUser?.id;
    await supabase.from('notes').insert({'judul': title, 'isi': note, 'user_id': userId});
  }

  Future<void> updateNote(String noteId, String updatedNote) async {
    await supabase
        .from('notes')
        .update({'isi': updatedNote}).eq('notes_id', noteId);
  }

  Future<void> deleteNote(String noteId) async {
    await supabase.from('notes').delete().eq('notes_id', noteId);
  }

  bool shadowColor = false;
  double? scrolledUnderElevation;

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('New Notes'),
          backgroundColor: Colors.deepPurple.shade50,
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          scrolledUnderElevation: scrolledUnderElevation,
          shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                ),
                maxLines: null, // Allow multiline input
              ),
            ],
          ),
        ),
        floatingActionButton:  FloatingActionButton(
          onPressed: () async {
            final title = titleController.text;
            final content = contentController.text;
            await createNote(content, title);
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop(false);
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}

