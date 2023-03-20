import 'package:flutter/material.dart';

class titleCaptionForPost extends StatefulWidget {
  titleCaptionForPost({Key? key}) : super(key: key);
  static String postTitle = '';
  static String postCaption = '';

  @override
  State<titleCaptionForPost> createState() => _titleCaptionForPostState();
}

class _titleCaptionForPostState extends State<titleCaptionForPost> {
  final titleTextController = TextEditingController();
  final descTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: TextField(
          onEditingComplete: () {
            setState(() {
              titleCaptionForPost.postTitle = titleTextController.text;
            });
            titleTextController.clear();
          },
          controller: titleTextController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: 'Enter a title for the post...'),
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 50),
        child: TextField(
          onEditingComplete: () {
            setState(() {
              titleCaptionForPost.postCaption = descTextController.text;
            });
            descTextController.clear();
          },
          maxLength: 40,
          controller: descTextController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: 'Enter a caption for the post...'),
        ),
      ),
    ]));
  }
}
