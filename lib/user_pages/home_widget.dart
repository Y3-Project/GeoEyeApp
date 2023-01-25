import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/user_pages/post_pages/ar_view_page.dart';
import 'package:flutter_app_firebase_login/user_pages/post_pages/feed_page.dart';
import 'package:flutter_app_firebase_login/user_pages/post_pages/map_view_page.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
              indicatorColor: Colors.white,
              tabs: const [
                Tab(
                  text: "Feed",
                ),
                Tab(
                  text: "Map View",
                ),
                Tab(
                  text: "AR View",
                )
              ],
            )),
        body: const TabBarView(
            children: <Widget>[
              FeedPage(),
              MapViewPage(),
              ARViewPage()
            ]
        ),
      ),
    );
  }
}
