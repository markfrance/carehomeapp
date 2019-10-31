import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/settings_page.dart';
import 'package:flutter/material.dart';

class YellowDrawer extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    final user = UserBinding.of(context).user;
    return Drawer(
          child: Container(
            
            color: Color.fromARGB(255, 249, 210, 45),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    user.firstName,
                    textAlign: TextAlign.end,
                  ),
                ),
                ListTile(
                  title: Text(
                    user.lastName,
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
                ListTile(
                    title: Text(
                      "Settings",
                      textAlign: TextAlign.end,
                    ),
                    onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => SettingsPage()))
                ),
              ],
            ),
          ),
        );
  }
}