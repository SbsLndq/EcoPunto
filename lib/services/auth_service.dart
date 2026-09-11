import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registrar usuario
  Future<User?> register(
    String email,
    String password,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  // Iniciar sesión
  Future<User?> login(
    String email,
    String password,
  ) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Usuario actualmente autenticado
  User? get currentUser => _auth.currentUser;
}