import 'package:carehomeapp/charts/chart_type_list.dart';
import 'package:carehomeapp/feed/feed_list.dart';
import 'package:carehomeapp/logcheck/medication_form.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/patient/patient_view.dart';
import 'package:carehomeapp/patient/tasks_view.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PatientHome extends StatefulWidget {
  PatientHome(this.patient, this.followText, this.user);

  final Patient patient;
  final String followText;
  final User user;
  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  Patient patient;
  int _selectedIndex = 0;

  @override
  void initState() {
   
    super.initState();
    setPatient();
  }
  void _setIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
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
  
  @override
  Widget build(BuildContext context) {
    final widgetOptions = [
      FeedList(widget.user, widget.patient),
      MedicationForm(widget.patient, false, widget.user),
      ChartTypeList(widget.patient, true),
      TasksView(widget.patient, widget.user)
    ];
   if(patient == null) {
     return CircularProgressIndicator();
   }

    return Scaffold(

      appBar: AppBar(
        title: Text(patient.firstname + " " + patient.lastname),
        backgroundColor: Color.fromARGB(255, 250, 243, 242),
      ),
      body: Column(children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                    top: 18.0,
                    bottom: 18.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 24, right: 24, top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                                  imageUrl: patient.imageUrl ?? "https://firebasestorage.googleapis.com/v0/b/carehomeapp-a2936.appspot.com/o/avatar_placeholder_small.png?alt=media&token=32adc9ac-03ad-45ed-bd4c-27ecc4f80a55",
                                  placeholder: (context, url) => Image.asset("assets/images/avatar_placeholder_small.png",width:50,height:50),
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
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: RaisedButton(
                              color: Colors.black,
                              child: Text(widget.followText),
                              onPressed: () => null,)
                        ),
                      )),
                      FlatButton(
                        child: Icon(Icons.info, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PatientView(patient, widget.user)));
                        },
                      ),
                    ],
                  ),
                ))
              ],
            ),
            Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 3,
                  child: RaisedButton(
                      child: Text("Feed"), onPressed: () => _setIndex(0)),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: RaisedButton(
                      child: Text("Medication"), onPressed: () => _setIndex(1)),
                ),
                Spacer(),
              ],
            ),
            Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 3,
                  child: RaisedButton(
                      child: Text("Chart"), onPressed: () => _setIndex(2)),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: RaisedButton(
                      child: Text("Tasks"), onPressed: () => _setIndex(3)),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
        Expanded(child: widgetOptions.elementAt(_selectedIndex))
      ]),
    );
  }
}
