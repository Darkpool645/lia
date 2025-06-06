import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    final credentials = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credentials.user;
  }

  Future<User?> register(String email, String password) async {
    final credentials = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credentials.user;
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
