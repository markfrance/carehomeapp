import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/form_header.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/user_binding.dart';
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
  String _time = "time";

   void _addMedication(BuildContext context)
  {
     final user = UserBinding.of(context).user;
     
    Firestore.instance.collection('feeditem').document().setData(
      {
        'timeadded': DateTime.now(),
        'type': 'medication',
        'subtype': '',
        'patient': widget.patient.id,
        'user' : user.id,
        'medication': _medicationController.text,
        'dose': _doseController.text,
        'time': _time
      }
    ).then(
      (onValue) => Navigator.pop(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 204, 241, 255),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHeader(),
          Text(
            "Add Medication",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                Text("Medication"),
                 Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _medicationController,
                    ),
                  ),
                  Text("Dose"),
                 Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _doseController,
                    ),
                  ),
                  Text("Time"),
                 Padding(
                    padding: EdgeInsets.all(8.0),
                    child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    print('confirm $time');
                    _time = '${time.hour} : ${time.minute} : ${time.second}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
                },
                child:Text(_time),
                  ),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Save"),
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
