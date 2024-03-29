import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post_tile.dart';
import 'package:flutter_app_firebase_login/user_authentication_widgets/forgot_password_page.dart';
import 'package:flutter_app_firebase_login/user_authentication_widgets/welcome_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../user_authentication_widgets/login_page.dart';

//TODO Redesign this page to make it more attractive

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //method to log the user out
    Future<void> logout() async {
      await FirebaseAuth.instance.signOut();

      // remove cached credentials
      final storage = new FlutterSecureStorage();
      print('Deleting credentials from secure storage');
      storage.delete(key: 'email');
      storage.delete(key: 'password');

      Navigator.popUntil(context, (route) => false);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(onSignIn: (user) {}),
        ),
      );
    }

    Future<void> deleteUser() async {
      //delete from Firebase Authentication
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      user?.delete();

      //delete from Firestore Database
      final _db = FirebaseFirestore.instance;
      await _db.collection("users").doc(user?.uid).delete();
    }

    //pop up dialog when 'Delete Account" button pressed
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text('Account Deletion',
                style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Are you sure you want to delete your account?',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 23)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  deleteUser();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                  SnackBar snack1 = SnackBar(
                      content: Text('Your account has been deleted',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      duration: Duration(seconds: 2));
                  ScaffoldMessenger.of(context).showSnackBar(snack1);
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
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size(150, 20)),
                      backgroundColor: MaterialStatePropertyAll(Colors.black)),
                  onPressed: () {
                    logout();
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                flex: 1,
                fit: FlexFit.loose,
              ),
              Flexible(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black)),
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                flex: 1,
                fit: FlexFit.loose,
              ),
              Flexible(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black)),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                flex: 1,
                fit: FlexFit.loose,
              )
            ]));
  }
}
