import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/user_pages/settings_pages/account_settings_page.dart';
import 'package:flutter_app_firebase_login/user_pages/settings_pages/help_page.dart';
import 'package:image_picker/image_picker.dart';
import '../login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileWidget extends StatefulWidget {
  static const double SETTINGS_BUTTON_WIDTH = 60;
  static const double SETTINGS_BUTTON_SPACING = 20;

  static XFile? _imageFile;

  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {

  static String username = '';
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    //method to log the user out
    Future<void> logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(onSignIn: (user) {}),
        ),
      );
    }

    String? getUuid() {
      String? uuid = '';
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      uuid = user?.uid;
      return uuid;
    }

    //method to get the username of the user logged in
    Future<String> getUsername() async {
      String username = '';
      QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection("users")
          .where("uuid", isEqualTo: getUuid() as String)
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
        username = doc.get('username');
      }
      return await username;
    }
    getUsername().then((value) => {username = value});


    void takePhoto(ImageSource source) async {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        ProfileWidget._imageFile = pickedFile;
      });
    }


    Widget bottomSheet() {
      return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Choose Profile photo",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery"),
              ),
            ])
          ],
        ),
      );
    }


    Widget imageProfile() {
      return Center(
        child: Stack(children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 80.0,
            backgroundImage: ProfileWidget._imageFile == null
                ? AssetImage("images/geoeye.png")
                : FileImage(File(ProfileWidget._imageFile?.path as String)) as ImageProvider,
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),
        ]),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Profile Page",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black)),
                        child: imageProfile(),
                      ),

                      Text(username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Text("Post Count",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Text("Interactions",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Text("Interacted with",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ]),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: ProfileWidget.SETTINGS_BUTTON_SPACING),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size.fromHeight(
                            ProfileWidget.SETTINGS_BUTTON_WIDTH), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => AccountSettingsPage()),
                        );
                      },
                      child: Text(
                        "Account Settings",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: ProfileWidget.SETTINGS_BUTTON_SPACING),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size.fromHeight(
                            ProfileWidget.SETTINGS_BUTTON_WIDTH), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HelpPage()),
                        );
                      },
                      child: Text(
                        "Help",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
