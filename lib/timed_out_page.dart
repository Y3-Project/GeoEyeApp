import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'login_page.dart';

class TimedOutPage extends StatefulWidget {
  final Function(User?) onSignOut;
  final String timeout;
  const TimedOutPage({required this.onSignOut, required this.timeout});
  @override
  State<StatefulWidget> createState() => _timedOutPageState(timeout: timeout);
}

class _timedOutPageState extends State<TimedOutPage> {
  final String timeout;
  _timedOutPageState({required this.timeout});

  @override
  Widget build(BuildContext context) {
    //method to log the user out
    Future<void> _logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(onSignIn: (user) {}),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Timed Out Page"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Text("You have been timeout"),
            Text("From ${this.timeout} for 24 hours!")
          ],
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () {
          _logout();
        },
        child: Text("logout"),
      ),
    );
  }
}
