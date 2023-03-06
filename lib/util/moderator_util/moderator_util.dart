import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deletePost(QueryDocumentSnapshot post) async {
  print("DELETING POST: ${post.id}");
  var inst = FirebaseFirestore.instance.collection('posts');
  deletePostFromScrapbookPosts(post);
  inst.doc("${post.id}").delete();
}

Future<void> deletePostFromScrapbookPosts(QueryDocumentSnapshot post) async {
  var scrapInst = FirebaseFirestore.instance.collection("scrapbookPosts");
  scrapInst.snapshots().listen((event) {
    for (var doc in event.docs) {
      DocumentReference p = doc.get("post");
      if (p.path == post.reference.path) {
        print("deleting scrapbook post ${doc.reference.path}");
        FirebaseFirestore.instance.doc(doc.reference.path).delete();
      }
    }
  });
}

void allowPostOrCommentOrUser(QueryDocumentSnapshot postCommentUser) {
  print(
      "allow post/comment/user ${postCommentUser.reference.path}, all reports will be removed");
  String path = postCommentUser.reference.path;
  var doc = FirebaseFirestore.instance.doc(path);
  doc.update({"reports": []});
  return;
}

Future<void> timeoutUserFromPostOrComment(
    QueryDocumentSnapshot postOrComment) async {
  print(
      "timing out user ${postOrComment.get("user")} from document: ${postOrComment.id}");
  String path = getUserDocumentPath(postOrComment);
  DocumentReference user = FirebaseFirestore.instance.doc(path);
  user.update({"timeoutStart": Timestamp.now()});
}

Future<void> banUserFromPostOrComment(
    QueryDocumentSnapshot postOrComment) async {
  print(
      "banning user ${postOrComment.get("user")} for comment ${postOrComment.reference.path}");
  String path = getUserDocumentPath(postOrComment);
  DocumentReference user = FirebaseFirestore.instance.doc(path);
  user.update({"banned": true});
}

Future<void> deleteComment(QueryDocumentSnapshot comment) async {
  print("DELETING COMMENT ${comment.id}");
  var inst = FirebaseFirestore.instance.collection('postComments');
  inst.doc("${comment.id}").delete();
}

String getUserDocumentPath(QueryDocumentSnapshot postOrComment) {
  DocumentReference userDoc = postOrComment.get("user");
  return userDoc.path;
}
