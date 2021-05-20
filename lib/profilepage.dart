import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secretgender/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'bidder.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);


  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState({Key key}) : super();
  double screenHeight,screenWidth;
  Bidder bidder;
  List bidderlist;
  TextEditingController _nameTextEditingController = new TextEditingController();
  TextEditingController _addressTextEditingController = new TextEditingController();
  TextEditingController _phoneTextEditingController = new TextEditingController();
  String _name,_address,_phone,email;
  String urlLoadUser = "http://yuka.one/bidder/load_user.php";


  @override
  void initState() {
    super.initState();
    setState(() {
      loadPref();
      Future.delayed(Duration(milliseconds:100)).then((value){
        _loadUser();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email1 = (prefs.getString('email'))??'';
    email = email1;
  }

  void _loadUser() {

    http.post(urlLoadUser, body: {
      "email": email,
    }).then((res) {
      var extractdata = json.decode(res.body);
      bidderlist = extractdata['users'];
      bidder = new Bidder(
          name:bidderlist[0]['NAME'],
          address:bidderlist[0]['ADDRESS'],
          phone:bidderlist[0]['PHONE']
      ) ;
      _name = bidder.name;
      _address = bidder.address;
      _phone = bidder.phone;
      _nameTextEditingController.text=_name;
      _addressTextEditingController.text=_address;
      _phoneTextEditingController.text=_phone;
      setState(() {

      });
    }).catchError((err) {
      print(err);
    });
  }
  void _updateProfile(){
    print("Test update: "+_nameTextEditingController.text);
    String urlLoadJobs = "http://yuka.one/bidder/update_profile.php";
    http.post(urlLoadJobs, body: {
      "name": _nameTextEditingController.text,
      "address": _addressTextEditingController.text,
      "phone": _phoneTextEditingController.text,
      "email": email,
    }).then((res) {
      if (res.body == 'success') {
        Toast.show("Update Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }else{
        Navigator.of(context).pop();
        Toast.show("Update Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;


    if (_name == null) {
      return Container(

      );
    }  else{
      return Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 70,
                      child: ClipOval(child: Image.asset('assets/images/payment.png', height: 150, width: 150, fit: BoxFit.cover,),),
                    ),
                    Positioned(bottom: 1, right: 1 ,child: Container(
                      height: 40, width: 40,
                      child: Icon(Icons.add_a_photo, color: Colors.white,),
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                    ))
                  ],
                ),
              ],
            ),
            SizedBox(height: 13,),
            Expanded(child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.black54, Color.fromRGBO(0, 41, 102, 1)]
                  )
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
                    child: Container(
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: _nameTextEditingController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(color:Colors.white),
                              decoration: InputDecoration(
                                icon: Icon(Icons.person),
                              )),
                        ),
                      ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                    child: Container(
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _addressTextEditingController,
                            style: TextStyle(color:Colors.white),
                            decoration: InputDecoration(
                              icon: Icon(Icons.gps_fixed),
                            ),
                          ),
                        ),
                      ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                    child: Container(
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: _phoneTextEditingController,
                              style: TextStyle(color:Colors.white),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                icon: Icon(Icons.phone),
                              )),
                        ),
                      ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                    ),
                  ),
                  SizedBox(height: 46,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container( height: 50, width: screenWidth/2.2,
                        child: Align(child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: screenWidth/2.2,
                            height: 50,
                            child: Text('Exit'),
                            color: Colors.blue,
                            textColor: Colors.white,
                            elevation: 10,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => new AlertDialog(
                                  title: new Text('Are you sure?'),
                                  content: new Text('Do you want to exit to Login page'),
                                  actions: <Widget>[
                                    MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>LoginScreen()));
                                        },
                                        child: Text("Exit")),
                                    MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text("Cancel")),
                                  ],
                                ),
                              ) ??
                                  false;
                            }
                        ),),
                      ),
                      SizedBox(width: 10,),
                      Container( height: 50, width: screenWidth/2.2,
                        alignment: Alignment.bottomRight,
                        child: Align(child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: 180,
                            height: 50,
                            child: Text('Save'),
                            color: Colors.deepOrange,
                            textColor: Colors.white,
                            elevation: 10,
                            onPressed: () {
                              _updateProfile();
                            }
                        ),
                        ),
                      )
                    ],
                  )

                ],
              ),
            )),
            SizedBox(height: 45,),
          ],
        ),
      );
    }

  }
}