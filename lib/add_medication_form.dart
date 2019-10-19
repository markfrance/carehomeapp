import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:flutter/material.dart';

class AddMedicationForm extends StatelessWidget {
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
            "Add Medication",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                Text("Medication"),
                 Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(),
                  ),
                  Text("Dose"),
                 Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(),
                  ),
                  Text("Time"),
                 Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
