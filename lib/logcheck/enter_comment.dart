import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/model/feeditem_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnterComment extends StatefulWidget {

  FeedItem feedItem;
  EnterComment([this.feedItem]);
  
  @override
  EnterCommentState createState() => EnterCommentState();
}
class EnterCommentState extends State<EnterComment> {
  final _commentTextController = TextEditingController();

  void addNewComment() {

    final user = UserBinding.of(context).user;

    Firestore.instance.collection('feeditem')
    .document(widget.feedItem.id)
    .collection('comments').document().setData({
      'user': user.id,
      'username': user.firstName + " " + user.lastName,
      'feeditem': widget.feedItem.id,
      'time': DateTime.now(),
      'text': _commentTextController.text
    });
  }
  
  @override
  Widget build(BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(CareHomeIcons.comment),
           
              Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _commentTextController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 7,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Confirm"),
                    onPressed: () {
                      addNewComment();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
