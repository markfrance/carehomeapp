import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class PushNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

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

  void scheduleNotification(Time time) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        '$title',
        'Daily notification shown at approximately ${time.hour.toString().padLeft(2, '0')}: ${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}',
        time,
        platformChannelSpecifics);
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
