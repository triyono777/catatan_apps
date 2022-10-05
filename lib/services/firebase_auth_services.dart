import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  Future<UserCredential?> registerAkun({
    required String email,
    required String password,
  }) async {
    var user = await _fbAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  Future<UserCredential?> loginAkun({
    required String email,
    required String password,
  }) async {
    var user = await _fbAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user;
  }
}
