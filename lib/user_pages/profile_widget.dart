import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/profile_widgets/profile_widget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../util/user_model.dart';

class ProfilePage extends StatefulWidget {
  static const double SETTINGS_BUTTON_WIDTH = 60;
  static const double SETTINGS_BUTTON_SPACING = 20;

  const ProfilePage({Key? key}) : super(key: key);

  String? getUuid() {
    String? uuid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    uuid = user?.uid;
    return uuid;
  }

  Future<String> getUserDocumentID() async {
    String userDocID = '';
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
        .collection("users")
        .where("uuid", isEqualTo: ProfilePage().getUuid() as String)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
      userDocID = doc.id;
    }
    return await userDocID;
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  static String userDocID = 'general';
  DocumentReference userReference = FirebaseFirestore.instance.doc('/users/' + userDocID);

  Future<void> setUpRef() async {
    await ProfilePage().getUserDocumentID().then((value) => userDocID = value);
    userReference = FirebaseFirestore.instance.doc('/users/' + userDocID);
    setState(() {});
  }

  Stream<UserModel> get userModelStream {
    return userReference.snapshots().map(_userDetailsFormSnapshot);
  }

  UserModel _userDetailsFormSnapshot(DocumentSnapshot snapshot) {
    return UserModel.fromDocument(snapshot);
  }

  @override
  Widget build(BuildContext context) {

    setUpRef();
    return StreamProvider<UserModel>.value(
        value: userModelStream,
        initialData: UserModel(),
        child: ProfileWidget());
  }
}
