import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/user_pages/home_widget.dart';
import 'package:flutter_app_firebase_login/user_pages/notifications_widget.dart';
import 'package:flutter_app_firebase_login/user_pages/profile_widget.dart';

import '../login_page.dart';

class MainUserPage extends StatefulWidget {
  final Function(User?) onSignOut;
  const MainUserPage({Key? key, required this.onSignOut}) : super(key: key);

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {
  int index = 1;

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
      body: getSelectedPage(index: index),

      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(microseconds: 199900),
        backgroundColor: Colors.white,
        index: index,
        color: Colors.black,
        items: const <Widget>[
          Icon(Icons.person, size: 20, color: Colors.white),
          Icon(Icons.home_outlined, size: 40, color: Colors.white),
          Icon(Icons.notifications, size: 20, color: Colors.white),
        ],
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        }, //Handle button tap

      ),

    );
  }

  Widget getSelectedPage({required int index}){
    Widget widgetPage;
    if (index == 0) {
      widgetPage = ProfileWidget();
    }
    else if (index == 2){
      widgetPage = NotificationsWidget();
    }
    else {
      widgetPage = HomeWidget();
    }
    return widgetPage;
  }
}
