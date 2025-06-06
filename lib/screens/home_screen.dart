import 'package:flutter/material.dart';
import 'package:lia/services/auth_service.dart';
import 'package:lia/services/group_service.dart';
import 'package:lia/models/group_model.dart';
import 'package:intl/intl.dart';
import 'package:lia/screens/create_group_screen.dart';
import 'package:lia/screens/group_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final groupService = GroupService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendo 🏫'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Group>>(
        stream: groupService.getUserGroups(),
        builder: (content, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final groups = snapshot.data ?? [];

          if (groups.isEmpty) {
            return const Center(child: Text('No tienes grupos registrados'));
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              final lastDate = group.lastAttendance != null
                  ? DateFormat('dd MM yyyy').format(group.lastAttendance!)
                  : 'Sin registros';

              return ListTile(
                leading: CircleAvatar(child: Text(group.name[0].toUpperCase())),
                title: Text(group.name),
                subtitle: Text('Última asistencia: $lastDate'),
                trailing: Text('${group.studentCount} alumnos'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GroupDetailScreen(group: group),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
          );
        },
        child: const Icon(Icons.group_add),
      ),
    );
  }
}
