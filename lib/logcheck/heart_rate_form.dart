
import 'package:carehomeapp/logcheck/form_header.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HeartRateForm extends StatefulWidget {
  final Patient patient;
  HeartRateForm(this.patient);
  
  @override
  HeartRateFormState createState() => HeartRateFormState();
}


class HeartRateFormState extends State<HeartRateForm> {

  final _rateController = TextEditingController();
  String imageurl;
  String comment;

   void _addHeartRate(BuildContext context)
  {
     final user = UserBinding.of(context).user;
     
    Firestore.instance.collection('feeditem').document().setData(
      {
        'timeadded': DateTime.now(),
        'type': 'vitals',
        'subtype': 'heartrate',
        'patient': widget.patient.id,
        'patientimage': widget.patient.imageUrl,
       'patientname': widget.patient.firstname + " " +widget.patient.lastname,
        'user' : user.id,
        'username' : user.firstName + " " + user.lastName,
        'bpm': _rateController.text,
        'imageurl': imageurl
      }
    ).then(
      (onValue) => Navigator.pop(context)
    );
  }

   void setImage(String newimageurl) {
    setState((){
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
      backgroundColor: Color.fromARGB(255, 251, 148, 148),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(setImage, setComment),
          Text(
            "Heart Rate",
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
                          controller: _rateController
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text("bpm"),
                      flex: 1,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style:TextStyle(color: Colors.white)),
                    onPressed: () {
                      _addHeartRate(context);
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
