import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/login_page.dart';
import 'home_page.dart';

import 'generator.dart';
//generate a random username with UsernameGen().generate()

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
  String username = '';

  String username1 = UsernameGen().generate();
  String username2 = UsernameGen().generate();
  String username3 = UsernameGen().generate();

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
          title:
              const Text('Create an account', style: TextStyle(fontSize: 25)),
        ),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          TextFormField(
            controller: _controllerEmail,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          Text("Please pick a username amongst the three shown",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
                onTap: () {
                  username = username1;
                },
                child: Text(username1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.lightBlue))),
            SizedBox(height: 25),
            GestureDetector(
                onTap: () {
                  username = username2;
                },
                child: Text(username2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.lightBlue))),
            SizedBox(height: 25),
            GestureDetector(
                onTap: () {
                  username = username3;
                },
                child: Text(username3,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.lightBlue)))
          ]),
          TextFormField(
            controller: _controllerPassword,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),
          Text(error!),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
            onPressed: () {
              createUser();
              //TODO {send username, email, and uid of user to database here}
            },
            child: Text(
              style: TextStyle(fontSize: 20),
              'Sign-up',
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginPage(onSignIn: (user) {}),
              ),
            ),
            child: Text(
              "Already have an account?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ]));
  }
}
