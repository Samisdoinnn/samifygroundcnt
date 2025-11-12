import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final newUser = UserModel(
        id: result.user!.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(newUser.id).set(newUser.toJson());
      return newUser;
    } catch (e) {
      // ignore: avoid_print
      print('Registration error: $e');
      return null;
    }
  }

  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc =
          await _firestore.collection('users').doc(result.user!.uid).get();
      if (!doc.exists) {
        return null;
      }
      final data = doc.data()!..putIfAbsent('id', () => doc.id);
      return UserModel.fromJson(data);
    } catch (e) {
      // ignore: avoid_print
      print('Login error: $e');
      return null;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final doc =
          await _firestore.collection('users').doc(result.user!.uid).get();

      if (doc.exists) {
        final data = doc.data()!..putIfAbsent('id', () => doc.id);
        return UserModel.fromJson(data);
      }

      final newUser = UserModel(
        id: result.user!.uid,
        name: result.user!.displayName ?? 'User',
        email: result.user!.email ?? '',
        photoUrl: result.user!.photoURL,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(newUser.id).set(newUser.toJson());
      return newUser;
    } catch (e) {
      // ignore: avoid_print
      print('Google sign-in error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  User? getCurrentUser() => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}


