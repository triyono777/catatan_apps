import 'package:catatan_apps/screen/login_screen.dart';
import 'package:catatan_apps/services/firebase_auth_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home screen'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuthServices().logout().then((value) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              });
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
