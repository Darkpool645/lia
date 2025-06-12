import 'package:flutter/material.dart';
import 'package:lia/models/group_model.dart';
import 'package:lia/services/student_service.dart';
import 'package:lia/models/student_model.dart';
import 'package:lia/screens/take_attendance_screen.dart';
import 'package:lia/screens/add_student_screen.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;
  final studentService = StudentService();
  GroupDetailScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'attendance') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TakeAttendanceScreen(group: group),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'attendance',
                child: Text('Tomar asistencia'),
              ),
            ],
          ),
        ],
      ),

      body: StreamBuilder<List<Student>>(
        stream: studentService.getStudents(group.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final students = snapshot.data ?? [];

          if (students.isEmpty) {
            return const Center(child: Text('No hay alumnos registrados.'));
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(student.name),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddStudentScreen(groupId: group.id),
            ),
          );
        },
        label: const Text('Agregar Alumnos'),
        icon: const Icon(Icons.person_add),
      ),
    );
  }
}
