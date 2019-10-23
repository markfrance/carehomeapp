import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/user_binding.dart';
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

  void _addWeight(BuildContext context) {
    final user = UserBinding.of(context).user;

    Firestore.instance.collection('feeditem').document().setData({
      'timeadded': DateTime.now(),
      'type': 'body',
      'subtype': 'weight',
      'patient': widget.patient.id,
      'patientname': widget.patient.firstname + " " +widget.patient.lastname,
      'user': user.id,
      'weight': _weightController.text,
        'imageurl': imageurl
    }).then((onValue) => Navigator.pop(context));
  }

   void setImage(String newimageurl) {
    setState((){
      imageurl = newimageurl;
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
          FormHeader(setImage),
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
                          controller:_weightController,
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
                    child: Text("Save"),
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
