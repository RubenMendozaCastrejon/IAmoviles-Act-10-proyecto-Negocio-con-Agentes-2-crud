import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = credential.user;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('usuarios').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromJson(doc.data() as Map<String, dynamic>, uid: user.uid);
        } else {
          return UserModel(uid: user.uid, email: email, nombre: 'Usuario', rol: 'cliente');
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error en autenticación: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}