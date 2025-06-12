import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lia/models/group_model.dart';
import 'package:lia/models/student_model.dart';
import 'package:lia/services/student_service.dart';

class TakeAttendanceScreen extends StatefulWidget {
  final Group group;
  const TakeAttendanceScreen({super.key, required this.group});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  final studentService = StudentService();
  final selectedStudents = <String>{};
  bool saving = false;
  String error = '';

  Future<void> saveAttendance() async {
    setState(() {
      saving = true;
      error = '';
    });

    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.group.id)
          .collection('attendances')
          .add({
            'date': FieldValue.serverTimestamp(),
            'students': selectedStudents.toList(),
          });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Asistencia registrada')));
      Navigator.pop(context);
    } catch (e) {
      setState(() => error = "Error al guardar: $e");
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asistencia - ${widget.group.name}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Student>>(
              stream: studentService.getStudents(widget.group.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final students = snapshot.data ?? [];

                if (students.isEmpty) {
                  return const Center(
                    child: Text('No hay alumnos disponibles'),
                  );
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final isSelected = selectedStudents.contains(student.id);
                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(student.name),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedStudents.add(student.id);
                          } else {
                            selectedStudents.remove(student.id);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(error, style: const TextStyle(color: Colors.red)),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: saving ? const CircularProgressIndicator() : const Text('Registrar asistencia'),
              onPressed: saving || selectedStudents.isEmpty ? null : saveAttendance,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ),
        ],
      ),
    );
  }
}
