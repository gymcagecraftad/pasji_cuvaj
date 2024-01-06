// auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<firebase_auth.User?> signInWithEmailAndPassword(
    String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<firebase_auth.User?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String surname,
    String username,
  ) async {
    try {
      firebase_auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      firebase_auth.User? user = result.user;

      // Update user profile with display name
      await user?.updateDisplayName(username);

      // Store additional user information in Firestore
      await _firestore.collection('users').doc(user?.uid).set({
        'name': name,
        'surname': surname,
        'username': username,
      });

      return user;
    } catch (e) {
      print('Error registering: $e');
      return null;
    }
  }
  String? getCurrentUserDisplayName(){
    return _auth.currentUser?.displayName;
  }
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
  String? getCurrentUserUid() {
    return _auth.currentUser?.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
