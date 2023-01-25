import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.white
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Text("Profile"),
    );;
  }
}
