import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Create Post",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Post Title'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a caption for the post...'),
            ),
          ),
          Container(child: Image.asset('images/add_img.png')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateColor.resolveWith((states) => Colors.black),
                      textStyle: MaterialStateTextStyle.resolveWith(
                          (states) => TextStyle(color: Colors.white))),
                  onPressed: () {},
                  child: Text("Post")),
            ],
          ),
        ],
      ),
    );
  }
}
