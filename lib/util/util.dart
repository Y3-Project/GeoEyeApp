import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

int distanceFromOneGeoPointToAnotherInKM(GeoPoint p1, GeoPoint p2) {
  final _geoLocatorPlatform = GeolocatorPlatform.instance;
  final res = _geoLocatorPlatform.distanceBetween(
      p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  return (res ~/ 1000);
}

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

/** getUserDocumentIDFromPost
 * 
 * this gets a user document id from a post
 * note: a post has a reference to a user, so we can get that document and its id
 * 
 */
String getUserDocumentIDFromPost(QueryDocumentSnapshot snap) {
  DocumentReference userDoc = snap.get("user");
  return userDoc.id;
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

Future<List<Row>> getPosts(QueryDocumentSnapshot post) async {
  List<Row> display = List.empty(growable: true);
  //TODO: this is buggy I think.
  if (post.get("text") != "") {
    display.add(await getTextPosts(post));
  } else if (post.get("picture") != "") {
    display.add(await getPicturePosts(post));
  } else if (post.get("video") != "") {
    display.add(await getVideoPosts(post));
  }
  return display;
}

/*
  @param: user: the user to be followed
  @param: newFollower: the user who is following the user

  @return: void

  todo: Return with various errors if we encounter issues
 */
void addFollower(String newFollower, String user) {
  // add follower to user's followers list
  FirebaseFirestore.instance.collection('users').doc(user).update({
    'followers': FieldValue.arrayUnion([newFollower])
  });

  // add following to new follower's following list
  FirebaseFirestore.instance.collection('users').doc(newFollower).update({
    'following': FieldValue.arrayUnion([user])
  });
}
