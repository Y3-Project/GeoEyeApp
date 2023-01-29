import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_firebase_login/create_account_page.dart';
import 'package:flutter_app_firebase_login/moderator_page.dart';
import 'forgot_password_page.dart';
import 'user_pages/main_page.dart';

class LoginPage extends StatefulWidget {
  final Function(User?) onSignIn;
  const LoginPage({required this.onSignIn});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user;
  //final TextEditingController _controllerEmail = TextEditingController();
  String userEmail = '';
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String? error = '';

  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    //access firestore database here to get the corresponding email
    Future<String> getEmailFromUsername() async {
      String email = '';
      QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection("users")
          .where("username", isEqualTo: _controllerUsername.text)
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
        email = doc.get('email');
      }
      return email;
    }

    //method for logging the user in
    Future<void> loginUser() async {
      try {
        userEmail = await getEmailFromUsername();
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: userEmail, password: _controllerPassword.text);
        // TODO: if user is banned, then throw an exception here!
        // get userCredential.user?.uid; then use this uid to ask firestore whether the
        // user document with this uid has banned == true, if so then throw an exception
        widget.onSignIn(userCredential.user);
        bool moderator = false;
        final snap = await FirebaseFirestore.instance
            .collection('users')
            .where("moderator", isEqualTo: true)
            .where("username", isEqualTo: _controllerUsername.text)
            .get();
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snap.docs) {
          moderator = doc.get('moderator');
        }
        if (moderator == true) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ModeratorPage(
                    onSignOut: (userCred) {
                      onRefresh(userCred);
                    },
                  )));
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MainUserPage(
                onSignOut: (userCred) {
                  onRefresh(userCred);
                },
              ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'unknown') {
            error = 'Please enter the correct username';
          } else if (e.code == 'wrong-password') {
            error = 'Please enter the correct password';
          } else {
            error = 'Please enter the correct username';
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Sign in to your account',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Column(
        children: [
          TextFormField(
              controller: _controllerUsername,
              decoration: const InputDecoration(labelText: "Username")),
          TextFormField(
              controller: _controllerPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password")),
          Text(error!),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
            onPressed: () {
              loginUser();
            },
            child: const Text(style: TextStyle(fontSize: 25), "Login"),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ForgotPasswordPage(),
              ),
            ),
            child: const Text(
              "Forgot Password?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignUpPage(onSignIn: (user) {}),
              ),
            ),
            child: const Text(
              "Don't have an account?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
