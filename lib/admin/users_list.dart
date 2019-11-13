import 'package:carehomeapp/admin/add_carehome.dart';
import 'package:carehomeapp/admin/user_card.dart';
import 'package:carehomeapp/admin/user_edit.dart';
import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:carehomeapp/model/carehome_model.dart';
import 'package:carehomeapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  final User user;
  UsersList(this.user);
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  Carehome dropdownValue;

  Widget _buildList(BuildContext context) {
    return FutureBuilder<List<User>>(
        future: User.getUsers(dropdownValue, widget.user),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int) {
              return UserCard(snapshot.data[int], widget.user);
            },
          );
        });
  }

  Future<List<Carehome>> getCarehomes() async {
    List<Carehome> carehomes = new List<Carehome>();

    QuerySnapshot snapshot =
        await Firestore.instance.collection('carehome').getDocuments();

    carehomes.add(Carehome('0', 'All Carehomes'));
    snapshot.documents.forEach(
        (data) => carehomes.add(Carehome(data.documentID, data['name'])));
    return carehomes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Padding(
              child: Text(
                "Users",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.all(16)),
          SizedBox(
            width: 30,
            height: 30,
            child: Visibility(
              visible: widget.user.isSuperAdmin == true ||
                  widget.user.isManager == true,
              child: RaisedButton(
                padding: EdgeInsets.all(0),
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UserEdit(null, widget.user);
                  },
                ),
                child: Icon(
                  CareHomeIcons.addb,
                ),
              ),
            ),
          )
        ],
      ),
      Row(children: <Widget>[
        Expanded(
            flex: 1,
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
                        visible: widget.user.isSuperAdmin == true,
                        child: FutureBuilder<List<Carehome>>(
                            future: getCarehomes(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Carehome>> snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              return DropdownButton<Carehome>(
                                  hint: dropdownValue == null
                                      ? Padding(
                                          child: Text("All Carehomes"),
                                          padding: EdgeInsets.only(left: 8))
                                      : Padding(
                                          child: Text(dropdownValue.name),
                                          padding: EdgeInsets.only(left: 8)),
                                  isExpanded: true,
                                  value: null,
                                  items: snapshot.data
                                      .map((carehome) =>
                                          DropdownMenuItem<Carehome>(
                                            child: Container(
                                              child: Text(carehome.name),
                                              color: Color.fromARGB(
                                                  255, 249, 210, 45),
                                            ),
                                            value: carehome,
                                          ))
                                      .toList(),
                                  onChanged: (Carehome newValue) {
                                    setState(() {
                                      dropdownValue = newValue;

                                      print(newValue.id);
                                    });
                                  });
                            }),
                      ),
                    ),
                  ),
                ))),
               
             Expanded(child:  
             Padding(padding: EdgeInsets.only(left:8, right:8),
             child:
           Visibility(
             visible: widget.user.isSuperAdmin,
             child:RaisedButton(
              child: Text('Add Carehome'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCarehome())))),
              )),
                      
      ]),
     
      Expanded(child: _buildList(context), flex: 1)
    ]);
  }
}
