import 'package:carehomeapp/model/feeditem_model.dart';
import 'package:carehomeapp/push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comment {
  final String username;
  final String carer;
  final String feeditem;
  final DateTime time;
  final String text;

 static void addNewComment(String feedItem,  String userId, String username, String body, [String feedItemUser]) {

   
    Firestore.instance.collection('feeditem')
    .document(feedItem)
    .collection('comments').document().setData({
      'user': userId,
      'username': username,
      'feeditem': feedItem,
      'time': DateTime.now(),
      'text': body
    });

  if(feedItemUser != null){
    //Send push notification
    FirebaseAuth.instance.currentUser().then((user) =>
     Firestore.instance
                  .collection('users')
                  .document(feedItemUser)
                  .get()
                  .then((dbuser) => dbuser['notificationcomments'] == true
                      ? 
                        Firestore.instance.collection('users')
                        .document(user.uid)
                        .collection('tokens').getDocuments().then((snap)
                      => 
                        snap.documents.forEach((doc) => PushNotification(
                          'Comment notification',
                          '$username just said $body on your post',
                          doc['token']).send().then((sent) => print('sent comment notification')
                          )
                          )):null));
  }

  }

  Comment(this.username,this.carer, this.feeditem, this.time, this.text);
}