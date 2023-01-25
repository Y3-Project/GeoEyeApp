import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Text("Home"),
        ),
      ),
    );
  }
}
