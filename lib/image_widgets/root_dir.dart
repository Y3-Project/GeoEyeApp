import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class RootDirectory{
  Future<Image> getRootDir() async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = appDocDir.absolute.path.toString() + '/images/add_img.png';
    Image image = Image.file(File(filePath));
    return image;
  }
}