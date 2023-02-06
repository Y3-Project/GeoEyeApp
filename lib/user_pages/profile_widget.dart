import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  const ProfileWidget({Key? key}) : super(key: key);

  String? getUuid() {
    String? uuid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    uuid = user?.uid;
    return uuid;
  }

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  XFile? _imageFile;
  static String profilePhotoURL = '';
  static String profileUrl = '';
  static String profileBio = '';
  static String username = '';
  final ImagePicker _picker = ImagePicker();
  TextEditingController _profileBioController = new TextEditingController();

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

    //method to get the username of the user logged in
    Future<String> getUsername() async {
      String username = '';
      QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection("users")
          .where("uuid", isEqualTo: ProfileWidget().getUuid() as String)
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
        username = doc.get('username');
      }
      if (this.mounted) {
        setState(() {
          // Your state change code goes here
        });
      }
      return await username;
    }

    getUsername().then((value) => {username = value});



//--------------------------------------------USER'S PROFILE PIC SECTION STARTS HERE--------------------------------------------------


    //method for uploading image to Firebase Storage
    Future<void> uploadPhotoToStorage() async {

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uuid = user?.uid;

      final timeNow = DateTime.now();
      var refRoot = await FirebaseStorage.instanceFor(
              bucket: "gs://flutter-app-firebase-log-c1c41.appspot.com").ref();

      var refDirImages = await refRoot.child("profileImages/$uuid");


      Reference imageReference = refDirImages.child("$timeNow.jpg");
      var uploadTask = await imageReference.putFile(File(_imageFile?.path as String));

      profilePhotoURL = await imageReference.getDownloadURL();
    }


    Future<void> sendURLToFirestore() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(ProfileWidget().getUuid())
          .update({'profilePicture': profilePhotoURL});
    }


    Future<String> retrieveURLFromFirestore() async {
      String url = '';
      QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection("users")
          .where("uuid", isEqualTo: ProfileWidget().getUuid() as String)
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
        url = doc.get('profilePicture');
      }
      return await url;
    }

    retrieveURLFromFirestore().then((value) => {profileUrl = value});

    void sendAndRetrieveURL(){
      sendURLToFirestore();
      retrieveURLFromFirestore();
    }

    void takePhoto(ImageSource source) async {
      final pickedFile = await _picker.pickImage(requestFullMetadata: true,
        source: source,
      );

      _imageFile = await pickedFile;

      uploadPhotoToStorage();
    }


    ImageProvider<Object> getUserPicture(){

      if (profileUrl.isNotEmpty)
        {
          print(profileUrl);
          sendAndRetrieveURL();
          return NetworkImage(profileUrl);
        }

      else{
        return AssetImage("images/geoeye.png");
      }

    }

    Widget bottomSheet() {
      return Container(
        color: Colors.black,
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 0.1,
          vertical: 0.1,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Choose Profile photo",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
            SizedBox(
              height: 25,
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: getUserPicture(),fit: BoxFit.cover),
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 11.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.add_a_photo,
                color: Colors.black,
                size: 28.0,
              ),
            ),
          ),
        ]),
      );
    }

    //--------------------------------------------USER'S PROFILE PIC SECTION ENDS HERE-------------------------------------------


    //--------------------------------------------USER'S BIO SECTION STARTS HERE--------------------------------------------------

    Future<void> sendBioToFirestore() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(ProfileWidget().getUuid())
          .update({'biography': _profileBioController.text});
    }

    Future<String> retrieveBioFromFirestore() async {
      String bio = '';
      QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection("users")
          .where("uuid", isEqualTo: ProfileWidget().getUuid() as String)
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
        bio = doc.get('biography');
      }
      return await bio;
    }

    retrieveBioFromFirestore().then((value) => {profileBio = value});

    //--------------------------------------------USER'S BIO SECTION ENDS HERE-----------------------------------------------------


    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Profile",
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
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(
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
                    TextField(
                      onEditingComplete: () {
                        sendBioToFirestore();
                        retrieveBioFromFirestore();
                        _profileBioController.clear();
                      },
                      controller: _profileBioController,
                      maxLength: 40,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 18),
                          hintText: 'Enter or update your bio here',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    )
                    //add profile/biography text box here
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(children: [
                      Align(
                          child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(border: Border.symmetric()),
                        child: Text("Bio: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      )),
                      Text(
                        profileBio,
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
                    Align(
                        child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(border: Border.symmetric()),
                      child: Text("Post Count: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    )),
                    Align(
                        child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(border: Border.symmetric()),
                      child: Text("Interactions: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    )),
                    Align(
                        child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(border: Border.symmetric()),
                      child: Text("Interacted with: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ))
                  ],
                )
              ]),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ProfileWidget.SETTINGS_BUTTON_SPACING),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size.fromHeight(ProfileWidget
                              .SETTINGS_BUTTON_WIDTH), // fromHeight use double.infinity as width and 40 is the height
                        ),
                        onPressed: () {},
                        child: Text(
                          "My Posts",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ProfileWidget.SETTINGS_BUTTON_SPACING),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size.fromHeight(ProfileWidget
                              .SETTINGS_BUTTON_WIDTH), // fromHeight use double.infinity as width and 40 is the height
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
                    margin: EdgeInsets.symmetric(
                        vertical: ProfileWidget.SETTINGS_BUTTON_SPACING),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size.fromHeight(ProfileWidget
                              .SETTINGS_BUTTON_WIDTH), // fromHeight use double.infinity as width and 40 is the height
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
          ))),
    );
  }
}
