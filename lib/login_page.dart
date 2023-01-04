import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function(User?) onSignIn;
  const LoginPage({required this.onSignIn});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String? error = '';
  bool login = true;

  @override
  Widget build(BuildContext context) {
    Future<void> loginAno() async {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      widget.onSignIn(userCredential.user);
    }

    Future<void> loginUser() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _controllerEmail.text,
                password: _controllerPassword.text);

        widget.onSignIn(userCredential.user);
      } on FirebaseAuthException catch (e) {
        setState(() {
          error = e.message;
        });
      }
    }

    Future<void> createUser() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _controllerEmail.text,
                password: _controllerPassword.text);

        widget.onSignIn(userCredential.user);
      } on FirebaseAuthException catch (e) {
        setState(() {
          error = e.message;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Column(
        children: [
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
            onPressed: () {
              loginUser();
            },
            child: const Text(
                style: TextStyle(fontSize: 20),
                "Login"),
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
              )),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
            onPressed: () {
              setState(() {
                login = !login;
              });
            },
            child: const Text(
              style: TextStyle(fontSize: 20),
              "Sign-up if you don't have an account yet",
            ),
          )
        ],
      ),
    );
  }
}
