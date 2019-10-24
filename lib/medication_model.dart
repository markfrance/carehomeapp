import 'package:carehomeapp/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carehomeapp/feeditem_model.dart';

import 'dart:async';

class Medication {
  String id;
  String medication;
  String dose;
  DateTime time;


 /* Future<List<Medication>> getPatients(Patient patient) async {
    List<Medication> patientMedication = new List<Medication>();

    QuerySnapshot snapshot = await Firestore.instance
    .collection('patients')
    .where('carehome', isEqualTo:'AKWnLcXz2JCXazm5Ts5P')
    .getDocuments();

    snapshot.documents.forEach((data) =>
      patientMedication.add(
      new Patient(
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
                data['love'])));    

      return userPatients;  
  }
  */

  Medication(this.id, this.medication,this.dose,this.time);
}