import 'package:flutter_app_firebase_login/scrapbook_widgets/scrapbook_tile.dart';
import 'package:popup_card/popup_card.dart';
import 'package:flutter/material.dart';

/*class OtherUserPopUp extends StatefulWidget{
  const ({Key? key}) : super(key: key);

  @override
  State<OtherUserPopUp> createState() => _OtherUSerPopUpState();
}*/

class OtherUserPopUp {
  Widget popUpItemBody() {
    return Center(
        child: Column(children: [
      CircleAvatar(backgroundImage: AssetImage('images/default_avatar.png')),
      Text("username"),
      Text("Bio"),
      Divider(),
      Text("Scrapbook count"),
      Text("Interaction count"),
      Text("Interacted with count")
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return PopupItemLauncher(
      popUp: PopUpItem(
        tag: "otheruserpopup",
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        elevation: 2,
        padding: EdgeInsets.all(8),
        child: popUpItemBody(),
      ),
    );
  }
}
/*class OtherUserPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Popup Card'),
      content: Text('This is a popup card.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
*/