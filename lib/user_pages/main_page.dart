import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/user_pages/home_widget.dart';
import 'package:flutter_app_firebase_login/user_pages/notifications_widget.dart';
import 'package:flutter_app_firebase_login/user_pages/profile_page.dart';

class MainUserPage extends StatefulWidget {
  const MainUserPage({Key? key}) : super(key: key);

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
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

  Widget getSelectedPage({required int index}) {
    Widget widgetPage;
    if (index == 0) {
      widgetPage = ProfilePage();
    } else if (index == 2) {
      widgetPage = NotificationsWidget();
    } else {
      widgetPage = HomeWidget();
    }
    return widgetPage;
  }
}
