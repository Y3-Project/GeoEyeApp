import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScrapbookList extends StatefulWidget {
  const ScrapbookList({Key? key}) : super(key: key);

  @override
  State<ScrapbookList> createState() => _ScrapbookListState();
}

// TODO: this page should display a list of existing scrapbooks for the current user

class _ScrapbookListState extends State<ScrapbookList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'My Scrapbooks',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
