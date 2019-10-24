import 'package:flutter/material.dart';

class PopupMessage extends StatefulWidget {
  final String message;
  PopupMessage(this.message);

  @override
  PopupMessageState createState() => PopupMessageState();
}

class PopupMessageState extends State<PopupMessage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Color.fromARGB(255, 250, 243, 242),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.message),
            RaisedButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ));
  }
}
