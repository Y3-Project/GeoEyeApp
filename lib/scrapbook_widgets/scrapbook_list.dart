import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_tile.dart';
import 'package:provider/provider.dart';

class ScrapbookList extends StatefulWidget {
  const ScrapbookList({Key? key}) : super(key: key);

  @override
  State<ScrapbookList> createState() => _ScrapbookListState();
}

class _ScrapbookListState extends State<ScrapbookList> {
  @override
  Widget build(BuildContext context) {
    final scrapbooks = Provider.of<List<Scrapbook>>(context);

    return ListView.builder(
      itemCount: scrapbooks.length,
      itemBuilder: (context, index){
        return ScrapbookTile(scrapbooks[index]);
      },
    );
  }
}
