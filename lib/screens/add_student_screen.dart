import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class AddStudentScreen extends StatefulWidget {
  final String groupId;

  const AddStudentScreen({super.key, required this.groupId});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _namesController = TextEditingController();
  bool _loading = false;
  String _error = '';

  Future<void> _registerStudents(List<String> names) async {
    setState(() {
      _loading = true;
      _error = '';
    });

    final batch = FirebaseFirestore.instance.batch();
    final collection = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('students');

    final timestamp = FieldValue.serverTimestamp();

    for (final name in names) {
      final doc = collection.doc();
      batch.set(doc, {'name': name.trim(), 'addedAt': timestamp});
    }

    try {
      await batch.commit();
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = 'Error al registrar: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final contents = await file.readAsString();
      final lines = contents
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (lines.isNotEmpty) {
        await _registerStudents(lines);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar alumnos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Introduce los nombres, uno por línea:'),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _namesController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ejemplo:\nJuan Pérez\nMaría López\nCarlos Ramírez',
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  onPressed: _loading ? null : _pickFile,
                  label: const Text('Importar archivo'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  onPressed: _loading
                      ? null
                      : () {
                          final names = _namesController.text
                              .split('\n')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();
                          if (names.isNotEmpty) {
                            _registerStudents(names);
                          }
                        },
                  label: const Text('Registrar alumnos'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
