import 'package:carehomeapp/logcheck/form_header.dart';
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddMedicationForm extends StatefulWidget {
  final Patient patient;
  AddMedicationForm(this.patient);

  @override
  MedicationFormState createState() => MedicationFormState();
}

class MedicationFormState extends State<AddMedicationForm> {
  final _medicationController = TextEditingController();
  final _doseController = TextEditingController();
  String _timeString = "";
  DateTime _time;
  String imageurl;
  String comment;

  void _addMedication(BuildContext context) {
    final user = UserBinding.of(context).user;

    final docRef = Firestore.instance.collection('medication').document();

    docRef.setData({
      'lastupdated': DateTime.now(),
      'patient': widget.patient.id,
      'patientimage': widget.patient.imageUrl,
      'patientname': widget.patient.firstname + " " + widget.patient.lastname,
      'user': user.id,
      'username': user.firstName + " " + user.lastName,
      'medication': _medicationController.text,
      'dose': _doseController.text,
      'time': _time,
      'done': false
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
      backgroundColor: Color.fromARGB(255, 109, 191, 218),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(setImage, setComment),
          Text(
            "Add Medication",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                    child: Text("Medication"), alignment: Alignment.centerLeft),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _medicationController,
                  ),
                ),
                Align(child: Text("Dose"), alignment: Alignment.centerLeft),
                Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _doseController,
                      ),
                    ),
                  ),
                  Spacer()
                ]),
                Align(child: Text("Time"), alignment: Alignment.centerLeft),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlatButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5.0)),
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            theme: DatePickerTheme(
                              backgroundColor:
                                  Color.fromARGB(255, 250, 243, 242),
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true, onConfirm: (time) {
                          _timeString = '${time.hour} : ${time.minute} ';
                          _time = time;
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                        setState(() {});
                      },
                      child: Text(
                        _timeString,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _addMedication(context);
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
