import 'package:carehomeapp/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carehomeapp/feeditem_model.dart';

import 'dart:async';
import 'dart:io';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String carehome;

   List<FeedItem> getFeedItems() {
    List<FeedItem> userFeedItems;

    Firestore.instance
        .collection('feedItem')
        .where("user", isEqualTo: this.id)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => userFeedItems.add(
            new FeedItem(
                doc["name"], doc["type"], doc["body"]))));

    return userFeedItems;
  }

  Future<List<Patient>> getPatients() async {
    List<Patient> userPatients = new List<Patient>();

    QuerySnapshot snapshot = await Firestore.instance
    .collection('patients')
    .where('carehome', isEqualTo:'AKWnLcXz2JCXazm5Ts5P')
    .getDocuments();

    snapshot.documents.forEach((data) =>
      userPatients.add(
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

  User(this.id, this.firstName,this.lastName,this.email);
}