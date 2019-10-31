
import 'package:cloud_firestore/cloud_firestore.dart';


class Comment {
  final String carer;
  final String feeditem;
  final String time;
  final String text;


  static void addNewComment(Comment newComment) {
    Firestore.instance.collection('comments').document().setData({
      'user': newComment.carer,
      'feeditem': newComment.feeditem,
      'time': newComment.time,
      'text': newComment.text
    });
  }

  Comment(this.carer, this.feeditem, this.time, this.text);
}

class FeedItem {
  String id;
  final String patientname;
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
  List<Comment> comments;

  List<Comment> getComments() {
    List<Comment> itemComments;

    Firestore.instance
        .collection('comments')
        .where("feeditem", isEqualTo: this.id)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => itemComments.add(
            new Comment(
                doc["user"], doc["feeditem"], doc["time"], doc["text"]))));

    return itemComments;
  }

  FeedItem(this.timeAdded, this.type, this.subType,this.user,this.patientname,
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
