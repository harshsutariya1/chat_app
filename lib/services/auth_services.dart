import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? user;
  
  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        user = credential.user;
        return true;
      }
    } catch (e) {
      print("Error: $e");
    }
    return false;
  }

  Future<bool> signup(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        user = credential.user;
        return true;
      }
    } catch (e) {
      print("Error: $e");
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      user = null;
      return true;
    } catch (e) {
      print("Error: $e");
    }
    return false;
  }
}
