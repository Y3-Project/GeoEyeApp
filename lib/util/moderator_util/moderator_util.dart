import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<void> deletePost(QueryDocumentSnapshot snapshot) async {
  print("DELETING POST: ${snapshot.id}");
  // todo: implement
}

Future<Row> getTextPosts(QueryDocumentSnapshot postDocument) async {
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

Future<Row> getVideoPosts(QueryDocumentSnapshot postDocument) async {
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

Future<String> loadText(QueryDocumentSnapshot postDocument) async {
  return postDocument.get("text");
}

Future<Image> loadImage(QueryDocumentSnapshot postDocument) async {
  var s = await postDocument.get("picture");
  Image im = Image.network(
    s,
    height: 100.0,
  );
  return im;
}

Future<Row> getPicturePosts(QueryDocumentSnapshot snapshot) async {
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
  if (post.get("text") != "") {
    return await getTextPosts(post);
  }
  if (post.get("picture") != "") {
    return await getPicturePosts(post);
  }
  if (post.get("video") != "") {
    return await getVideoPosts(post);
  }
  return Row(); // this will be empty
}
