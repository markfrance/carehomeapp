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
       
        elevation: 4,
        margin:EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
      color: Color.fromARGB(255, 250, 243, 242),
      child: Padding(

        padding: const EdgeInsets.only(
          top: 18.0,
          bottom: 18.0,
          left: 64.0,
        ),

        child:Column(
          
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