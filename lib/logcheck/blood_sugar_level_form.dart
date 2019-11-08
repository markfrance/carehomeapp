import 'package:carehomeapp/logcheck/form_header.dart';
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BloodSugarLevelForm extends StatefulWidget {
  final Patient patient;
  BloodSugarLevelForm(this.patient);

  @override
  BloodSugarLevelFormState createState() => BloodSugarLevelFormState();
}

class BloodSugarLevelFormState extends State<BloodSugarLevelForm> {
  final _levelController = TextEditingController();
  String imageurl;
  String comment;

  void _addBloodSugarLevel(BuildContext context) {
    final user = UserBinding.of(context).user;

    final docRef = Firestore.instance.collection('feeditem').document();
    docRef.setData({
      'timeadded': DateTime.now(),
      'type': 'vitals',
      'subtype': 'bloodsugar',
      'patient': widget.patient.id,
      'patientimage': widget.patient.imageUrl,
      'patientname': widget.patient.firstname + " " + widget.patient.lastname,
      'user': user.id,
      'username': user.firstName + " " + user.lastName,
      'level': _levelController.text,
      'imageurl': imageurl,
      'logdescription': "Blood sugar level: " + _levelController.text + " mmo/l"
    }).then((onValue) => {
          comment != null
              ? Comment.addNewComment(docRef.documentID, user.id,
                  user.firstName + " " + user.lastName, comment)
              : null,
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
      backgroundColor: Color.fromARGB(255, 251, 148, 148),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(setImage, setComment),
          Text(
            "Blood Sugar Level",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(controller: _levelController),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text("mmol/L"),
                      flex: 1,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _addBloodSugarLevel(context);
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
