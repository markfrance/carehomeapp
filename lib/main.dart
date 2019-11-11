import 'dart:io';

import 'package:carehomeapp/admin/users_list.dart';
import 'package:carehomeapp/authentication.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/feed/feed_list.dart';
import 'package:carehomeapp/model/carehome_model.dart';
import 'package:carehomeapp/model/push_message.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:carehomeapp/root_page.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/logcheck/log_check.dart';
import 'package:carehomeapp/patient/patients_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main() {
  runApp(MyApp());
}

const MaterialColor backColor = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFfaf3f2),
    100: const Color(0xFFfaf3f2),
    200: const Color(0xFFfaf3f2),
    300: const Color(0xFFfaf3f2),
    400: const Color(0xFFfaf3f2),
    500: const Color(0xFFfaf3f2),
    600: const Color(0xFFfaf3f2),
    700: const Color(0xFFfaf3f2),
    800: const Color(0xFFfaf3f2),
    900: const Color(0xFFfaf3f2),
  },
);

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  User user;

  Widget materialApp() {
    return MaterialApp(
            title: 'CareHomeApp',
            theme: ThemeData(
              cursorColor: Colors.black,
              cupertinoOverrideTheme: CupertinoThemeData(
                primaryColor: Colors.black,
              ),
              scaffoldBackgroundColor: Color.fromARGB(255, 250, 243, 242),
              bottomAppBarColor: Color.fromARGB(255, 250, 243, 242),
              fontFamily: 'Nunito',
              accentColor: Colors.white,
              inputDecorationTheme: InputDecorationTheme(
                  contentPadding: EdgeInsets.all(8),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                  fillColor: Colors.white,
                  filled: true),
              backgroundColor: Color.fromARGB(255, 250, 243, 242),
              buttonTheme: ButtonThemeData(
                buttonColor: Color.fromARGB(255, 249, 210, 45),
                textTheme: ButtonTextTheme.primary,
              ),
              primarySwatch: backColor,
            ),
            home: RootPage(auth: new Auth()));
  }
  @override
  Widget build(BuildContext context) {

   if(user == null){
     return materialApp();
   }
   return UserBinding(child: materialApp(),
   user: user);
      
  }
    

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  int currentScore = 0;
  User user;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<PushMessage> messages = [];
  

 /*static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
   if (message.containsKey('data')) {
     // Handle data message
     final dynamic data = message['data'];
   }

   if (message.containsKey('notification')) {
     // Handle notification message
     final dynamic notification = message['notification'];
   }

   // Or do other work.
 }
 */

void setUser() {
   user = null;
    FirebaseAuth.instance.currentUser().then((currentuser) => Firestore.instance
        .collection('users')
        .document(currentuser.uid)
        .get()
        .then((dbuser) => {
              setState(() {
                user = User(
                    dbuser.documentID,
                    dbuser['firstname'],
                    dbuser['lastname'],
                    dbuser['email'],
                    dbuser['ismanager'],
                    dbuser['issuperadmin'],
                    Carehome(dbuser['carehome'], dbuser['carehomename']));
              })
            }));
}
  @override
  void initState()  {
    super.initState();

    setUser();

Future.delayed(Duration(seconds: 1), () {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
    
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(message['notification']['body'])));
            

            print("onMessage: $message");
     /*     showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
            );*/
  
    }, // onBackgroundMessage: myBackgroundMessageHandler,
    onResume: (Map<String, dynamic> message) async {
      print("onResume:  $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch:  $message");
    });
});
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _saveDeviceToken().then((result) {
      print("result: $result");
    });
  
  }

  _saveDeviceToken() async {
    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();

    String fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      var tokens = Firestore.instance
          .collection('users')
          .document(fbUser.uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  void getCurrentScore(User user) {
    user.getScore().then((score) => setState(() {
          currentScore = score;
        }));
  }

  void _incrementTab(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 
  @override
  Widget build(BuildContext context) {
    
    if(user == null){
      return CircularProgressIndicator();
    }
    if(currentScore == null){
      getCurrentScore(user);
    }
    final widgetOptions = [LogCheck(user), FeedList(user), PatientsList(user), UsersList(user)];
    return UserBinding(
      user: user,
      child:Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromARGB(255, 250, 243, 242),
        endDrawer: YellowDrawer(widget.logoutCallback, user),
        appBar: AppBar(
            leading: Image.asset(
              "assets/images/icons/PNG/main.png",
              width: 40,
              height: 40,
            ),
            backgroundColor: Color.fromARGB(255, 250, 243, 242),
            title: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Hello " + user?.firstName + " " + user?.lastName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900)),
                ),
                Spacer(),
                ClipOval(
                  child: Container(
                    color: Color.fromARGB(255, 249, 210, 45),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(currentScore.toString())),
                  ),
                ),
              ],
            ),
            iconTheme: new IconThemeData(color: Colors.black)),
        body: Center(
          child: widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(CareHomeIcons.addb,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: Text('')),
            BottomNavigationBarItem(
                icon: Image.asset("assets/images/home.png"),
                activeIcon: Image.asset("assets/images/homeactive.png"),
                title: Text('')),
            BottomNavigationBarItem(
                icon: Image.asset("assets/images/patients.png"),
                activeIcon: Image.asset("assets/images/patientsactive.png"),
                title: Text('')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: Text(''))
          ],
          onTap: (index) {
            _incrementTab(index);
          },
        )));
  }
}
