import 'package:carehomeapp/admin/patient_report.dart';
import 'package:carehomeapp/feed/image_view.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/patient/patient_edit.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PatientView extends StatefulWidget{
PatientView(this.patient, this.user);

  final Patient patient;
  final User user;

  @override
  State<StatefulWidget> createState() => PatientViewState();
}

class PatientViewState extends State<PatientView> {
  
  Patient patient;

  @override
  void initState() { 
    super.initState();
  setPatient();
  }

  void setPatient(){
     Firestore.instance
        .collection('patients')
        .document(widget.patient.id)
        .get()
        .then((data) => setState(() => 
  patient = Patient(
            data.documentID,
            data['firstname'],
            data['lastname'],
            data['age'],
            data['carehome'],
            data['likes'],
            data['dislikes'],
            data['medicalcondition'],
            data['contacts'],
            data['keynurse'],
            data['contraindications'],
            data['frustrate'],
            data['love'],
            data['imageurl'])));
  }

_navigateAndDisplayEdit(BuildContext context) async {

    final Patient result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  PatientEdit(this.patient, this.widget.user)
    ));

   setPatient();
  }

  @override
  Widget build(BuildContext context) {

   if(patient == null) {
     return CircularProgressIndicator();
   }
    return Scaffold(
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
                Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 18.0,
                        bottom: 18.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: GestureDetector(
                                    child: CachedNetworkImage(
                                        imageUrl: patient.imageUrl ??
                                            "https://firebasestorage.googleapis.com/v0/b/carehomeapp-a2936.appspot.com/o/avatar_placeholder_small.png?alt=media&token=32adc9ac-03ad-45ed-bd4c-27ecc4f80a55",
                                        placeholder: (context, url) => Image.asset(
                                            "assets/images/avatar_placeholder_small.png",
                                            width: 50,
                                            height: 50),
                                        width: 50,
                                        height: 50),
                                    onTap: () {
                                      patient.imageUrl != null
                                          ? Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                              return ImageView(
                                                  patient.imageUrl);
                                            }))
                                          : null;
                                    }),
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
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: RaisedButton(
                                color: Colors.black,
                                child: Text('Report'),
                                onPressed: () => Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                              return PatientReport(patient, widget.user);
                                            })),
                              ),
                            ),
                          ),
                          RaisedButton(
                            color: Colors.black,
                            padding: EdgeInsets.all(8),
                            child: Text("Edit"),
                            onPressed: () {
                             _navigateAndDisplayEdit(context);
                            },
                          ),
                          Spacer()
                        ],
                      ),
                    )),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Likes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 16),
                        child: Text(
                          this.patient.likes ?? "",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Dislikes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 16),
                          child: Text(this.patient.dislikes ?? "")),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Medical Condition",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 16),
                        child: Text(this.patient.medicalcondition ?? ""),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Contacts",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 16),
                        child: Text(this.patient.contacts ?? ""),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Key Nurse",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 16),
                        child: Text(this.patient.keynurse ?? ""),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Contra Indications",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 16),
                        child: Text(this.patient.contraindications ?? ""),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Things that they hate",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 16),
                        child: Text(this.patient.frustrate ?? ""),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Things that they love",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 16),
                        child: Text(this.patient.love ?? ""),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
