import 'package:cloud_firestore/cloud_firestore.dart';

import '../../post_widgets/post.dart';
import '../../scrapbook_widgets/scrapbook.dart';

Future<Scrapbook> getScrapbookFromPost(Post post) async {
  Scrapbook scrapbook = Scrapbook(
      id: '',
      creatorid: '',
      scrapbookTitle: '',
      scrapbookThumbnail: '',
      currentUsername: '',
      location: GeoPoint(0, 0),
      timestamp: Timestamp(0, 0),
      public: false,
      thumbnailStoragePath: '');
  DocumentReference postRef = FirebaseFirestore.instance.doc(post.id.path);
  QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
      .collection("scrapbookPosts")
      .where("post", isEqualTo: postRef)
      .get();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
  for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
    DocumentReference scrapbookRef = doc.get('scrapbook') as DocumentReference;
    scrapbook = Scrapbook.fromDocument(await scrapbookRef.get());
  }
  return await scrapbook;
}
