import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deletePost(QueryDocumentSnapshot post) async {
  print("DELETING POST: ${post.id}");
  var inst = FirebaseFirestore.instance.collection('posts');
  inst.doc("${post.id}").delete();
  deletePostFromScrapbookPosts(post.reference);
}

void deletePostFromScrapbookPosts(DocumentReference postReference) {
  var scrapInst = FirebaseFirestore.instance.collection("scrapbooksPosts");
  var cond = scrapInst.where("post", isEqualTo: postReference);
  var doc = cond.snapshots().first;
  doc.then((value) => scrapInst.doc(value.docs.first.reference.path).delete());
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
