import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/user_binding.dart';
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

   void _addBloodSugarLevel(BuildContext context)
  {
     final user = UserBinding.of(context).user;
     
    Firestore.instance.collection('feeditem').document().setData(
      {
        'timeadded': DateTime.now(),
        'type': 'vitals',
        'subtype': 'bloodsugar',
        'patient': widget.patient.id,
        'user' : user.id,
        'level': _levelController.text
      }
    ).then(
      (onValue) => Navigator.pop(context)
    );
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
          FormHeader(),
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
                        child: TextFormField(
                          controller:_levelController
                        ),
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
                    child: Text("Save"),
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
