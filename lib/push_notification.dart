
import 'dart:convert';
import 'package:http/http.dart' as http;

class PushNotification {

 final postUrl = 'https://fcm.googleapis.com/fcm/send';
 var data = {};

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

  Future<bool> send() async {
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAA3tJDHvo:APA91bEcukAYbTh0LDQJvTwkG8ZRAITQwIqal9ZFwFvLOViPXCN3Xz--kaJmzmO19O-isPxGczY65uJTxofEg9Lw6BfSP30jvbDSfDiWobhxojWLmhrp7SAMC6q-UpA1m4B_au4vXzNl'
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