import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/logcheck/form_header.dart';
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
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
  String imageurl;
  String comment;

  void _addMood(BuildContext context) {
    final user = UserBinding.of(context).user;

    final docRef = Firestore.instance.collection('feeditem').document();
    docRef.setData({
      'timeadded': DateTime.now(),
      'type': 'mood',
      'subtype': 'mood',
      'patient': widget.patient.id,
      'patientimage': widget.patient.imageUrl,
      'patientname': widget.patient.firstname + " " + widget.patient.lastname,
      'user': user.id,
      'username' : user.firstName + " " + user.lastName,
      'mood': mood,
      'imageurl': imageurl,
      'logdescription': "Mood: " + mood
    }).then((onValue) => 
    {
         comment != null ? Comment.addNewComment(docRef.documentID, user.id, user.firstName + " " + user.lastName, comment) : null,

      Navigator.pop(context)});
  }

  
  void setImage(String newimageurl) {
    setState(() {
      imageurl = newimageurl;
    });
  }
   void setComment(String newComment){
    setState((){
      comment = newComment;
    });
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
          FormHeader(setImage, setComment),
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
                
                
                  DropdownButton<String>(
                  hint: mood == null ? Text("Mood") : Text(mood),
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
                      mood = newValue;
                    });
                  },
                  items: <String>['Great', 'Happy', 'Neutral', 'Confused', 'Sad', 'Unwell']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        color: Color.fromARGB(255, 250, 243, 242),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
                
                Center(
                  child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _addMood(context);
                    },
                  ),
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
