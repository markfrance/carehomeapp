import 'package:flutter/material.dart';
import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/patients_card.dart';


class PatientView extends StatelessWidget {

  final Patient patient = new Patient("first", "patient", 65);

  @override
  Widget build(BuildContext context){
    return Column(
      
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[ PatientCard(this.patient),],),
        
        Text("Likes"),
  
        
      ]
    );
  }
}