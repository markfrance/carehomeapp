import 'package:carehomeapp/patient_home.dart';
import 'package:flutter/material.dart';

import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/patient_view.dart';

class PatientCard extends StatefulWidget {
  final Patient patient;

  PatientCard(this.patient);

  @override
  _PatientCardState createState() => _PatientCardState(patient);
}

class _PatientCardState extends State<PatientCard> {
   Patient patient;

   _PatientCardState(this.patient);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () { Navigator.push(context,MaterialPageRoute(builder: (context) => PatientHome()),);},
      child:Card(
      color: Colors.white,
      child: Padding(

        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 64.0,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.patient.firstname,
                style: Theme.of(context).textTheme.subhead),
            Text(widget.patient.lastname,
                style: Theme.of(context).textTheme.subhead),
            Text(widget.patient.age.toString(),
                style: Theme.of(context).textTheme.subhead),
          ],
        ),
      ),
      ),
    );
  }
}