import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/feeditem_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:flutter/material.dart';

class EnterComment extends StatefulWidget {

  FeedItem feedItem;
  final void Function(String value) commentCallback;
  EnterComment([this.feedItem, this.commentCallback]);
  
  @override
  EnterCommentState createState() => EnterCommentState();
}
class EnterCommentState extends State<EnterComment> {
  final _commentTextController = TextEditingController();
   
  @override
  Widget build(BuildContext context) {
    final user = UserBinding.of(context).user;

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
                      widget.feedItem == null ?
                      widget.commentCallback(_commentTextController.text) :
                      Comment.addNewComment(widget.feedItem.id,
                      user.id, 
                      user.firstName + " " + user.lastName,
                      _commentTextController.text);
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
