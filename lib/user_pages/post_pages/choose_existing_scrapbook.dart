import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_list.dart';

class ChooseScrapbookPage extends StatefulWidget {
  const ChooseScrapbookPage({Key? key}) : super(key: key);

  @override
  State<ChooseScrapbookPage> createState() => _ChooseScrapbookPageState();
}

class _ChooseScrapbookPageState extends State<ChooseScrapbookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrapbookList(),
    );
  }
}
