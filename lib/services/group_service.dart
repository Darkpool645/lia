import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lia/models/group_model.dart';

class GroupService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<Group>> getUserGroups() {
    final uid = _auth.currentUser!.uid;

    return _firestore
        .collection('groups')
        .where('owner', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Group.fromMap(doc.id, doc.data());
          }).toList();
        });
  }
}
