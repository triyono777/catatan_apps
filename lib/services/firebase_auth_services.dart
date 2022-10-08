import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    var box = await Hive.box('userBox');
    box.put('uid', user.user?.uid);
    box.put('email', user.user?.email);
    return user;
  }

  Future logout() async {
    _fbAuth.signOut();
    var box = Hive.box('userBox');
    box.clear();
  }
}
