import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/user_authentication_widgets/create_account_page.dart';
import 'package:flutter_app_firebase_login/user_authentication_widgets/login_page.dart';
import 'package:flutter_app_firebase_login/user_pages/main_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

//TODO make some animation for the "welcome to GeoEye" text and do something about all the whitespace below the two buttons

class _WelcomePageState extends State<WelcomePage> {
  Future<void> autoLogin() async {
    final storage = new FlutterSecureStorage();
    String email = await storage.read(key: 'email') ?? '';
    String password = await storage.read(key: 'password') ?? '';

    if (email != '' && password != '') {
      print('Retrieved credentials from secure storage');
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MainUserPage(),
        ),
      );
    } else {
      print('No credentials found in secure storage');
    }
  }

  @override
  Widget build(BuildContext context) {
    // attempt to auto login
    autoLogin();

    return Scaffold(
      body: Column(
        children: [
          AppBar(
            centerTitle: true,
            title: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('GeoEye',
                    speed: const Duration(milliseconds: 500), cursor: "_"),
                //TypewriterAnimatedText("slogan",
                //    speed: const Duration(milliseconds: 500), cursor: "_"),
              ],
              repeatForever: true,
              pause: const Duration(seconds: 5),
            ),
            //Text('GeoEye', style: TextStyle(fontSize: 25)),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: 
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Hello, welcome to GeoEye',
                          speed: const Duration(milliseconds: 150),
                          cursor: "_", textStyle: TextStyle(fontSize: 20),),
                      TypewriterAnimatedText("Where Location meets People",
                          speed: const Duration(milliseconds: 150), cursor: "_", textStyle: TextStyle(fontSize: 20),),
                    ],
                    repeatForever: true,
                    pause: const Duration(seconds: 1),
                  ),
                  /*Text(
                    textAlign: TextAlign.center,
                    'Hello, welcome to GeoEye.',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),*/
                  flex: 1,
                  fit: FlexFit.tight,
                ),
                Flexible(
                  child: Image(
                    image: AssetImage('images/eye.png'),
                  ),
                  flex: 2,
                  fit: FlexFit.tight,
                ),
                Flexible(child: Container()),
                Flexible(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        alignment: Alignment.center,
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(onSignIn: (user) {}),
                        ),
                      );
                    },
                    child: Text(
                      'Sign-up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  flex: 2,
                  fit: FlexFit.loose,
                ),
                Flexible(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        alignment: Alignment.center,
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(onSignIn: (user) {}),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  flex: 2,
                  fit: FlexFit.loose,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
