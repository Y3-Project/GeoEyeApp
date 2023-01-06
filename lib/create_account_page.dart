import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/decision_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_firebase_login/login_page.dart';

import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  final Function(User?) onSignIn;
  const SignUpPage({required this.onSignIn});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  User? user;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String? error = '';

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    //method to create a user in the Firebase account
    Future<void> createUser() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _controllerEmail.text,
                password: _controllerPassword.text);

        widget.onSignIn(userCredential.user);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomePage(
              onSignOut: (userCred) {
                onRefresh(userCred);
              },
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          error = e.message;
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Create an account', style: TextStyle(fontSize: 25)),
        ),
        body: Column(children: [
          TextFormField(
            controller: _controllerEmail,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextFormField(
            controller: _controllerPassword,
            decoration: const InputDecoration(labelText: "Password"),
          ),
          Text(error!),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
            onPressed: () {
              createUser();
            },
            child: const Text(
              style: TextStyle(fontSize: 20),
              "Sign-up",
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginPage(onSignIn: (user){}),
              ),
            ),
            child: const Text(
              "Already have an account?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ]));
  }
}
