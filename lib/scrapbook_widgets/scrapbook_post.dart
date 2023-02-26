import 'package:cloud_firestore/cloud_firestore.dart';

class ScrapbookPost {
  DocumentReference postRef = FirebaseFirestore.instance.doc('posts/W9mNhinT7muurZpKLaUi'); // post reference
  DocumentReference scrapbookRef = FirebaseFirestore.instance.doc('scrapbooks/RwUuDlNyACEZqbrHpdtj'); // scrapbook reference

  /* Constructor */
  ScrapbookPost(
      {required this.postRef,
        required this.scrapbookRef});
}
