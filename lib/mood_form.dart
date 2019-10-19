import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:flutter/material.dart';

class MoodForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 222, 164, 209),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
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
          ),
          Text(
            "Mood",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
