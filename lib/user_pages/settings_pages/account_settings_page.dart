import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../login_page.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //method to log the user out
    Future<void> logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(onSignIn: (user) {}),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Title(
              color: Colors.black,
              child: Text(
                "Account Settings",
                style: TextStyle(fontSize: 25),
              ))),
      body: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStatePropertyAll(Colors.black)),
          onPressed: () {
            logout();
          },
          child: const Text(
            'Logout',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18),
          )),
    );
  }
}
