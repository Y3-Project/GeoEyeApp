import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_tile.dart';
import 'package:provider/provider.dart';

class ScrapbookList extends StatefulWidget {
  //TODO: Add fields for filtering by username and location
  //for filtering by location, geolocator package may be useful; it has "distanceFilter"
  //distanceFilter: the minimum distance (measured in meters) a device must move horizontally before an update event is generated;
  const ScrapbookList({Key? key}) : super(key: key);

  @override
  State<ScrapbookList> createState() => _ScrapbookListState();
}

class _ScrapbookListState extends State<ScrapbookList> {
  List<Scrapbook> getPublicScrapbooks(List<Scrapbook> scrapbooks) {
    List<Scrapbook> publicScrapbooks = [];

    scrapbooks.forEach((scrapbook) {
      if (scrapbook.public) {
        publicScrapbooks.add(scrapbook);
      }
    });

    return publicScrapbooks;
  }

  @override
  Widget build(BuildContext context) {
    final scrapbooks = Provider.of<List<Scrapbook>>(context);
    List<Scrapbook> publicScrapbooks = getPublicScrapbooks(scrapbooks);

    return ListView.builder(
      itemCount: publicScrapbooks.length,
      itemBuilder: (context, index) {
        return ScrapbookTile(publicScrapbooks[index]);
      },
    );
  }
}
