import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class ToiletForm extends StatefulWidget {
  final Patient patient;
  ToiletForm(this.patient);

  @override
  ToiletFormState createState() => ToiletFormState();
}


class ToiletFormState extends State<ToiletForm> {

 final _statusController = TextEditingController();
 String toiletType;
 String imageurl;

  void _addToilet(BuildContext context) {
    final user = UserBinding.of(context).user;

    Firestore.instance.collection('feeditem').document().setData({
      'timeadded': DateTime.now(),
      'time': DateTime.now(),
      'type': 'body',
      'subtype': 'toilet',
      'patient': widget.patient.id,
      'patientname': widget.patient.firstname + " " +widget.patient.lastname,
      'user': user.id,
      'toilettype': toiletType,
      'status': _statusController.text,
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
            "Toilet",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ButtonBar(
                  children: <Widget>[
                    Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Urine"),
                          onPressed: () => setState(() {
                            toiletType = "urine";
                          },),
                        ),
                        RaisedButton(
                          child: Text("Stool"),
                          onPressed: () => setState((){
                            toiletType = "stool";
                          }),
                        )
                      ],
                    ),
                  ],
                ),
                Text("Status"),
                TextField(
                  controller: _statusController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: () {
                      _addToilet(context);
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
