import 'package:flutter/material.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/patients_card.dart';

class PatientsList extends StatefulWidget {

  final List<Patient> initialPatients = []
    ..add(Patient('first', 'patient', 43, 'test'))
    ..add(Patient('second', 'patient', 33,'test'))
    ..add(Patient('third', 'patient', 65,'test'))
    ..add(Patient('fourth', 'patient', 14,'test'));

  @override
  _PatientsListState createState() => _PatientsListState(initialPatients);
}

class _PatientsListState extends State<PatientsList> {
  final List<Patient> patients;
  _PatientsListState(this.patients);
  String dropdownValue = 'Most recent';

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, int) {
        return PatientCard(patients[int]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Align(
        alignment: Alignment.topLeft,
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['Most recent', 'Following', 'Alphabetically']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                color: Color.fromARGB(255, 250, 243, 242),
                child: Text(value),
              ),
            );
          }).toList(),
        ),
      ),
      Expanded(child: _buildList(context), flex: 1)
    ]);
  }
}
