import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../login_page.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Profile Page"),
      ),
      body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("User Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),))
            ],
          )),
    );
  }
}
