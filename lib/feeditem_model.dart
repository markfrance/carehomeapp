import 'package:carehomeapp/patient_model.dart';
import 'package:carehomeapp/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum CheckType {
  mood,
  vitals,
  medication,
  nutrition,
  body,
  other,
}

enum SubType {
  bloodpressure,
  bloodsugarlevel,
  heartrate,
  hydration,
  meals,
  weight,
  hygiene,
  toilet,
  activity,
  incident
}

class Comment {
  final String carer;
  final String feeditem;
  final DateTime time;
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
  final Patient patient;
  final User carer;
  final DateTime timeAdded;
  final CheckType type;
  final SubType subType;
  String body;
  String imageUrl;
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

  FeedItem(this.timeAdded, this.type, this.subType,this.carer,this.patient,
  [
    mood,
    systolic,
    diastolic,
    mmol,
    bpm,
    medication,
    dose,
    time,
    hotcold,
    l,
    ml,
    otherdrink,
    gm,
    description,
    weight,
    otherhygiene,
    toilettype,
    status,
    activity,
    incident
  ]);
}
