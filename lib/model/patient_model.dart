import 'package:carehomeapp/model/feeditem_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  String id;
  final String firstname;
  final String lastname;
  final String carehome;
  String likes = " ";
  String dislikes = " ";
  String medicalcondition = " ";
  String contacts = " ";
  String keynurse = " ";
  String contraindications = " ";
  String frustrate = " ";
  String love = " ";
  final int age;
  String imageUrl = " ";

  static void addNewPatient(Patient newPatient) {
    Firestore.instance.collection('patients').document().setData({
      'carehome': 'AKWnLcXz2JCXazm5Ts5P',
      'firstname': newPatient.firstname,
      'lastname': newPatient.lastname,
      'age': newPatient.age
    });
  }



 

  Patient(
    this.id,
    this.firstname, 
  this.lastname, 
  this.age, 
  this.carehome,
  [this.likes,
  this.dislikes,
  this.medicalcondition,
  this.contacts,
  this.keynurse,
  this.contraindications,
  this.frustrate,
  this.love]
  );
}
