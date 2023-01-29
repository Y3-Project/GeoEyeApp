import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/welcome_page.dart';

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



    //pop up dialog when 'Delete Account" button pressed
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text('Account Deletion', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Are you sure you want to delete your account?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  user?.delete();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WelcomePage()),
                  );
                },
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
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
      body: Column(children: [ElevatedButton(
          style: ButtonStyle(
              fixedSize: MaterialStatePropertyAll(Size(150, 20)),
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
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                MaterialStatePropertyAll(Colors.black)),
            onPressed: () {
              _showMyDialog();
            },
            child: const Text(
              'Delete Account',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ))])
    );
  }
}
