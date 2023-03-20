import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/util/get_docs_from_firebase.dart';

import '../../post_widgets/post.dart';
import '../../scrapbook_widgets/scrapbook.dart';

Future<List<DocumentReference>> getMarkerFromScrapbook(Scrapbook scrapbook) async {
  DocumentReference scrapbookRef =
  FirebaseFirestore.instance.doc("/scrapbooks/" + scrapbook.id);
  List<DocumentReference> markerRefs = await getDocRefs("markers", "scrapbookRef", scrapbookRef);
  return markerRefs;
}


