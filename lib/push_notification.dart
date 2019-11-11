import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'model/user_model.dart';

class PushNotification {
  

  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  var data = {};
  String title;
  String body;
  String to;

  PushNotification(String title, String body, String to) {
    data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": to
    };
  }

  void scheduleNotification(Time time, String type)  {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '$type channel',
        '$type',
        'daily $type reminder');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        '$title',
        '$body at ${time.hour.toString().padLeft(2, '0')}: ${time.minute.toString().padLeft(2, '0')}',
        time,
        platformChannelSpecifics).then((_) =>
          print('Notification scheduled')
        );
  }

  static void sendPostNotifications(User user,
      String checkType, String patientId, String patientName) {
    Firestore.instance
        .collection('users')
        .where('following', arrayContains: patientId)
        .getDocuments()
        //Send notification to all user with notifications enabled who are following this patient
        .then((dbusers) => dbusers.documents.forEach((dbuser) =>
            dbuser['notificationpatient'] == true &&
                    List.from(dbuser['following']).contains(patientId)
                ? Firestore.instance
                    .collection('users')
                    .document(dbuser.documentID)
                    .collection('tokens')
                    .getDocuments()
                    .then((snap) => snap.documents.forEach((doc) => PushNotification(
                            'Patient Post Notification',
                            '${user.firstName} ${user.lastName} posted a $checkType check for $patientName',
                            doc['token'])
                        .send()
                        .then((sent) => print('sent post notification'))))
                : null));
  }

  Future<bool> send() async {
    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA3tJDHvo:APA91bEcukAYbTh0LDQJvTwkG8ZRAITQwIqal9ZFwFvLOViPXCN3Xz--kaJmzmO19O-isPxGczY65uJTxofEg9Lw6BfSP30jvbDSfDiWobhxojWLmhrp7SAMC6q-UpA1m4B_au4vXzNl'
    };

    final response = await http.post(postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
