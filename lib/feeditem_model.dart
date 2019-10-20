import 'package:cloud_firestore/cloud_firestore.dart';

enum CheckType {
  mood,
  vitals,
  medication,
  nutrition,
  body,
  other,
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
  final String name;
  DateTime date;
  final CheckType type;
  final String body;
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

  void addNewBloodPressure(int systolic, int diastolic) {
    Firestore.instance
      .collection('feeditem').document()
      .setData({
      'type': 'vitals',
      'subtype': 'bloodpressure',
      'patient': 'test',
      'user': 'test',
      'time':'08:43',
      'systolic': systolic,
      'diastolic': diastolic
    });
  }

  FeedItem(this.name, this.type, this.body);
}
