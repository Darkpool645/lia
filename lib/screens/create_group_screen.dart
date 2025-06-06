import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final nameController = TextEditingController();
  bool isLoading = false;
  String error = '';

  Future<void> createGroup() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      setState(() => error = "Nombre del grupo obligatorio");
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('groups').add({
        'owner': uid,
        'name': name,
        'students': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'lastAttendance': null,
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() => error = 'Error al crear el grupo: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear nuevo grupo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre del grupo'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : createGroup,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Crear Grupo'),
            ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(error, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
