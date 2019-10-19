import 'package:flutter/material.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/patients_card.dart';

class PatientsList extends StatefulWidget {

  final List<Patient> initialPatients = []
    ..add(Patient('first', 'patient',43))
    ..add(Patient('second', 'patient',33))
    ..add(Patient('third', 'patient',65))
    ..add(Patient('fourth', 'patient',14));
   

  @override
  _PatientsListState createState() => _PatientsListState(initialPatients);
}

class _PatientsListState extends State<PatientsList> {
  
    final List<Patient> patients;
  _PatientsListState(this.patients);
  String dropdownValue = 'Most recent';

Widget _buildList(BuildContext context){
  return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: patients.length,
      // A callback that will return a widget.
      itemBuilder: (context, int) {
        // In our case, a DogCard for each doggo.
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
      Expanded(child: _buildList(context),
      flex:1)
      
    ]);
  }
}
