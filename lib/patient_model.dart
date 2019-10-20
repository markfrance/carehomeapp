import 'package:carehomeapp/feeditem_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  String id;
  final String firstname;
  final String lastname;
  final String carehome;
  final int age;
  String imageUrl;

  static void addNewPatient(Patient newPatient) {
    Firestore.instance.collection('patients').document().setData({
      'carehome': newPatient.carehome,
      'firstname': newPatient.firstname,
      'lastname': newPatient.lastname,
      'age': newPatient.age
    });
  }



 

  Patient(this.firstname, this.lastname, this.age, this.carehome);
}
