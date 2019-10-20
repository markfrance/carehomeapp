import 'package:carehomeapp/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carehomeapp/feeditem_model.dart';


class User {
  String id;
  String firstName;
  String lastName;
  String email;

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

  List<Patient> getPatients() {
    List<Patient> userPatients;

    Firestore.instance
        .collection('patients')
        .where("user", arrayContains: this.id)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => userPatients.add(
            new Patient(
                doc["name"], doc["type"], doc["body"], doc["carehome"]))));

    return userPatients;
  }

  User(this.firstName,this.lastName,this.email);
}