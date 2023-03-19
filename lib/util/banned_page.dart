import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user_authentication_widgets/login_page.dart';

class BannedPage extends StatefulWidget {
  final Function(User?) onSignOut;

  const BannedPage({required this.onSignOut});

  @override
  State<StatefulWidget> createState() => _bannedPageState();
}

class _bannedPageState extends State<BannedPage> {
  //method to log the user out
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginPage(onSignIn: (user) {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banned page"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Text(
              "You have been banned from the application",
              textAlign: TextAlign.center,
            ),
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
