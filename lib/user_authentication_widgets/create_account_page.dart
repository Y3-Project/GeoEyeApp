import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/user_authentication_widgets/login_page.dart';
import 'package:flutter_app_firebase_login/user_pages/main_page.dart';

import '../username_generator_widgets/generator.dart';
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
  String selectedUsername = '';

  static String username1 = UsernameGen().generate();
  static String username2 = UsernameGen().generate();
  static String username3 = UsernameGen().generate();

  SnackBar snack1 = SnackBar(
      content: Text(username1 + " selected!"), duration: Duration(seconds: 1));
  SnackBar snack2 = SnackBar(
      content: Text(username2 + " selected!"), duration: Duration(seconds: 1));
  SnackBar snack3 = SnackBar(
      content: Text(username3 + " selected!"), duration: Duration(seconds: 1));

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  /** sends user information to the firestore database
   *
   */
  Future<void> sendUserInformationToFirestore(
      String email, bool moderator, String username, User? user) async {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      'banned': false,
      'biography': "",
      'blockedUsers': [],
      'email': email,
      'followers': [], // todo: list of user ids that follow the user
      'following':
          [], // todo: this should be an arr of uuids that the user follows
      'moderator': moderator,
      'profilePicture': "",
      'reports': [],
      'timeoutStart': "", // timeout date will be stored as a string
      'username': username,
      'uuid': user?.uid
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
        await sendUserInformationToFirestore(_controllerEmail.text, false,
            selectedUsername, userCredential.user);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MainUserPage(),
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
                  setState(() {
                    selectedUsername = username1;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(snack1);
                },
                child: Text(username1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: selectedUsername == username1 ? 20 : 16,
                        color: selectedUsername == username1
                            ? Colors.green
                            : Colors.lightBlue))),
            SizedBox(height: 25),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedUsername = username2;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(snack2);
                },
                child: Text(username2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: selectedUsername == username2 ? 20 : 16,
                        color: selectedUsername == username2
                            ? Colors.green
                            : Colors.lightBlue))),
            SizedBox(height: 25),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedUsername = username3;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(snack3);
                },
                child: Text(username3,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: selectedUsername == username3 ? 20 : 16,
                        color: selectedUsername == username3
                            ? Colors.green
                            : Colors.lightBlue)))
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
