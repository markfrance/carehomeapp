import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BloodPressureForm extends StatefulWidget {
  final Patient patient;
  BloodPressureForm(this.patient);
  
  @override
  BloodPressureFormState createState() => BloodPressureFormState();
}

class BloodPressureFormState extends State<BloodPressureForm> {
   final _systolicController = TextEditingController();
   final _diastolicController = TextEditingController();

   void _addBloodPressure(BuildContext context)
  {
     final user = UserBinding.of(context).user;
     
    Firestore.instance.collection('feeditem').document().setData(
      {
        'timeadded': DateTime.now(),
        'type': 'vitals',
        'subtype': 'bloodpressure',
        'patient': widget.patient.id,
        'user' : user.id,
        'systolic': _systolicController.text,
        'diastolic': _diastolicController.text
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
            "Blood Pressure",
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
                          controller: _systolicController,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text("Systolic"),
                      flex: 1,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller:_diastolicController
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text("Diastolic"),
                      flex: 1,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: () {
                      _addBloodPressure(context);
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
