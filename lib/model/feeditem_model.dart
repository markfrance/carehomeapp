
import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment_model.dart';



class FeedItem {
  String id;
  final String patientname;
  final String patientImage;
  final String user;
  final DateTime timeAdded;
  final String type;
  final String subType;
  final String mood;
  final String systolic;
  final String diastolic;
  final String mmol;
  final String bpm;
  final String medication;
  final String dose;
  final String medicationtime;
  final String hotcold;
  final String l;
  final String ml;
  final String sugar;
  final String mealtype;
  final String gm;
  final String description;
  final String weight;
  final String hygienetype;
  final String otherhygiene;
  final String toilettype;
  final String status;
  final String activity;
  final String incident;
  final String imageUrl;
  final String task;
 

  FeedItem(
    this.id,
    this.timeAdded, 
    this.type, 
    this.subType,
    this.user,
    this.patientImage,
    this.patientname,
    this.mood,
    this.systolic,
    this.diastolic,
    this.mmol,
    this.bpm,
    this.medication,
    this.dose,
    this.medicationtime,
   this.hotcold,
    this.l,
    this.ml,
    this.sugar,
    this.mealtype,
    this.gm,
   this.description,
    this.weight,
    this.hygienetype,
    this.otherhygiene,
    this.toilettype,
    this.status,
    this.activity,
    this.incident,
    this.task,
    this.imageUrl
  );
}
