import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/image_widgets/scrapbook_thumbnail.dart';
import 'package:flutter_app_firebase_login/post_widgets/add_post.dart';
import 'package:flutter_app_firebase_login/post_widgets/image_or_video_post.dart';
import 'package:flutter_app_firebase_login/post_widgets/title_caption_for_post.dart';
import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_title.dart';
import 'package:geolocator/geolocator.dart';

import '../user_pages/profile_widget.dart';

//todo this page allows the user to make a completely new scrapbook

class NewScrapbookPage extends StatefulWidget {
  NewScrapbookPage({Key? key}) : super(key: key);
  static double? currentLat = 0;
  static double? currentLong = 0;

  @override
  State<NewScrapbookPage> createState() => _NewScrapbookPageState();
}

class _NewScrapbookPageState extends State<NewScrapbookPage> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create A New Scrapbook", style: TextStyle(fontSize: 25)),
        ),
        body: Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: Colors.black)),
            child: Stepper(
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: Text(
                        'Back',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(color: Colors.white, height: 100, indent: 180),
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(
                        'Next',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
              type: StepperType.vertical,
              steps: getSteps(),
              currentStep: currentStep,
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;

                if (isLastStep) {
                  print('Completed');
                } else {
                  setState(() {
                    currentStep = currentStep + 1;
                  });
                }
              },
              onStepCancel: () {
                currentStep == 0
                    ? null
                    : setState(() {
                        currentStep = currentStep - 1;
                      });
              },
            )));
  }

  List<Step> getSteps() => [
        Step(
            isActive: currentStep == 0,
            title: Text('Thumbnail'),
            content: thumbnailStep()),
        Step(
            isActive: currentStep == 1,
            title: Text('Title'),
            content: titleStep()),
        Step(
            isActive: currentStep == 2,
            title: Text('Post Title And Caption'),
            content: postTitleCaptionStep()),
        Step(
            isActive: currentStep == 3,
            title: Text('Add an image or a video as your post'),
            content: imageOrVideoPostStep()),
        Step(
            isActive: currentStep == 4,
            title: Text("Publish your scrapbook"),
            content: finalStep()),
      ];
}

Widget thumbnailStep() {
  return Container(
      child: Column(
    children: [
      Text(
        'Choose A Thumbnail For Your Scrapbook',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Divider(color: Colors.white, height: 20),

      //goes to another file called scrapbook_thumbnail.dart
      ScrapbookThumbnail(),
      Divider(color: Colors.white, height: 20),
      Text('Or leave it as the default one shown below',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Divider(color: Colors.white, height: 20),
      Image.asset('images/default_image.png', height: 100)
    ],
  ));
}

Widget titleStep() {
  return Container(
      child: Column(
    children: [
      Text(
        'Write A Title For Your Scrapbook',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Divider(color: Colors.white, height: 20),
      ScrapbookTitle(),
    ],
  ));
}

Widget postTitleCaptionStep() {
  return Container(
      child: Column(
    children: [
      Text(
        'Write A Title And A Caption For Your Post',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Divider(color: Colors.white, height: 10),
      titleCaptionForPost()
    ],
  ));
}

Widget imageOrVideoPostStep() {
  return Column(children: [
    Text("Note: Your post can either be a photo or a video, but not both", style: TextStyle(fontSize: 12),),
    ImageVideoPost()
  ]);
}

Widget finalStep() {

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    NewScrapbookPage.currentLat = position?.latitude;
    NewScrapbookPage.currentLong = position?.longitude;
  }
  _determinePosition();
  return Container(child: AddPost());
}
