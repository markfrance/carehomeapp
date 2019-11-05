import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String carer;
  final String feeditem;
  final DateTime time;
  final String text;

 static void addNewComment(String feedItem, String userId, String username, String body) {

    Firestore.instance.collection('feeditem')
    .document(feedItem)
    .collection('comments').document().setData({
      'user': userId,
      'username': username,
      'feeditem': feedItem,
      'time': DateTime.now(),
      'text': body
    });
  }

  Comment(this.username,this.carer, this.feeditem, this.time, this.text);
}