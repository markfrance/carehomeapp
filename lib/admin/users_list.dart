import 'package:carehomeapp/admin/user_card.dart';
import 'package:carehomeapp/admin/user_edit.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/model/user_binding.dart';
import 'package:carehomeapp/model/user_model.dart';

import 'package:flutter/material.dart';



class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  String dropdownValue = 'All Carehomes';

  Widget _buildList(BuildContext context) {
 

    return FutureBuilder<List<User>>(
        future: User.getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int) {
              return UserCard(snapshot.data[int]);
            },
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final user = UserBinding.of(context).user;

    return Column(children: <Widget>[
      Row(children: <Widget>[
          Padding(
            child:Text("Users", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            padding:EdgeInsets.all(16)),
          SizedBox(
                width:30,
                height:30,
                child: Visibility(
                    visible: user.isSuperAdmin == true || user.isManager == true,
                    child:RaisedButton(
                padding:EdgeInsets.all(0),
                color:Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return UserEdit(null);
            },
                ),
                child:Icon(CareHomeIcons.addb,),
              ),),)

        ],
        ),
      Row(children: <Widget>[
        
        Expanded(
            flex: 2,
            child: Align(
                alignment: Alignment.topLeft,
                child: Theme(
                  data: ThemeData(
                    canvasColor: Color.fromARGB(255, 249, 210, 45),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, top: 16, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 249, 210, 45),
                          borderRadius: BorderRadius.circular(8)),
                      child: Visibility(
                        visible: user.isSuperAdmin == true,
                        child:DropdownButton<String>(
                        value: dropdownValue,
                        hint:Text(dropdownValue),
                      //  icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, backgroundColor: Color.fromARGB(255, 249, 210, 45)),
                         underline: null,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          'All Carehomes',
                          'Alphabetically'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              color: Color.fromARGB(255, 249, 210, 45),
                              child: Padding(padding:EdgeInsets.only(left: 8), child:Text(value)),
                            ),
                          );
                        }).toList(),
                      ),),
                    ),
                  ),
                )))
      ]),
      Expanded(child: _buildList(context), flex: 1)
    ]);
  }
}
