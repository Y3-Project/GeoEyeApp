import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/util/moderator_comments.dart';
import 'package:flutter_app_firebase_login/util/moderator_page.dart';
import 'package:flutter_app_firebase_login/util/moderator_user_page.dart';

class ModeratorWidget extends StatefulWidget {
  final Function(User?) onSignOut;
  const ModeratorWidget({required this.onSignOut});
  @override
  State<ModeratorWidget> createState() => _moderatorWidgetState();
}

class _moderatorWidgetState extends State<ModeratorWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 10,
            backgroundColor: Colors.black,
            centerTitle: true,
            bottom: TabBar(
              labelStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              indicatorColor: Colors.white,
              tabs: const [
                Tab(
                  text: "Posts",
                ),
                Tab(
                  text: "Comments",
                ),
                Tab(
                  text: "Users",
                )
              ],
            )),
        body: const TabBarView(children: <Widget>[
          ModeratorPage(),
          ModeratorCommentsPage(),
          ModeratorUserPage()
        ]),
      ),
    );
  }
}
