import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:carehomeapp/log_check.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
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

class HomeFeed extends StatefulWidget {

  @override
  _HomeFeedState createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {

 String dropdownValue = 'Most recent';

  @override
  Widget build(BuildContext context) {
  
    return 
    Column(
          children:<Widget>[
            Align(
      alignment: Alignment.topLeft,
      child: DropdownButton<String>(
        
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          color: Colors.black
        ),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['Most recent', 'Check type', 'Patients']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              
              value: value,
              child: Container(
                color: Color.fromARGB(255, 250, 243, 242),
                child:Text(value),
              ),
            );
          })
          .toList(),
      ),
      ),
      Text(
        "test"
      ),
      Text("LIST GOES HERE")
     ]
    );
  }
}


class _MyHomePageState extends State<MyHomePage> {
  
    int _selectedIndex = 0;

  void _incrementTab(index) {
    if(_selectedIndex < 3){
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final widgetOptions = [
    HomeFeed(),
    LogCheck(),
    Text('Patients')
  ];

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
      endDrawer:Drawer(
        child:Container(
          color: Color.fromARGB(255, 249, 210, 45),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("First Name", textAlign: TextAlign.end,),
            ),
            ListTile(
              title: Text("Last Name", textAlign: TextAlign.end,),
            ),
            ListTile(
              title: Text("Following: 3",  textAlign: TextAlign.end,),
            ),
            ListTile(
              title: Text("Score: 20", textAlign: TextAlign.end,),
            ),
            Align( 
              alignment: Alignment.bottomLeft,
              child:ListTile( 
              title: Text("Settings", textAlign: TextAlign.end, ),
            ),
            ),
          ],
        ),
        ),
      ),
     
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 250, 243, 242),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Align(
          alignment: Alignment.centerLeft,
          child:Text(widget.title, textAlign: TextAlign.start, style: TextStyle(color: Colors.black)),
        ),
        iconTheme: new IconThemeData(color:Colors.black)
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
        
      bottomNavigationBar:BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.shifting ,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CareHomeIcons.addb,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('')
            
          ),
          BottomNavigationBarItem(
            icon: Icon(CareHomeIcons.home,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('')
          ),
          BottomNavigationBarItem(
            icon: Icon(CareHomeIcons.patients, color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('')
          )
        ],
        onTap: (index){
            _incrementTab(index);
        },
      ) 
    );
  }
}
