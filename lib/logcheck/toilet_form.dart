import 'package:carehomeapp/logcheck/form_header.dart';
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToiletForm extends StatefulWidget {
  final Patient patient;
  final User user;
  ToiletForm(this.patient, this.user);

  @override
  ToiletFormState createState() => ToiletFormState();
}

class ToiletFormState extends State<ToiletForm> {
  final _statusController = TextEditingController();
  String toiletType = 'urine';
  String imageurl;
  String comment;

  void _addToilet(BuildContext context) {
   

    final docRef = Firestore.instance.collection('feeditem').document();
    final patientName = widget.patient.firstname + " " + widget.patient.lastname;
    docRef.setData({
      'timeadded': DateTime.now(),
      'time': DateTime.now(),
      'type': 'body',
      'subtype': 'toilet',
      'patient': widget.patient.id,
      'patientimage': widget.patient.imageUrl,
      'patientname': patientName,
      'user': widget.user.id,
      'username': widget.user.firstName + " " + widget.user.lastName,
      'toilettype': toiletType,
      'status': _statusController.text,
      'imageurl': imageurl,
      'logdescription':
          "Went to toilet for " + toiletType + ". " + _statusController.text
    }).then((onValue) => {
          comment != null
              ? Comment.addNewComment(docRef.documentID, widget.user.id,
                  widget.user.firstName + " " + widget.user.lastName, comment)
              : null,
               PushNotification.sendPostNotifications(widget.user, 'toilet', widget.patient.id, patientName),
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
          FormHeader(widget.user, setImage, setComment),
          Text(
            "Toilet",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ButtonBar(
                  children: <Widget>[
                    Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        RaisedButton(
                          color: toiletType == 'urine'
                              ? Colors.white
                              : Color.fromARGB(255, 244, 174, 124),
                          child: Text("Urine"),
                          onPressed: () => setState(
                            () {
                              toiletType = "urine";
                            },
                          ),
                        ),
                        RaisedButton(
                          color: toiletType == 'stool'
                              ? Colors.white
                              : Color.fromARGB(255, 244, 174, 124),
                          child: Text("Stool"),
                          onPressed: () => setState(() {
                            toiletType = "stool";
                          }),
                        )
                      ],
                    ),
                  ],
                ),
                Text("Status"),
                TextField(
                  controller: _statusController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _addToilet(context);
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
