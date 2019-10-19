import 'package:carehomeapp/care_home_icons_icons.dart';
import 'package:flutter/material.dart';

class BloodSugarLevelForm extends StatelessWidget {
  
 @override
  Widget build(BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color.fromARGB(255, 251, 148, 148),
                     shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    content:Column( 
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Align(child: FlatButton(
                          
                            child:  Icon(CareHomeIcons.arrowleft),
                            onPressed: () => Navigator.pop(context),
                          ),
                          alignment: Alignment.centerLeft,),
                         
                        Spacer(),
                        Padding(
                          child:Icon(CareHomeIcons.comment,),
                          padding: EdgeInsets.all(4.0)),
                        Icon(CareHomeIcons.addphoto),
                        ],
                        ), 
                      Text("Blood Sugar Level",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold),),
                    Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                            Expanded(child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                            ),
                          ),
                          flex:1,),
                          Expanded(child:Text("mmol/L"),
                            flex: 1,
                            ),
                          ],
                          ),
                       
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Save"),
                              onPressed: () {
                               
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    ],
                    ),
                  );
  }
}
