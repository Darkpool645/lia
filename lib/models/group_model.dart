import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String name;
  final int studentCount;
  final DateTime? lastAttendance;
  final DateTime? createdAt;

  Group({
    required this.id,
    required this.name,
    required this.studentCount,
    this.lastAttendance,
    this.createdAt,
  });

  factory Group.fromMap(String id, Map<String, dynamic> data) {
    return Group(
      id: id,
      name: data['name'] ?? '',
      studentCount: data['students'] ?? 0,
      lastAttendance: data['lastAttendance'] != null
          ? (data['lastAttendance'] as Timestamp).toDate()
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}
