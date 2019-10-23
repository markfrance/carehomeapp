import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MoodForm extends StatefulWidget {
  final Patient patient;
  MoodForm(this.patient);

  @override
  MoodFormState createState() => MoodFormState();
}

class MoodFormState extends State<MoodForm> {
  String mood;

  void _addMood(BuildContext context) {
    final user = UserBinding.of(context).user;

    Firestore.instance.collection('feeditem').document().setData({
      'timeadded': DateTime.now(),
      'type': 'mood',
      'subtype': '',
      'patient': widget.patient.id,
      'user': user.id,
      'mood': mood,
    }).then((onValue) => Navigator.pop(context));
  }

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
          FormHeader(),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Mood",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: () {
                      _addMood(context);
                    },
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
