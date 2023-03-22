import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/post_widgets/title_caption_for_post.dart';

import '../media_widgets/media_uploader_widget.dart';
import '../scrapbook_widgets/scrapbook.dart';
import 'add_post.dart';
import 'image_or_video_post.dart';

MediaUploaderWidgetState postUploader = new MediaUploaderWidgetState();

class AddPostToScrapbookPage extends StatefulWidget {
  final Scrapbook scrapbook;

  const AddPostToScrapbookPage({Key? key, required this.scrapbook})
      : super(key: key);

  @override
  State<AddPostToScrapbookPage> createState() => _AddPostToScrapbookPageState();
}

class _AddPostToScrapbookPageState extends State<AddPostToScrapbookPage> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    //thumbnailUploader = new MediaUploaderWidget(key: thumbnailUploaderWidgetStateKey, mediaType: MediaType.picture, fileName: "scrapbook_thumbnail");
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Post to Scrapbook", style: TextStyle(fontSize: 25)),
        ),
        body: Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: Colors.black)),
            child: Stepper(
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: Text(
                        'Back',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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
            isActive: currentStep == 2,
            title: Text('Post Title And Caption'),
            content: postTitleCaptionStep()),
        Step(
            isActive: currentStep == 3,
            title: Text('Add an image or a video as your post'),
            content: imageOrVideoPostStep()),
        Step(
            isActive: currentStep == 5,
            title: Text("Publish your post"),
            content: finalStep(widget.scrapbook)),
      ];
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
    Text(
      "Note: Your post can either be a photo or a video, but not both",
      style: TextStyle(fontSize: 12),
    ),
    ImageVideoPost(
      mediaUploader: (newPostUploader) {
        postUploader = newPostUploader;
        print(postUploader.mediaFile.path);
      },
    )
  ]);
}

Widget finalStep(Scrapbook scrapbook) {
  DocumentReference scrapbookRef =
      FirebaseFirestore.instance.doc("/scrapbooks/" + scrapbook.id);
  return Container(
      child: AddPost(
    postUploader: postUploader,
    scrapbookRef: scrapbookRef,
  ));
}
