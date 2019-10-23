import 'package:carehomeapp/enter_comment.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/feeditem_model.dart';

class FeedCard extends StatefulWidget {
  final FeedItem feedItem;

  FeedCard(this.feedItem);

  @override
  _FeedCardState createState() => _FeedCardState(feedItem);
}

class _FeedCardState extends State<FeedCard> {
  FeedItem feedItem;

  _FeedCardState(this.feedItem);

  IconData getIcon(CheckType type) {
    switch (type) {
      case CheckType.body:
        return CareHomeIcons.body;
      case CheckType.medication:
        return CareHomeIcons.medsicon;
      case CheckType.mood:
        return CareHomeIcons.moodicon;
      case CheckType.nutrition:
        return CareHomeIcons.nutrition;
      case CheckType.other:
        return CareHomeIcons.other;
      case CheckType.vitals:
        return CareHomeIcons.vitalsicon;
      default:
        return null;
    }
  }

  Color getColor(CheckType type) {
    switch (type) {
      case CheckType.body:
        return Color.fromARGB(255, 244, 174, 124);
      case CheckType.medication:
        return Color.fromARGB(255, 109, 191, 218);
      case CheckType.mood:
        return Color.fromARGB(255, 222, 164, 209);
      case CheckType.nutrition:
        return Color.fromARGB(255, 186, 225, 189);
      case CheckType.other:
        return Color.fromARGB(255, 204, 241, 255);
      case CheckType.vitals:
        return Color.fromARGB(255, 251, 148, 148);
      default:
        return null;
    }
  }

  String getDescription(SubType type){
    switch (type) {
      case SubType.activity:
      return "Activity";
        
        break;
      default:
    }
  }

  bool isLiked = false;
  void _toggleLikeIcon() {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: getColor(widget.feedItem.type),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 18.0,
              bottom: 18.0,
              left: 64.0,
            ),
            child: Row(children: <Widget>[
              Column(children: <Widget>[
                Text(widget.feedItem.patient.firstname + " " + widget.feedItem.patient.lastname,
                    style: Theme.of(context).textTheme.subhead),
                Text("16/10/19 00:43"),
              ]),
              Spacer(flex: 5),
              Padding(
                  child: Icon(getIcon(widget.feedItem.type)),
                  padding: EdgeInsets.all(8)),
            ]),
          ),
          Padding(
              child: Text(getDescription(widget.feedItem.subType),
                  style: Theme.of(context).textTheme.subhead),
              padding: EdgeInsets.all(8)),

             Padding(
             child:Image.asset("assets/images/placeholder.jpg",
             fit: BoxFit.fitWidth,
              ),
             padding:EdgeInsets.all(8)),
          
          
          Row(
            children: <Widget>[
              Spacer(flex: 5),
              Expanded(
                child: FlatButton(
                  child: Icon(
                    _getLikeIcon(),
                    color: Colors.black,
                  ),
                  onPressed: () => _toggleLikeIcon(),
                ),
              ),
              Expanded(
                  child: FlatButton(
                      child: Icon(CareHomeIcons.comment,
                      color:Colors.black),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EnterComment();
                          }))),
            ],
          )
        ],
      ),
    );
  }
}
