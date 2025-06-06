import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lia/models/student_model.dart';

class StudentService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Student>> getStudents(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('students')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Student.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
