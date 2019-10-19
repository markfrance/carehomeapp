import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/feed_list.dart';
import 'package:carehomeapp/login_signup.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: backColor,
      ),
      home: MyHomePage(title: "Hello Caretaker"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
        body: LoginSignupPage(),/*Center(
          child: widgetOptions.elementAt(_selectedIndex),
        ),*/
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
