/**
 * TEMPLATE PAGE
 * NOT IN USE
 */

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({Key? key}) : super(key: key);

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage>  with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 10,
          backgroundColor: Colors.black,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            controller: _tabController,
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
          )
      ),

      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Colors.white
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        index: 1,
        color: Colors.black,
        items: const <Widget>[
          Icon(Icons.person, size: 20, color: Colors.white),
          Icon(Icons.home_outlined, size: 40, color: Colors.white),
          Icon(Icons.notifications, size: 20, color: Colors.white),
        ],
        onTap: (index) {
        }, //Handle button tap

      ),

    );
  }
}
