import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/settings_page.dart';
import 'package:flutter/material.dart';

class YellowDrawer extends StatefulWidget {

  final VoidCallback logoutCallback;
  YellowDrawer(this.logoutCallback);
  @override
  YellowDrawerState createState() => YellowDrawerState();
}

class YellowDrawerState extends State<YellowDrawer> {


  String currentScore;
  String followingCount;
  User user;


void getCurrentScore(User user) async {
    user.getScore().then((score) => 
    setState(() {
      currentScore = score.toString();
    }));
  }

  void getFollowingCount(User user) async {
    user.getFollowing().then((count) =>
    setState(() =>
      followingCount = count.toString()
    ));
  }

  @override
  Widget build(BuildContext context) {

    if (user == null) {
      user = UserBinding.of(context).user;
    }

    if(currentScore == null){
      getCurrentScore(user);
    }

    if(followingCount == null){
      getFollowingCount(user);
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
                    user.firstName,
                    textAlign: TextAlign.end,
                  ),
                ),),
                ListTile(
                  title: Text(
                    user.lastName,
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
                    onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => SettingsPage()))
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
                    onTap: () => widget.logoutCallback()
                ),
                 ),
                 
              ],
            ),
          ),
        );
  }
}