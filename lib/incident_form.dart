import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:flutter/material.dart';

class IncidentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 204, 241, 255),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(),
          Text(
            "Incident",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
