import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                  ),
                  const SizedBox(height: 16),
                  FloatingActionButton(
                    onPressed: _isSaving ? null : _updateNote,
                    child: _isSaving
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.save),
                  ),
                ],
              ),
            ),
    );
  }
}
