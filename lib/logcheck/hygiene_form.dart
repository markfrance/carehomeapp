import 'package:carehomeapp/logcheck/form_header.dart';
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../care_home_icons_icons.dart';

class HygieneForm extends StatefulWidget {
  final Patient patient;
  final User user;
  HygieneForm(this.patient, this.user);

  @override
  HygieneFormState createState() => HygieneFormState();
}

class HygieneFormState extends State<HygieneForm> {
  final _otherController = TextEditingController();

  String hygieneType;
  String imageurl;
  String comment;

  void _addHygiene(BuildContext context) {
 
    final docRef = Firestore.instance.collection('feeditem').document();
    final patientName = widget.patient.firstname + " " + widget.patient.lastname;
    docRef.setData({
      'timeadded': DateTime.now(),
      'type': 'body',
      'subtype': 'hygiene',
      'patient': widget.patient.id,
      'patientimage': widget.patient.imageUrl,
      'patientname': widget.patient.firstname + " " + widget.patient.lastname,
      'user': widget.user.id,
      'username': widget.user.firstName + " " + widget.user.lastName,
      'hygienetype': hygieneType,
      'otherhygiene': _otherController.text,
      'imageurl': imageurl,
      'logdescription': "Hygiene: " + hygieneType + ". " + _otherController.text
    }).then((onValue) => {
          comment != null
              ? Comment.addNewComment(docRef.documentID, widget.user.id,
                  widget.user.firstName + " " + widget.user.lastName, comment)
              : null,
               PushNotification.sendPostNotifications(widget.user, 'hygiene', widget.patient.id, patientName),
          Navigator.pop(context)
        });
  }

  void setImage(String newimageurl) {
    setState(() {
      imageurl = newimageurl;
    });
  }

  void setComment(String newComment) {
    setState(() {
      comment = newComment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 244, 174, 124),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(widget.user,setImage, setComment),
          Text(
            "Hygiene",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: DropdownButton<String>(
                    hint:
                        hygieneType == null ? Text("Type") : Text(hygieneType),
                    value: null,
                    icon: Icon(CareHomeIcons.arrowdown),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        hygieneType = newValue;
                      });
                    },
                    items: <String>[
                      'Shower',
                      'Brushed Teeth',
                      'Changed Clothes'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          color: Color.fromARGB(255, 250, 243, 242),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "other",
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _otherController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _addHygiene(context);
                    },
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
