import 'package:carehomeapp/patient_edit.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/patients_card.dart';

class PatientView extends StatelessWidget {

  PatientView(this.patient);
  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: YellowDrawer(),
        appBar: AppBar(
          title: Text('Patient Data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(flex: 5, child: PatientCard(this.patient)),
                  Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(1.0),
                        child: Text("Edit"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientEdit(this.patient)));
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
                    child: Text(this.patient.likes ?? ""),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Dislikes"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text( this.patient.dislikes ?? "")),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Medical Condition"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(this.patient.medicalcondition ?? ""),),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contacts"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(this.patient.contacts ?? ""),),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Key Nurse"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(this.patient.keynurse ?? ""), ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contra Indications"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(this.patient.contraindications ?? ""),),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that they hate"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(this.patient.frustrate ?? ""),),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that they love"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(this.patient.love ?? ""), ),
                ],
              ),
            ],
          ),
        ));
  }
}
