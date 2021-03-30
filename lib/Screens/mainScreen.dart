import 'package:flutter/material.dart';
import '../Backend/backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MainScreen extends StatelessWidget {

  const MainScreen();
  static const String routeName = '/MainScreen';
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(_auth.currentUser!.photoURL ?? 'failed'),
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
            Auth.logOut();
          })
        ],
      ),
      body: Center(
          child: const CircularProgressIndicator.adaptive(),),
    );
  }
}
