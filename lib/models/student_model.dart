import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final DateTime? addedAt;

  Student({required this.id, required this.name, this.addedAt});

  factory Student.fromMap(String id, Map<String, dynamic> data) {
    return Student(
      id: id,
      name: data['name'] ?? '',
      addedAt: data['addedAt'] != null
        ? (data['addedAt'] as Timestamp).toDate()
        : null
    );
  }
}
