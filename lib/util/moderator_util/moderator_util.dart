import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Future<void> deletePost(QueryDocumentSnapshot post) async {
  print("DELETING POST: ${post.id}");
  var inst = FirebaseFirestore.instance.collection('posts');
  inst.doc("${post.id}").delete();
}

Future<void> timeoutUserFromPost(QueryDocumentSnapshot post) async {
  print("timing out user ${post.get("user")} from document: ${post.id}");
  var date = DateTime.now();
  DocumentReference user = FirebaseFirestore.instance.doc(post.get("user"));
  user.update({"timeoutStart": date.toString()});
}

Future<void> banUserFromPost(QueryDocumentSnapshot post) async {
  print("banning user ${post.get("user")} for post ${post.id}");
  DocumentReference user = FirebaseFirestore.instance.doc(post.get("user"));
  user.update({'banned': true});
}

Future<Row> getTextPost(QueryDocumentSnapshot post) async {
  DocumentReference document = post.get("user");
  return await Row(
    children: [
      Expanded(
        child: Column(children: [
          ListTile(
              title: Text(post.get("title")), subtitle: Text(post.get("text"))),
          Text(
            "posted by ${document.id}, reported ${post.get("reportsNumber")} times",
            softWrap: true,
          )
        ]),
      ),
      // TODO: make drop down
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            deletePost(post);
          },
          child: Text("Delete"),
        ),
      )
    ],
  );
}

Future<VideoPlayerController> loadVideo(QueryDocumentSnapshot post) async {
  String url = await post.get("video");
  return VideoPlayerController.network(url);
}

Future<Row> getVideoPost(QueryDocumentSnapshot post) async {
  // currently this would just show the URL
  return Row(
    children: [
      Expanded(child: VideoPlayer(await loadVideo(post))),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            deletePost(post);
          },
          child: const Text("Delete"),
        ),
      )
    ],
  );
}

Future<Image> loadImage(QueryDocumentSnapshot post) async {
  var s = await post.get("picture");
  return Image.network(
    s,
    height: 200.0,
  );
}

Image loadImageFromURL(String url) {
  return Image.network(
    url,
    height: 200.0,
  );
}

Future<Row> getPicturePost(QueryDocumentSnapshot post) async {
  DocumentReference document = post.get("user");
  return await Row(
    children: [
      Expanded(
          child: Column(children: [
        ListTile(
          leading: await loadImage(post),
          title: Text(post.get("title")),
          subtitle: Text(post.get("text")),
        ),
        Text(
          "posted by ${document.id}, reported ${post.get("reportsNumber")} times",
          softWrap: true,
        )
      ])),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            deletePost(post);
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