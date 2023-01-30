import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({Key? key}) : super(key: key);

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  @override
  Widget build(BuildContext context) {

    /*
    Future<List<String>> getNotifications() async {

    }
     */

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Notifications", style: TextStyle(fontSize: 25),),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Text("Notifications"),
      ),
    );
  }
}
