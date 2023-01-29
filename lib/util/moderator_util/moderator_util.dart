import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> deletePost(QueryDocumentSnapshot snapshot) async {
  print("DELETING POST: ${snapshot.id}");
  var inst = FirebaseFirestore.instance.collection('posts');
  inst.doc("/posts/${snapshot.id}").delete();
}

Future<void> timeoutUserFromPost(QueryDocumentSnapshot post) async {
  print("timing out user from document: ${post.id}");
  // TODO: implement
}

Future<void> banUserFromPost(QueryDocumentSnapshot post) async {
  // TODO: implement
}

Future<Row> getTextPost(QueryDocumentSnapshot postDocument) async {
  return Row(
    children: [
      Expanded(
        child: Text(postDocument.get("text"), textAlign: TextAlign.center),
      ),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            deletePost(postDocument);
          },
          child: Text("Delete"),
        ),
      )
    ],
  );
}

Future<Row> getVideoPost(QueryDocumentSnapshot postDocument) async {
  // currently this would just show the URL
  return Row(
    children: [
      Expanded(
          child: Text(
        postDocument.get("video"),
        textAlign: TextAlign.center,
      )),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            deletePost(postDocument);
          },
          child: const Text("Delete"),
        ),
      )
    ],
  );
}

Future<Image> loadImage(QueryDocumentSnapshot postDocument) async {
  var s = await postDocument.get("picture");
  return Image.network(
    s,
    height: 100.0,
  );
}

Future<Row> getPicturePost(QueryDocumentSnapshot snapshot) async {
  return Row(
    children: [
      Expanded(
        child: Container(
            child: await loadImage(snapshot), alignment: Alignment.center),
      ),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            deletePost(snapshot);
          },
          child: const Text("Delete"),
        ),
      )
    ],
  );
}

Future<Row> getPost(QueryDocumentSnapshot post) async {
  bool textPresent = (post.get("text") != "" && post.get("text") != null);
  bool noTextPresent = (post.get("text") == "" || post.get("text") == null);
  bool picturePresent =
      (post.get("picture") != "" && post.get("picture") != null);
  bool noPicturePresent =
      (post.get("picture") == "" || post.get("picture") == null);
  bool videoPresent = (post.get("video") != "" && post.get("video") != null);
  bool noVideoPresent = (post.get("video") == "" || post.get("video") == null);

  // for a particular post, only one of text, picture, and video can not be ""
  if (textPresent && noPicturePresent && noVideoPresent) {
    print("text detected ${post.id}");
    return await getTextPost(post);
  } else if (picturePresent && noTextPresent && noVideoPresent) {
    print("picture detected ${post.id}");
    return await getPicturePost(post);
  } else if (videoPresent && noTextPresent && noPicturePresent) {
    return await getVideoPost(post);
  }
  return Row(children: [Text("Error")]);
}
