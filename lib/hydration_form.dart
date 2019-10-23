import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HydrationForm extends StatefulWidget {
  final Patient patient;
  HydrationForm(this.patient);
  
  @override
  HydrationFormState createState() => HydrationFormState();
}


class HydrationFormState extends State<HydrationForm> {

  String hotcold;
  final _lController = TextEditingController();
  final _mlController = TextEditingController();
  final _otherController = TextEditingController();

   void _addHydration(BuildContext context)
  {
     final user = UserBinding.of(context).user;
     
    Firestore.instance.collection('feeditem').document().setData(
      {
        'timeadded': DateTime.now(),
        'type': 'nutrition',
        'subtype': 'hydration',
        'patient': widget.patient.id,
        'user' : user.id,
        'hotcold': hotcold,
        'l': _lController.text,
        'ml': _mlController.text,
        'other': _otherController.text,
      }
    ).then(
      (onValue) => Navigator.pop(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 186, 225, 189),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(),
          Text(
            "Hydration",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Cold"),
                          onPressed: () => setState((){
                            hotcold = "cold";
                          },),
                        ),
                        RaisedButton(
                          child: Text("Hot"),
                          onPressed: () => setState((){
                            hotcold = "hot";
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _lController,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Text("L"),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text("or"),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller:_mlController,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Text("ml"),
                      flex: 1,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "other",
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8.0), child: TextFormField(
                  controller: _otherController,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: () {
                      _addHydration(context);
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
