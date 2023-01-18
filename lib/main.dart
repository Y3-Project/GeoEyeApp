import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_firebase_login/welcome_page.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // TODO connect to firebase cloud storage here?
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoEye',
      theme: ThemeData.light().copyWith(
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.accent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff000000),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('GeoEye',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
        Lottie.asset('images/eye-blinking.json')
      ]),
      nextScreen: WelcomePage(),
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
