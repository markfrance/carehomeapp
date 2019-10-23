import 'package:carehomeapp/authentication.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/feed_list.dart';
import 'package:carehomeapp/login_signup.dart';
import 'package:carehomeapp/root_page.dart';
import 'package:carehomeapp/user_binding.dart';
import 'package:carehomeapp/user_model.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/log_check.dart';
import 'package:carehomeapp/patients_list.dart';


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

class MyApp extends StatefulWidget{

@override
MyAppState createState() => MyAppState();
}


class MyAppState extends State<MyApp> {

  User user;

  @override
  void initState() {

   FirebaseAuth.instance.currentUser().then((currentuser) =>Firestore.instance.collection('users').document(currentuser.uid).get()
    .then((dbuser) =>  {
    setState(() {
      user = User(dbuser.documentID, dbuser['firstname'], dbuser['lastname'], dbuser['email']);
    })}));

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if(user == null){
      return CircularProgressIndicator();
    }
    
    return UserBinding(
      user: user,
      child: MaterialApp(
      title: 'CareHomeApp',
      theme: ThemeData(
        cursorColor: Colors.black,
         cupertinoOverrideTheme: CupertinoThemeData (
      primaryColor: Colors.black,
    ),
        scaffoldBackgroundColor:Color.fromARGB(255, 250, 243, 242) ,
        bottomAppBarColor: Color.fromARGB(255, 250, 243, 242),
        fontFamily: 'Nunito',
        accentColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border:OutlineInputBorder(borderSide: BorderSide(color: Colors.black) ),
          fillColor: Colors.white,
          filled:true),
        backgroundColor: Color.fromARGB(255, 250, 243, 242),
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromARGB(255, 249, 210, 45),
          textTheme: ButtonTextTheme.primary,
        
        ),
      
        primarySwatch: backColor,
      ),
      home: RootPage(auth: new Auth()),
    ),
    );
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

  void _incrementTab(index) {
      setState(() {
        _selectedIndex = index;
      });
  }
  
  final widgetOptions = [LogCheck(),FeedList(), PatientsList()];

  @override
  Widget build(BuildContext context) {
 final user = UserBinding.of(context).user;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 250, 243, 242),
        endDrawer: YellowDrawer(),
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 250, 243, 242),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text("Hello " + user.firstName + " " + user.lastName,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black,
                  fontWeight: FontWeight.w900)),
            ),
            iconTheme: new IconThemeData(color: Colors.black)),
        body: Center(
          child: widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 250, 243, 242),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                icon: Icon(CareHomeIcons.addb,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: Text('')),
            BottomNavigationBarItem(
                icon:  Image.asset("assets/images/home.png"),
                activeIcon:  Image.asset("assets/images/homeactive.png"),
                title: Text('')),
            BottomNavigationBarItem(
                icon:  Image.asset("assets/images/patients.png"),
                activeIcon: Image.asset("assets/images/patientsactive.png"),
                title: Text('')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: Text(''))
          ],
          onTap: (index) {
            if(index == 3)
            {
              this.widget.logoutCallback();
            }
            else {
            _incrementTab(index);
            }
          },
        )
    );
  }
}
