import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

int distanceFromOneGeoPointToAnotherInKM(GeoPoint p1, GeoPoint p2) {
  final _geoLocatorPlatform = GeolocatorPlatform.instance;
  final res = _geoLocatorPlatform.distanceBetween(
      p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  return (res ~/ 1000);
}

Future<void> deletePost(QueryDocumentSnapshot<Object?> snapshot) async {
  // todo: implement
}

Row getTextPosts(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
  return Row(
    children: [
      Expanded(
          child: Text(
        snapshot.data!.docs[index].get("text"),
        textAlign: TextAlign.center,
      ))
    ],
  );
}

Row getVideoPosts(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
  var t = snapshot.data!.docs[index];
  return Row(
    children: [
      Expanded(
          child: Text(
        snapshot.data!.docs[index].get("video"),
        textAlign: TextAlign.center,
      ))
    ],
  );
}

Row getPicturePosts(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
  return Row(
    children: [
      Expanded(
        child: Text(
          snapshot.data!.docs[index].get("picture"),
          textAlign: TextAlign.center,
        ),
      ),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            deletePost(snapshot.data!.docs[index]);
          },
          child: const Text("Delete"),
        ),
      )
    ],
  );
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
