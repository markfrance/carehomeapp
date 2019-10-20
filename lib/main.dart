import 'package:carehomeapp/authentication.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/feed_list.dart';
import 'package:carehomeapp/login_signup.dart';
import 'package:carehomeapp/root_page.dart';
import 'package:carehomeapp/yellow_drawer.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/log_check.dart';
import 'package:carehomeapp/patients_list.dart';


void main() => runApp(MyApp());

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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.primary,
        ),
      
        primarySwatch: backColor,
      ),
      home: RootPage(auth: new Auth()),
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

  final widgetOptions = [LogCheck(),FeedList(), PatientsList(), LoginSignupPage()];

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 250, 243, 242),
        endDrawer: YellowDrawer(),
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 250, 243, 242),
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black)),
            ),
            iconTheme: new IconThemeData(color: Colors.black)),
        body: Center(
          child: widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                icon: Icon(CareHomeIcons.addb,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text('')),
            BottomNavigationBarItem(
                icon: Icon(CareHomeIcons.home,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text('')),
            BottomNavigationBarItem(
                icon: Icon(CareHomeIcons.patients,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text('')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text(''))
          ],
          onTap: (index) {
            _incrementTab(index);
          },
        ));
  }
}
