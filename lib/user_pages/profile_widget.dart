import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileWidget extends StatelessWidget {
  static const double SETTINGS_BUTTON_WIDTH = 60;
  static const double SETTINGS_BUTTON_SPACING = 20;

  static String username = '';

  const ProfileWidget({Key? key}) : super(key: key);

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


    String? getUuid()
    {
      String? uuid = '';
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      uuid = user?.uid;
      return uuid;
    }

    //method to get the username of the user logged in
    Future<String> getUsername() async
    {
        String username = '';
        QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
            .instance.collection("users")
            .where("uuid", isEqualTo: getUuid() as String)
            .get();
        List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
          username = doc.get('username');
        }
        return await username;
    }

    getUsername().then((value) => {username = value});

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Profile Page"),
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
                          child: Icon(
                            Icons.person,
                            size: 80,
                          ),
                        ),
                        Text(username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          logout();
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Text("Post Count"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Text("Interactions"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Text("Interacted with"),
                    )
                  ],
                )
              ]),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: SETTINGS_BUTTON_SPACING),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(
                              SETTINGS_BUTTON_WIDTH), // fromHeight use double.infinity as width and 40 is the height
                        ),
                        onPressed: () {},
                        child: Text("Password Settings")),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: SETTINGS_BUTTON_SPACING),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(
                              SETTINGS_BUTTON_WIDTH), // fromHeight use double.infinity as width and 40 is the height
                        ),
                        onPressed: () {},
                        child: Text("Account Settings")),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: SETTINGS_BUTTON_SPACING),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(
                              SETTINGS_BUTTON_WIDTH), // fromHeight use double.infinity as width and 40 is the height
                        ),
                        onPressed: () {},
                        child: Text("Privacy Settings")),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: SETTINGS_BUTTON_SPACING),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(
                              SETTINGS_BUTTON_WIDTH), // fromHeight use double.infinity as width and 40 is the height
                        ),
                        onPressed: () {},
                        child: Text("Help")),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
