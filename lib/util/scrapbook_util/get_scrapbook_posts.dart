import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/util/get_docs_from_firebase.dart';

import '../../post_widgets/post.dart';
import '../../scrapbook_widgets/scrapbook.dart';

Future<List<DocumentReference>> getScrapbookPostsFromScrapbook(Scrapbook scrapbook) async {
  DocumentReference scrapbookRef =
  FirebaseFirestore.instance.doc("/scrapbooks/" + scrapbook.id);
  List<DocumentReference> scrapbookPostRefs = await getDocRefs("scrapbookPosts", "scrapbook", scrapbookRef);
  return scrapbookPostRefs;
}

Future<List<DocumentReference>> getScrapbookPostsFromPost(Post post) async {
  DocumentReference postRef =
  FirebaseFirestore.instance.doc(post.id.path);
  List<DocumentReference> scrapbookPostRefs = await getDocRefs("scrapbookPosts", "post", postRef);
  return scrapbookPostRefs;
}
