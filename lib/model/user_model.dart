import 'package:carehomeapp/model/carehome_model.dart';
import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  Carehome carehome;
  bool isManager;
  bool isSuperAdmin;

  /* List<FeedItem> getFeedItems() {
   Firestore.instance
        .collection('feedItem')
        .where("user", isEqualTo: this.id)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => userFeedItems.add(
            new FeedItem(
                doc["timeadded"],doc["type"], doc["subtype"], doc["user"], doc["patient"]))));

    return userFeedItems;
  }*/


  static Future<List<User>> getUsers([Carehome carehome, User user]) async {

    List<User> users = new List<User>();

    QuerySnapshot snapshot;
    if(!user.isSuperAdmin) {
      snapshot = await Firestore.instance
    .collection('users')
    .where('carehome', isEqualTo: user.carehome)
    .getDocuments();
    }
    else if(carehome == null || carehome.id == '0') {
    snapshot = await Firestore.instance
    .collection('users')
    .getDocuments();
    } else {
      snapshot = await Firestore.instance
    .collection('users')
    .where('carehome', isEqualTo: carehome.id)
    .getDocuments();
    }

    snapshot.documents.forEach((data) =>
    users.add(User(
      data.documentID,
      data['firstname'],
      data['lastname'],
      data['email'],
      data['ismanager'],
      data['issuperadmin'],
      Carehome(data['carehome'], data['carehomename'])
    )));

  return users;
  }

  Future<List<Patient>> getPatients([String dropdownValue]) async {
    List<Patient> userPatients = new List<Patient>();
    QuerySnapshot snapshot;

    if(dropdownValue == "Following"){

      snapshot = await Firestore.instance
        .collection('patients')
        .where('carehome', isEqualTo: carehome.id)
        .getDocuments();
    }
    else if(dropdownValue == "Alphabetically"){
       snapshot = await Firestore.instance
        .collection('patients')
        .where('carehome', isEqualTo: carehome.id)
        .orderBy('lastname')
        .getDocuments();
    } else {
    snapshot = await Firestore.instance
        .collection('patients')
        .where('carehome', isEqualTo: carehome.id)
        .getDocuments();
    }

    snapshot.documents.forEach((data) => userPatients.add(new Patient(
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

    return userPatients;
  }

  Future<int> getScore() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('feeditem')
        .where('user', isEqualTo: id)
        .where('timeadded',
            isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)))
        .getDocuments();

    return snapshot.documents.length;
  }

  Future<int> getFollowing() async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(id).get();

    List<String> following = List.from(snapshot.data['following']);

    return following.length;
  }

  User(this.id, this.firstName, this.lastName, this.email, this.isManager, this.isSuperAdmin, this.carehome);
}
