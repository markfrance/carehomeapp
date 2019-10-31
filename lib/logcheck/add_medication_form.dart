import 'package:carehomeapp/logcheck/form_header.dart';
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
  String _time = "";
  String imageurl;

  void _addMedication(BuildContext context) {
    final user = UserBinding.of(context).user;

    Firestore.instance.collection('feeditem').document().setData({
      'timeadded': DateTime.now(),
      'type': 'medication',
      'subtype': 'medication',
      'patient': widget.patient.id,
      'patientname': widget.patient.firstname + " " + widget.patient.lastname,
      'user': user.id,
      'medication': _medicationController.text,
      'dose': _doseController.text,
      'medicationtime': _time,
      'imageurl': imageurl
    }).then((onValue) => Navigator.pop(context));
  }

  void setImage(String newimageurl) {
    setState(() {
      imageurl = newimageurl;
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
          FormHeader(setImage),
          Text(
            "Add Medication",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(child:Text("Medication"),alignment:Alignment.centerLeft),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _medicationController,
                  ),
                ),
                Align(child:Text("Dose"),alignment:Alignment.centerLeft),
                Row(
                  children:<Widget>[Expanded(
                    flex:1,
                    child:Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _doseController,
                  ),
                ),),
                Spacer()]),
                Align(child:Text("Time"),alignment:Alignment.centerLeft),
                Align(
                  alignment: Alignment.centerLeft,
                  child:Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5.0)),
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(
                            backgroundColor: Color.fromARGB(255, 250, 243, 242),
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                        
                        _time =
                            '${time.hour} : ${time.minute} ';
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                      setState(() {});
                    },
                    child: Text(_time, style: TextStyle(color: Colors.black),),
                  ),
                ),),
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
