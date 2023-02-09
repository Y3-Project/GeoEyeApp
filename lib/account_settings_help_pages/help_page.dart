import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//TODO This page will show users how to navigate around the app, etc


class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Title(
                color: Colors.black,
                child: Text("Help", style: TextStyle(fontSize: 25)))));
  }
}
