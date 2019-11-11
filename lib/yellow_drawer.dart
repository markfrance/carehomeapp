import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YellowDrawer extends StatefulWidget {

  final VoidCallback logoutCallback;
  final User user;
  YellowDrawer(this.logoutCallback, this.user);
  @override
  YellowDrawerState createState() => YellowDrawerState();
}

class YellowDrawerState extends State<YellowDrawer> {

  String currentScore;
  String followingCount;

void getCurrentScore(User user) async {
    user.getScore().then((score) => 
    setState(() {
      currentScore = score.toString();
    }));
  }

  void getFollowingCount(User user) async {
    user.getFollowingCount().then((count) =>
    setState(() =>
      followingCount = count.toString()
    ));
  }

  @override
  Widget build(BuildContext context) {


    if(currentScore == null){
      getCurrentScore(widget.user);
    }

    if(followingCount == null){
      getFollowingCount(widget.user);
    }
    return Drawer(
          child: Container(
            
            color: Color.fromARGB(255, 249, 210, 45),
            child: Column(
            
              children: <Widget>[
                Padding(
                  padding:EdgeInsets.only(top:32),
                  child:ListTile(
                  title: Text(
                    widget.user.firstName,
                    textAlign: TextAlign.end,
                  ),
                ),),
                ListTile(
                  title: Text(
                    widget.user.lastName,
                    textAlign: TextAlign.end,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Following: " + (followingCount ?? ""),
                    textAlign: TextAlign.end,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Score: " + (currentScore ?? ""),
                    textAlign: TextAlign.end,
                  ),
                ),
                 Expanded(
                   child:Align(
                     alignment: Alignment.bottomRight,
                     child:ListTile(
                    title: Text(
                      "Settings",
                      textAlign: TextAlign.end,
                    ),
                    onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => SettingsPage(widget.user)))
                ),
                 ),
                 ),
                Align(
                     alignment: Alignment.bottomRight,
                     child:ListTile(
                    title: Text(
                      "Log Out",
                      textAlign: TextAlign.end,
                    ),
                    onTap: () => {
                      FirebaseAuth.instance.signOut().then((_) => {widget.logoutCallback(),
                      Navigator.pop(context)})
                    }
                ),
                 ),
                 
              ],
            ),
          ),
        );
  }
}