
import 'package:carehomeapp/logcheck/add_medication_form.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/model/medication_model.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MedicationForm extends StatefulWidget {
  final Patient patient;
  final bool showHeader;
  MedicationForm(this.patient, this.showHeader);

  @override
  MedicationState createState() => new MedicationState();
}

class MedicationState extends State<MedicationForm> {
  List<Medication> medicationList = new List<Medication>();

  String imageurl;

  void setImage(String newimageurl) {
    setState(() {
      imageurl = newimageurl;
    });
  }

  Future<List<Medication>> getMedications() async {
    medicationList.clear();

    QuerySnapshot snapshot = await Firestore.instance
        .collection('medication')
        .where('patient', isEqualTo: widget.patient.id)
        .getDocuments();

    snapshot.documents.forEach((data) => {
          medicationList.add(new Medication(data.documentID, data['medication'],
              data['dose'], data['time'].toDate(), data['done']))
        });

    return medicationList;    
  }

  void setMedication(Medication med, bool done) {
    final user = UserBinding.of(context).user;

    Firestore.instance
        .collection('medication')
        .document(med.id)
        .updateData({'lastupdated': DateTime.now(), 'done': done});

    //Check if user like notifications are enabled
    //Create daily reminder notiofication
    //LocalNotification().scheduleNotification(Time(med.time.hour, med.time.minute, 0));

    if (done) {
      //Create feed item
      Firestore.instance.collection('feeditem').document().setData({
        'timeadded': DateTime.now(),
        'type': 'medication',
        'subtype': 'medication',
        'patient': widget.patient.id,
        'patientimage': widget.patient.imageUrl,
        'patientname': widget.patient.firstname + " " + widget.patient.lastname,
        'user': user.id,
        'medication': med.medication,
        'dose': med.dose,
        'medicationtime':
            med.time.hour.toString() + ":" + med.time.minute.toString(),
        'imageurl': imageurl,
        'logdescription': "Took " +
            med.dose +
            " " +
            med.medication +
            " at " +
            med.time.hour.toString() +
            ":" +
            med.time.minute.toString()
      });
    }
  }

  Widget _buildList(BuildContext context) {
    return FutureBuilder<List<Medication>>(
        future: getMedications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, int) {
              return CheckboxListTile(
                activeColor: Colors.black,
                checkColor: Colors.white,
                title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            snapshot.data[int].time.hour.toString() +
                                ":" +
                                snapshot.data[int].time.minute.toString(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(snapshot.data[int].dose +
                            " " +
                            snapshot.data[int].medication),
                      )
                    ]),
                value: snapshot.data[int].done,
                onChanged: (bool value) {
                  setState(() {
                    setMedication(medicationList[int], value);
                  });
                },
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Card(
        color: Color.fromARGB(255, 109, 191, 218),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Medication",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[_buildList(context)]),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: RaisedButton(
                        padding: EdgeInsets.all(0),
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddMedicationForm(widget.patient);
                          },
                        ),
                        child: Icon(
                          CareHomeIcons.addb,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
