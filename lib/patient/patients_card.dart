import 'package:carehomeapp/patient/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';

class PatientCard extends StatefulWidget {
  final Patient patient;

  PatientCard(this.patient);

  @override
  _PatientCardState createState() => _PatientCardState(patient);
}

class _PatientCardState extends State<PatientCard> {
  Patient patient;
  String followText = "Follow";
  _PatientCardState(this.patient);

  void _follow() {
    setState(() {
      followText = "Following";
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatientHome(this.patient)),
          );
        },
        child: Card(
            elevation: 4,
            margin: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color.fromARGB(255, 250, 243, 242),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 18.0,
                bottom: 18.0,
         
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(8),
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
                      Text(widget.patient.firstname,
                          style: Theme.of(context).textTheme.subhead),
                      Text(widget.patient.lastname,
                          style: Theme.of(context).textTheme.subhead),
                      Text(widget.patient.age.toString(),
                          style: Theme.of(context).textTheme.subhead),
                    ],
                  ),
                  Expanded(
                    child:Padding(
                      padding: EdgeInsets.only(right:16),
                      child:Align(
                    alignment: Alignment.bottomRight,
                    child:RaisedButton(
                      color:Colors.black,
                      child: Text(followText),
                  onPressed: () => {_follow()}),),)),
                ],
              ),
            )));
  }


}
