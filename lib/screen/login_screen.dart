import 'package:catatan_apps/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:catatan_apps/services/firebase_auth_services.dart';
import 'package:catatan_apps/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuthServices fbServices = FirebaseAuthServices();

  login() async {
    fbServices
        .loginAkun(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${value?.user?.email} succes login'),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('login'),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'email',
                hintText: 'masukkan email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'password',
                hintText: 'masukkan password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: Text('Login'),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RegisterScreen(),
                  ),
                );
              },
              child: Text('Belum punya akun? daftar disini'),
            ),
          ],
        ),
      ),
    );
  }
}
