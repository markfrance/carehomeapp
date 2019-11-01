
import 'package:carehomeapp/logcheck/form_header.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HydrationForm extends StatefulWidget {
  final Patient patient;
  HydrationForm(this.patient);
  
  @override
  HydrationFormState createState() => HydrationFormState();
}


class HydrationFormState extends State<HydrationForm> {

  String hotcold = 'cold';
  final _lController = TextEditingController();
  final _mlController = TextEditingController();
  final _sugarController = TextEditingController();
  String imageurl;

   void _addHydration(BuildContext context)
  {
     final user = UserBinding.of(context).user;
     
    Firestore.instance.collection('feeditem').document().setData(
      {
        'timeadded': DateTime.now(),
        'type': 'nutrition',
        'subtype': 'hydration',
        'patient': widget.patient.id,
        'patientname': widget.patient.firstname + " " +widget.patient.lastname,
        'user' : user.id,
        'hotcold': hotcold,
        'l': _lController.text,
        'ml': _mlController.text,
        'sugar': _sugarController.text,
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
          FormHeader(setImage),
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
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Wrap(
                      direction: Axis.horizontal,
                      
                      children: <Widget>[
                        RaisedButton(
                          color: hotcold == 'cold' ? Colors.white : Color.fromARGB(255, 158, 192, 161),
                          child: Text("Cold"),
                          onPressed: () => setState((){
                            hotcold = "cold";
                          },),
                        ),
                        RaisedButton(
                          color: hotcold == 'hot' ? Colors.white : Color.fromARGB(255, 158, 192, 161),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Sweetner/sugar",
                    textAlign: TextAlign.start,
                  ),),
                ),
                Row(
                  children:<Widget>[
                    Expanded(
                      child:Padding(padding: EdgeInsets.all(8.0), child: TextFormField(
                  controller: _sugarController,
                )
                ),flex:1),
                Expanded(
                  flex:1,
                  child:Text("tsp")),
                  Spacer(),
                ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style:TextStyle(color: Colors.white)),
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