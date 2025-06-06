import 'package:flutter/material.dart';
import 'package:lia/models/group_model.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;
  const GroupDetailScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Center(
        child: Text('Aqui se mostrara la lista de alumnos del grupo ${group.name}'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO. Navigate to add new students
        },
        label: const Text('Agregar Alumnos'),
        icon: const Icon(Icons.person_add),
      ),
    );
  }
}
