import 'package:carehomeapp/patient/patient_view.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/patient/patients_card.dart';

class PatientAdd extends StatefulWidget {
 final Patient patient;
  PatientAdd(this.patient);

  @override
  PatientAddState createState() => PatientAddState();
}

class PatientAddState extends State<PatientAdd> {
  
  final _likesController = TextEditingController();
  final _dislikesController = TextEditingController();
  final _medicalconditionController = TextEditingController();
  final _contactsController = TextEditingController();
  final _keynurseController = TextEditingController();
  final _contraindicationsController = TextEditingController();
  final _frustrateController = TextEditingController();
  final _loveController = TextEditingController();

  @override
  void initState() {
    _likesController.text = widget.patient.likes;
    _contactsController.text = widget.patient.contacts;
    _contraindicationsController.text = widget.patient.contraindications;
    _dislikesController.text = widget.patient.dislikes;
    _frustrateController.text = widget.patient.frustrate;
    _keynurseController.text = widget.patient.keynurse;
    _loveController.text = widget.patient.love;
    _medicalconditionController.text = widget.patient.medicalcondition;
    return super.initState();
  }

  void _addPatientData(BuildContext context)
  {
    Firestore.instance.collection('patients').document().setData(
      {
        
        'likes': _likesController.text,
        'dislikes' : _dislikesController.text,
        'medicalcondition': _medicalconditionController.text,
        'contacts': _contactsController.text,
        'keynurse': _keynurseController.text,
        'contraindications':_contraindicationsController.text,
        'frustrate': _frustrateController.text,
        'love': _loveController.text
      }
    ).then(
      (onValue) => Navigator.pop(context)
    );
  }

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
        endDrawer: YellowDrawer(),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
          title: Text('Edit Patient Data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(flex: 5, child: PatientCard(widget.patient)),
                  Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(1.0),
                        child: Text("Save"),
                        onPressed: () {
                          _addPatientData(context);
                        },
                      ),
                      flex: 1)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Likes"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _likesController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Dislikes"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _dislikesController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Medical Condition"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _medicalconditionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contacts"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _contactsController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Key Nurse"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _keynurseController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contra Indications"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _contraindicationsController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that frustrate"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _frustrateController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that they love"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _loveController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
