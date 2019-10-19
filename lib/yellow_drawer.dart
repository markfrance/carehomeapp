import 'package:flutter/material.dart';

class YellowDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: Container(
            color: Color.fromARGB(255, 249, 210, 45),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "First Name",
                    textAlign: TextAlign.end,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Last Name",
                    textAlign: TextAlign.end,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Following: 3",
                    textAlign: TextAlign.end,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Score: 20",
                    textAlign: TextAlign.end,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ListTile(
                    title: Text(
                      "Settings",
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}