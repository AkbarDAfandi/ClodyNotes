import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

final supabase = Supabase.instance.client;

class EditPage extends StatefulWidget {
  final String noteId;

  const EditPage({Key? key, required this.noteId}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNote();
  }

  Future<void> _fetchNote() async {
    final response = await supabase
        .from('notes')
        .select()
        .eq('note_id', widget.noteId)
        .single();

    final note = response;
    setState(() {
      _titleController.text = note['judul'] as String;
      _contentController.text = note['isi'] as String;
      _isLoading = false;
    });
  }

  Future<void> _deleteNote() async {
    bool shouldDelete = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                shouldDelete = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (shouldDelete) {
      try {
        await supabase.from('notes').delete().eq('note_id', widget.noteId);
        Navigator.of(context).pop();
      } catch (error) {
        print('Error deleting note: $error');
      }
    }
  }

  Future<void> _updateNote() async {
    setState(() {
      _isSaving = true;
    });

    final updates = {
      'judul': _titleController.text,
      'isi': _contentController.text,
    };

    final response = await supabase
        .from('notes')
        .update(updates)
        .eq('note_id', widget.noteId);

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed:
                _deleteNote, // Add a function to handle the delete operation
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          labelText: 'Content',
                        ),
                        maxLines: 10,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ]),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isSaving ? null : _updateNote,
        child: _isSaving
            ? const CircularProgressIndicator()
            : const Icon(Icons.save),
      ),
    );
  }
}
