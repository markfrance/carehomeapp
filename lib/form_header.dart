import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Align(
          child: FlatButton(
            child: Icon(CareHomeIcons.arrowleft),
            onPressed: () => Navigator.pop(context),
          ),
          alignment: Alignment.centerLeft,
        ),
        Spacer(),
        Padding(
            child: Icon(
              CareHomeIcons.comment,
            ),
            padding: EdgeInsets.all(4.0)),
        Icon(CareHomeIcons.addphoto),
      ],
    );
  }
}
