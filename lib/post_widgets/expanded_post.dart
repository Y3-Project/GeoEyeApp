import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_posts_page.dart';

import '../scrapbook_widgets/scrapbook.dart';
import '../util/getScrapbookFromPost.dart';

class ExpandedPostPage extends StatefulWidget {
  Post post;
  ExpandedPostPage(this.post);

  @override
  State<ExpandedPostPage> createState() => _ExpandedPostPageState();
}

class _ExpandedPostPageState extends State<ExpandedPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            getScrapbook(widget.post).then((scrapbook){
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ScrapbookPostsPage(scrapbook: scrapbook)),
              );
            });
          },
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.post.title,
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(widget.post.picture == "" ? "https://www.myutilitygenius.co.uk/assets/images/blogs/default-image.jpg" : widget.post.picture),
        ],
      ),
    );
  }
}
