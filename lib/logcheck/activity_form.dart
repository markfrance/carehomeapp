import 'package:carehomeapp/logcheck/enter_comment.dart';
import 'package:carehomeapp/logcheck/form_header.dart';
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityForm extends StatefulWidget {
  final Patient patient;
  final User user;
  ActivityForm(this.patient, this.user);

  @override
  ActivityFormState createState() => ActivityFormState();
}

class ActivityFormState extends State<ActivityForm> {
  final _activityController = TextEditingController();
  String imageurl;
  String comment;

  void _setComment(String newComment) {
    setState(() {
      comment = newComment;
    });
  }

  void _addActivity(BuildContext context) {
   
    final docRef = Firestore.instance.collection('feeditem').document();
    final patientName =  widget.patient.firstname + " " + widget.patient.lastname;

    docRef.setData({
      'timeadded': DateTime.now(),
      'type': 'other',
      'subtype': 'activity',
      'patient': widget.patient.id,
      'patientimage': widget.patient.imageUrl,
      'patientname':patientName,
      'user': widget.user.id,
      'username': widget.user.firstName + " " + widget.user.lastName,
      'activity': _activityController.text,
      'logdescription': "New activity:" + _activityController.text,
      'imageurl': imageurl
    }).then((onValue) => {
          comment != null
              ? Comment.addNewComment(docRef.documentID, widget.user.id,
                  widget.user.firstName + " " + widget.user.lastName, comment)
              : null,
              PushNotification.sendPostNotifications(widget.user, 'activity', widget.patient.id, patientName),

          Navigator.pop(context)
        });
  }

  void _setImage(String newimageurl) {
    setState(() {
      imageurl = newimageurl;
    });
  }

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
          FormHeader(widget.user, _setImage, _setComment),
          Text(
            "Activity",
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
                        child: TextFormField(
                          controller: _activityController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _addActivity(context);
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
