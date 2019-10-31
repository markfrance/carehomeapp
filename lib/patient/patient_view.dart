import 'package:carehomeapp/patient/patient_edit.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';


class PatientView extends StatelessWidget {

  PatientView(this.patient);
  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: YellowDrawer(),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
          title: Text('Patient Data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(flex: 5, child: Padding(
              padding: const EdgeInsets.only(
                top: 18.0,
                bottom: 18.0,
         
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left:24, right:24, top:8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                            "assets/images/avatar_placeholder_small.png",
                            width: 50,
                            height: 50),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(patient.firstname,
                          style: Theme.of(context).textTheme.subhead),
                      Text(patient.lastname,
                          style: Theme.of(context).textTheme.subhead),
                      Text(patient.age.toString(),
                          style: Theme.of(context).textTheme.subhead),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(right:16),
                      child:Align(
                    alignment: Alignment.bottomRight,
                    child:RaisedButton(
                      color:Colors.black,
                      child: Text('Following'),
                  onPressed: null,),)),
                 
                ],
              ),
            )),
                  Expanded(
                      child: RaisedButton(
                        color:Colors.black,
                        padding: EdgeInsets.all(8),
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
              Padding(
                padding:EdgeInsets.only(left:50, right:50),
                child:Align(
                alignment:Alignment.centerLeft,
                child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
             
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Likes", style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:8, bottom:16),
                    child: Text(this.patient.likes ?? "", ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Dislikes",style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:8, bottom:16),
                    child: Text( this.patient.dislikes ?? "")),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Medical Condition",style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:8, bottom:16),
                    child: Text(this.patient.medicalcondition ?? ""),),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contacts",style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                  Padding(
                    padding: EdgeInsets.only( left:8, bottom:16),
                    child: Text(this.patient.contacts ?? ""),),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Key Nurse",style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                  Padding(
                    padding: EdgeInsets.only( left:8, bottom:16),
                    child: Text(this.patient.keynurse ?? ""), ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Contra Indications",style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:8, bottom:16),
                    child: Text(this.patient.contraindications ?? ""),),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that they hate",style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:8, bottom:16),
                    child: Text(this.patient.frustrate ?? ""),),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Things that they love",style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom:16),
                    child: Text(this.patient.love ?? ""), ),
                ],
              ),
              ))],
          ),),
        );
  }
}
