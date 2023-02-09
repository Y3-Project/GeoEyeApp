import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/image_widgets/image_uploader_widget.dart';
import 'package:flutter_app_firebase_login/image_widgets/image_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../account_settings_help_pages/account_settings_page.dart';
import '../account_settings_help_pages/help_page.dart';
import '../user_authentication_widgets/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user_pages/profile_widget.dart';
import '../util/user_model.dart';

class ProfileWidget extends StatefulWidget {
  static const double SETTINGS_BUTTON_WIDTH = 60;
  static const double SETTINGS_BUTTON_SPACING = 20;

  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  TextEditingController _profileBioController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    Future<void> sendBioToFirestore() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.id)
          .update({'biography': _profileBioController.text});
    }

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
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center, children: [
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
                              child: ImageProfileWidget(),
                            ),
                            Text(user.username,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ],
                        ),
                        TextField(
                          onEditingComplete: () {
                            sendBioToFirestore();
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
                                decoration: BoxDecoration(
                                    border: Border.symmetric()),
                                child: Text("Bio: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              )),
                          Text(
                            user.biography,
                            style: TextStyle(fontSize: 20),
                          )
                        ]),
                        Align(
                            child: Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  border: Border.symmetric()),
                              child: Text("Post Count: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            )),
                        Align(
                            child: Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  border: Border.symmetric()),
                              child: Text("Interactions: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            )),
                        Align(
                            child: Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  border: Border.symmetric()),
                              child: Text("Interacted with: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
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
                              "My Scrapbooks",
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
                                    builder: (context) =>
                                        AccountSettingsPage()),
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
                                MaterialPageRoute(
                                    builder: (context) => HelpPage()),
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
