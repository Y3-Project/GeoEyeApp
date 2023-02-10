import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandedPostPage extends StatefulWidget {
  String imgURL;
  String title;
  ExpandedPostPage(this.imgURL, this.title);

  @override
  State<ExpandedPostPage> createState() => _ExpandedPostPageState();
}

class _ExpandedPostPageState extends State<ExpandedPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(widget.imgURL == "" ? "https://www.myutilitygenius.co.uk/assets/images/blogs/default-image.jpg" : widget.imgURL),
        ],
      ),
    );
  }
}
