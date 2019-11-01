import 'package:carehomeapp/model/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String carehome;

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

  Future<List<Patient>> getPatients() async {
    List<Patient> userPatients = new List<Patient>();

    QuerySnapshot snapshot = await Firestore.instance
        .collection('patients')
        .where('carehome', isEqualTo: 'AKWnLcXz2JCXazm5Ts5P')
        .getDocuments();

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
        data['love'])));

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

  User(this.id, this.firstName, this.lastName, this.email);
}
