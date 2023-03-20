import 'package:flutter/material.dart';

import '../media_widgets/media_uploader_widget.dart';
import '../util/enums/media_type.dart';

final imageUploaderWidgetStateKey = new GlobalKey<MediaUploaderWidgetState>();
final String SCRAPBOOK_THUMBNAIL_STORAGE_DIRECTORY_PATH = "/scrapbooks/";
final String SCRAPBOOK_THUMBNAIL_NAME = "scrapbook_thumbnail.png";

class ImageVideoPost extends StatefulWidget {
  final ValueChanged<MediaUploaderWidgetState> mediaUploader;

  const ImageVideoPost({Key? key, required this.mediaUploader})
      : super(key: key);

  @override
  State<ImageVideoPost> createState() => _ImageVideoPostState();
}

class _ImageVideoPostState extends State<ImageVideoPost> {
  final mediaUploaderWidgetStateKey = new GlobalKey<MediaUploaderWidgetState>();

  //int postNumber = 0;

  void selectPostMedia(MediaType mediaType) {
    MediaUploaderWidget mediaUploaderWidget = MediaUploaderWidget(
        key: mediaUploaderWidgetStateKey,
        mediaType: mediaType,
        fileName: "scrapbook_post");
    mediaUploaderWidget.buildMediaUploader(mediaUploaderWidget, context).then(
        (value) =>
            widget.mediaUploader(mediaUploaderWidgetStateKey.currentState!));
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      InkWell(
          onTap: () {
            selectPostMedia(MediaType.picture);
          },
          child: Image.asset('images/add_img.png', height: 100)),
      // Divider(indent: 90),
      InkWell(
          onTap: () {
            selectPostMedia(MediaType.video);
          },
          child: Icon(Icons.video_call_rounded, size: 100))
    ]);
  }
}
