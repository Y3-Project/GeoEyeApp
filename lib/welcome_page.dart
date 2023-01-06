import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/create_account_page.dart';
import 'package:flutter_app_firebase_login/login_page.dart';

import 'home_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        AppBar(
          centerTitle: true,
          title: Text('GeoEye', style: TextStyle(fontSize: 25)),
        ),
        Text(
          'Hi, welcome to GeoEye.',
          style: TextStyle(fontSize: 20),
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SignUpPage(onSignIn: (user) {}),
                ),
              );
            },
            child: Text('Sign-up')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginPage(onSignIn: (user) {}),
                ),
              );
            },
            child: Text('Login'))
      ]),
    );
  }
}
