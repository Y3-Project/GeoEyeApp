import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_firebase_login/user_authentication_widgets/create_account_page.dart';
import 'package:flutter_app_firebase_login/util/moderator_widget.dart';
import 'package:flutter_app_firebase_login/util/timed_out_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'forgot_password_page.dart';
import '../user_pages/main_page.dart';
import '../util/util.dart';
import '../util/banned_page.dart';

class LoginPage extends StatefulWidget {
  final Function(User?) onSignIn;
  const LoginPage({required this.onSignIn});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user;
  //final TextEditingController _controllerEmail = TextEditingController();
  final storage = new FlutterSecureStorage();
  String userEmail = '';
  String userPw = '';
  bool rememberMe = false;
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String? error = '';

  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    //access firestore database here to get the corresponding email
    Future<String> getEmailFromUsername() async {
      String email = '';
      QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection("users")
          .where("username", isEqualTo: _controllerUsername.text)
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = snap.docs;
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
        email = doc.get('email');
      }
      return email;
    }

    //method for logging the user in
    Future<void> loginUser() async {
      try {
        print('Logging in user');

        /*
        // attempt to read credentials from secure storage
        userEmail = await storage.read(key: 'email') ?? '';
        userPw = await storage.read(key: 'password') ?? '';
        */

        // check if username field contains '@', this means it is an email as usernames do not contain this char
        if (_controllerUsername.text.contains('@')) {
          userEmail = _controllerUsername.text;
        } else {
          userEmail = await getEmailFromUsername();
        }
        userPw = _controllerPassword.text;

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: userEmail, password: userPw);

        if (rememberMe) {
          print('Writing credentials to secure storage');
          await storage.write(key: 'email', value: userEmail);
          await storage.write(key: 'password', value: _controllerPassword.text);
        } else {
          print('Erasing credentials from secure storage');
          await storage.delete(key: 'email');
          await storage.delete(key: 'password');
        }

        // find out if user is banned
        bool banned = false;
        final userBanned = await FirebaseFirestore.instance
            .collection("users")
            .where("banned", isEqualTo: true)
            .where("username", isEqualTo: _controllerUsername.text)
            .get();
        for (var doc in userBanned.docs) {
          banned = doc.get("banned");
        }
        print("banned: ${banned}");
        if (banned == true) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BannedPage(
                onSignOut: (userCred) {
                  onRefresh(userCred);
                },
              )));
        }
        // find out if user is timed out
        bool timedOut = false;
        final userForTimeout = await FirebaseFirestore.instance
            .collection("users")
            .where("username", isEqualTo: _controllerUsername.text)
            .get();

        var timeout = "";
        for (var doc in userForTimeout.docs) {
          timedOut = doc.get("timeoutStart") != ""
              ? true
              : false; // we have already if the user has a timeout
          timeout = doc.get("timeoutStart"); // save timeoutStart
        }

        if (timedOut == true) {
          if (timedOutUserOverLimit(_controllerUsername.text, timeout)) {
            timedOut = false;
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TimedOutPage(
                  onSignOut: (userCred) {
                    onRefresh(userCred);
                  },
                  timeout: timeout,
                )));
          }
        }

        // find out if user is moderator
        widget.onSignIn(userCredential.user);
        bool moderator = false;
        final userMod = await FirebaseFirestore.instance
            .collection('users')
            .where("moderator", isEqualTo: true)
            .where("username", isEqualTo: _controllerUsername.text)
            .get();
        for (var doc in userMod.docs) {
          moderator = doc.get('moderator');
        }
        if (moderator == true) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ModeratorWidget(
                onSignOut: (userCred) {
                  onRefresh(userCred);
                },
              )));
        } else if (banned == false && timedOut == false) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MainUserPage(
                onSignOut: (userCred) {
                  onRefresh(userCred);
                },
              ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'unknown') {
            error = 'Please enter the correct username';
          } else if (e.code == 'wrong-password') {
            error = 'Please enter the correct password';
          } else {
            error = 'An unknown error occurred';
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Sign in to your account',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: TextFormField(
                controller: _controllerUsername,
                decoration: const InputDecoration(labelText: "Username or Email")),
            flex: 1,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: TextFormField(
                controller: _controllerPassword,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password")),
            flex: 1,
            fit: FlexFit.tight,
          ),
          Text(error!),
          Flexible(
            // remember me checkbox
            child: Row(
              children: [
                const Text(style: TextStyle(fontSize: 18), "Remember me"),
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Flexible(
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green)),
              onPressed: () {
                loginUser();
              },
              child: const Text(style: TextStyle(fontSize: 25), "Login"),
            ),
            flex: 1,
            fit: FlexFit.loose,
          ),
          Flexible(
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage(),
                ),
              ),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SignUpPage(onSignIn: (user) {}),
                ),
              ),
              child: const Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            flex: 1,
            fit: FlexFit.loose,
          )
        ],
      ),
    );
  }
}
