import 'package:flutter/material.dart';

class ScrapbookTitle extends StatefulWidget {
  const ScrapbookTitle({Key? key}) : super(key: key);

  String getTitle(){
    return _ScrapbookTitleState().scrapbookTitle;
  }

  @override
  State<ScrapbookTitle> createState() => _ScrapbookTitleState();
}

class _ScrapbookTitleState extends State<ScrapbookTitle> {
  TextEditingController _scrapbookTitleController = new TextEditingController();
  String scrapbookTitle = '';

  @override
  Widget build(BuildContext context) {

    return TextField(
      onEditingComplete: () {
        setState(() {
          scrapbookTitle = _scrapbookTitleController.text;
        });
        _scrapbookTitleController.clear();
      },
      controller: _scrapbookTitleController,
      maxLength: 40,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 18),
          hintText: 'Enter a title for your scrapbook here',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20))),
    );
  }
}
