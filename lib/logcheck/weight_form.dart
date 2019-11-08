import 'package:carehomeapp/logcheck/form_header.dart';
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WeightForm extends StatefulWidget {
  final Patient patient;
  WeightForm(this.patient);

  @override
  WeightFormState createState() => WeightFormState();
}

class WeightFormState extends State<WeightForm> {
  final _weightController = TextEditingController();
  String toiletType;
  String imageurl;
  String comment;

  void _addWeight(BuildContext context) {
    final user = UserBinding.of(context).user;

    final docRef = Firestore.instance.collection('feeditem').document();

    docRef.setData({
      'timeadded': DateTime.now(),
      'type': 'body',
      'subtype': 'weight',
      'patient': widget.patient.id,
      'patientimage': widget.patient.imageUrl,
      'patientname': widget.patient.firstname + " " + widget.patient.lastname,
      'user': user.id,
      'username': user.firstName + " " + user.lastName,
      'weight': _weightController.text,
      'imageurl': imageurl,
      'logdescription': "Weight reading: " + _weightController.text + "kg"
    }).then((onValue) => {
          comment != null
              ? Comment.addNewComment(docRef.documentID,user.id,
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
      backgroundColor: Color.fromARGB(255, 244, 174, 124),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(setImage, setComment),
          Text(
            "Weight",
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
                        child: TextFormField(
                          controller: _weightController,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text("kg"),
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
                      _addWeight(context);
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
