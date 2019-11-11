import 'package:cached_network_image/cached_network_image.dart';
import 'package:carehomeapp/feed/comment_card.dart';
import 'package:carehomeapp/feed/image_view.dart';
import 'package:carehomeapp/logcheck/enter_comment.dart';
import 'package:carehomeapp/model/comment_model.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/model/feeditem_model.dart';

class FeedCard extends StatefulWidget {
  final FeedItem feedItem;
  final User user;

  FeedCard(this.feedItem, this.user);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool showComments = false;
  List<Comment> itemComments = new List<Comment>();
  bool isLiked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setLiked();
  }

  IconData getIcon(String type) {
    switch (type) {
      case "body":
        return CareHomeIcons.bodydark;
      case "medication":
        return CareHomeIcons.medsicon;
      case "mood":
        return CareHomeIcons.moodicon;
      case "nutrition":
        return CareHomeIcons.nutrition;
      case "other":
        return CareHomeIcons.other;
      case "vitals":
        return CareHomeIcons.vitalsicon;
      case "task":
        return Icons.check_circle_outline;
      default:
        return null;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case "body":
        return Color.fromARGB(255, 244, 174, 124);
      case "medication":
        return Color.fromARGB(255, 109, 191, 218);
      case "mood":
        return Color.fromARGB(255, 222, 164, 209);
      case "nutrition":
        return Color.fromARGB(255, 186, 225, 189);
      case "other":
        return Color.fromARGB(255, 204, 241, 255);
      case "vitals":
        return Color.fromARGB(255, 251, 148, 148);
      default:
        return Colors.white;
    }
  }

  void _setLiked() {
 
    Firestore.instance
        .collection('feeditem')
        .document(widget.feedItem.id)
        .get()
        .then((data) => 
            setState(() => isLiked =
                 data['likes'] != null ? (List.from(data['likes'])?.contains(widget.user.id) ?? false) : false)
                
            );
  }

  void sendLikeNotification() {
  
       Firestore.instance
                  .collection('users')
                  .document(widget.feedItem.user)
                  .get()
                  .then((dbuser) => dbuser['notificationlikes'] == true
                      ? 
                        Firestore.instance.collection('users')
                        .document(dbuser.documentID)
                        .collection('tokens').getDocuments().then((snap)
                      => 
                        snap.documents.forEach((doc) => PushNotification(
                          'Like notification',
                          '${widget.user.firstName} ${widget.user.lastName} liked your post',
                          doc['token']).send().then((sent) => print('sent like notification')
                          )
                          ))
                      : null);
  }

  void _toggleLikeIcon() {
 

    if (isLiked) {
      Firestore.instance
          .collection('feeditem')
          .document(widget.feedItem.id)
          .updateData({
        'likes': FieldValue.arrayRemove([widget.user.id])
      });
    
    } else {
      Firestore.instance
          .collection('feeditem')
          .document(widget.feedItem.id)
          .updateData({
        'likes': FieldValue.arrayUnion([widget.user.id])
      });
        sendLikeNotification();
    }
    setState(() {
      isLiked = !isLiked;
    });
  }

  IconData _getLikeIcon() {
    if (isLiked == true) {
      return CareHomeIcons.likeactive;
    } else {
      return CareHomeIcons.likeinactive;
    }
  }

  String formatTime(DateTime time) {
    if(time == null){
      return "";
    }
    return time.year.toString() +
        "/" +
        time.month.toString().padLeft(2, '0') +
        "/" +
        time.day.toString().padLeft(2, '0') +
        " " +
        time.hour.toString().padLeft(2, '0') +
        ":" +
        time.minute.toString().padLeft(2, '0');
  }

  Future<List<Comment>> getComments() async {
    itemComments.clear();
    QuerySnapshot snapshot;

    snapshot = await Firestore.instance
        .collection('feeditem')
        .document(widget.feedItem.id)
        .collection('comments')
        .orderBy('time', descending: true)
        .getDocuments();

    snapshot.documents.forEach((data) => itemComments.add(Comment(
        data['username'],
        data['user'],
        data["feeditem"],
        data["time"].toDate(),
        data["text"])));

    return itemComments;
  }

  Widget _buildCommentList(BuildContext context) {
    return FutureBuilder(
        future: getComments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: itemComments.length,
              itemBuilder: (context, int) {
                return CommentCard(itemComments[int]);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
        Widget>[
      Card(
        elevation: 4,
        margin: EdgeInsets.only(left: 25, right: 25, top: 16.0, bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: getColor(widget.feedItem.type),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 18.0,
                  bottom: 18.0,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                                imageUrl: widget.feedItem.patientImage ??
                                    "https://firebasestorage.googleapis.com/v0/b/carehomeapp-a2936.appspot.com/o/avatar_placeholder_small.png?alt=media&token=32adc9ac-03ad-45ed-bd4c-27ecc4f80a55",
                                placeholder: (context, url) => Image.asset(
                                    "assets/images/avatar_placeholder_small.png",
                                    width: 50,
                                    height: 50),
                                width: 50,
                                height: 50),
                          )),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.feedItem.patientname ?? " ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(formatTime(widget.feedItem.timeAdded)),
                            Text("carer: " + (widget.feedItem.username ?? ""))
                          ]),
                      Spacer(flex: 5),
                      Expanded(
                        flex: 3,
                        child: Padding(
                            child: Icon(getIcon(widget.feedItem.type)),
                            padding: EdgeInsets.all(8)),
                      ),
                    ]),
              ),
              Padding(
                  child: Text(widget.feedItem.logdescription ?? " ",
                      style: Theme.of(context).textTheme.subhead),
                  padding: EdgeInsets.all(8)),
              Visibility(
                visible: widget.feedItem.imageUrl != null,
                child: Padding(
                    child: GestureDetector(
                        child: CachedNetworkImage(
                          height: 150,
                          width: 320,
                          fit:BoxFit.fitWidth,
                          imageUrl: widget.feedItem.imageUrl ??
                              "https://firebasestorage.googleapis.com/v0/b/carehomeapp-a2936.appspot.com/o/avatar_placeholder_small.png?alt=media&token=32adc9ac-03ad-45ed-bd4c-27ecc4f80a55",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return ImageView(widget.feedItem.imageUrl);
                          }));
                        }),
                    padding: EdgeInsets.all(8)),
              ),
              Row(
                children: <Widget>[
                  Spacer(flex: 7),
                  Expanded(
                    flex: 2,
                    child: FlatButton(
                      child: Icon(
                        _getLikeIcon(),
                        color: Colors.black,
                      ),
                      onPressed: () => _toggleLikeIcon(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: FlatButton(
                          child: Icon(
                              showComments
                                  ? CareHomeIcons.commentactive
                                  : CareHomeIcons.comment,
                              color: Colors.black),
                          onPressed: () => setState(() {
                                showComments = !showComments;
                              })),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      Visibility(
        visible: showComments,
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EnterComment(widget.user, widget.feedItem);
                  }),
            ),
          ),
          Column(children: <Widget>[
            _buildCommentList(context),
          ]),
        ]),
      ),
    ]);
  }
}
