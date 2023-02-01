import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../post_widgets/post_tile.dart';
import '../post.dart';

Future<void> deletePost(QueryDocumentSnapshot post) async {
  print("DELETING POST: ${post.id}");
  var inst = FirebaseFirestore.instance.collection('posts');
  inst.doc("${post.id}").delete();
  // TODO: delete from scrapbook it belongs to
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

Future<void> allowPostToBeOnApp(QueryDocumentSnapshot post) async {
  print("Allowing post ${post.id} to be on app");
  // remove all previous reports - allow it to be on the application
  FirebaseFirestore.instance.doc(post.reference.path).update({"reports": []});
}

Future<Container> getTextPost(QueryDocumentSnapshot post) async {
  DocumentReference user = post.get("user");
  Post postObj = Post.fromDocument(post);
  PostTile tile = PostTile(postObj);
  return await Container(
    child: Row(
      children: [
        Expanded(
          child: Column(children: [
            Text(
              "post: ${post.id}",
              softWrap: true,
            ),
            ListTile(
              title: Text(postObj.title),
              subtitle: Text(postObj.text),
            ),
            Text(
              "posted by ${user.id}, reported ${postObj.reports.length} times",
              softWrap: true,
            )
          ]),
        ),
        Expanded(child: createDropDownMenu(post, user.id)),
      ],
    ),
    decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
    padding: EdgeInsets.only(bottom: 5.0),
  );
}

Future<VideoPlayerController> loadVideo(QueryDocumentSnapshot post) async {
  String url = await post.get("video");
  return VideoPlayerController.network(url);
}

Future<Container> getVideoPost(QueryDocumentSnapshot post) async {
  Post postObj = Post.fromDocument(post);
  PostTile tile = PostTile(postObj); // TODO: create video playing widget
  DocumentReference user = post.get("user");
  // currently this would just show the URL
  return Container(
    child: Row(
      children: [
        Text(
          "post: ${post.id}",
          softWrap: true,
        ),
        Expanded(child: VideoPlayer(await loadVideo(post))),
        Expanded(child: createDropDownMenu(post, user.id))
      ],
    ),
    decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
    padding: EdgeInsets.only(bottom: 5.0),
  );
}

Future<Image> loadImage(QueryDocumentSnapshot post) async {
  var s = post.get("picture");
  return Image.network(
    s,
  );
}

Image loadImageFromURL(String url) {
  return Image.network(
    url,
    height: 200.0,
  );
}

Future<Container> getPicturePost(QueryDocumentSnapshot post) async {
  Post postObj = Post.fromDocument(post);
  PostTile tile = PostTile(postObj);
  DocumentReference user = post.get("user");
  return await Container(
    child: Row(
      children: [
        Expanded(
            child: Column(children: [
          Text(
            "post: ${post.id}",
            softWrap: true,
          ),
          tile,
          Text(
            "posted by ${user.id}, reported ${postObj.reports.length} times",
            softWrap: true,
          )
        ])),
        Expanded(child: createDropDownMenu(post, user.id))
      ],
    ),
    decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
    padding: EdgeInsets.only(bottom: 10.0),
  );
}

PopupMenuButton createDropDownMenu(QueryDocumentSnapshot post, String user) {
  return PopupMenuButton(
      child: Text("Actions: "),
      itemBuilder: (context) => [
            PopupMenuItem(
                child: Text("delete"),
                value: 1,
                onTap: () {
                  deletePost(post);
                }),
            PopupMenuItem(
              child: Text("ban user ${user}"),
              value: 2,
              onTap: () {
                banUserFromPost(post);
              },
            ),
            PopupMenuItem(
              child: Text("timeout user ${user}"),
              value: 3,
              onTap: () {
                timeoutUserFromPost(post);
              },
            ),
            PopupMenuItem(
              child: Text("Allow post ${post.id}"),
              value: 4,
              onTap: () {
                allowPostToBeOnApp(post);
              },
            )
          ]);
}

Future<Container> getPost(QueryDocumentSnapshot post) async {
  bool textPresent = (post.get("text") != "" && post.get("text") != null);
  bool picturePresent =
      (post.get("picture") != "" && post.get("picture") != null);
  bool noPicturePresent =
      (post.get("picture") == "" || post.get("picture") == null);
  bool videoPresent = (post.get("video") != "" && post.get("video") != null);
  bool noVideoPresent = (post.get("video") == "" || post.get("video") == null);

  if (textPresent && noPicturePresent && noVideoPresent) {
    // only text
    return await getTextPost(post);
  } else if (picturePresent) {
    // picture & text
    return await getPicturePost(post);
  } else if (videoPresent) {
    // video & text
    return await getVideoPost(post);
  }
  return Container(
    child: Row(children: [Text("Error")]),
    decoration:
        BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
  );
}
