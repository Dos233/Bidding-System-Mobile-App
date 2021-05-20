import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secretgender/mainscreen.dart';
import 'package:secretgender/registerscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'bidder.dart';
import 'homepage.dart';

main()=>runApp(LoginScreen());

bool rememberMe = false;


class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  double screenHeight;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _forgotEmailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  String urlLogin = "http://yuka.one/bidder/login_user.php";
  String urlLoadUser = "http://yuka.one/bidder/load_user.php";
  Bidder bidder;
  List bidderlist;
  List bidsdata;

  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    loadPref();
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 340,
      margin: EdgeInsets.only(top: screenHeight / 3),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextField(
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      )),
                  TextField(
                    controller: _passEditingController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool value) {
                          _onRememberMeChanged(value);
                        },
                      ),
                      Text('Remember Me ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 80,
                        height: 50,
                        child: Text('Login'),
                        color: Colors.brown,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () {
                          _loadUser();
                          _loginUser();
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an account? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _registerUser,
                child: Text(
                  "Create Account",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Forgot Password? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _forgotPassword,
                child: Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      //color: Color.fromRGBO(255, 200, 200, 200),
      margin: EdgeInsets.only(top: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.home,
            size: 40,
            color: Colors.white,
          ),
          Text(
            "MY.BID",
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }



  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }
  void _loginUser(){
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    http.post(urlLogin, body: {
      "email": email,
      "password": password,
    }).then((res) {
      print(res.body);
      savepref(true);
      if (res.body.replaceAll('\n', "") == "success") {
        Toast.show("Login success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context)=>MainScreen(bidder: bidder,))
        );
      }else{
        Toast.show("Login failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _sendRecoveryEmail(){
    String email2 = _forgotEmailEditingController.text;
    http.post("http://yuka.one/bidder/forgot_password.php", body: {
      "email": email2,
    }).then((res) {
      print(email2);
      print(res.body);
      if (res.body.replaceAll(" ", "").replaceAll("\n", "") == "success") {
        Toast.show("Recovery email has been sent to you !", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      }else{
        Toast.show("Please enter the valid email !", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }
  void _forgotPassword() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your recovery email.",
                ),
                TextField(
                  controller: _forgotEmailEditingController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Submit"),
              onPressed: () {
                _sendRecoveryEmail();
              },
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;
    print(rememberMe);
    if (rememberMe) {
      savepref(true);
    } else {
      savepref(false);
    }
  });

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
  void _loadUser(){

    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    http.post(urlLoadUser, body: {
      "email": email,
    }).then((res) {
      print(res.body);
      var extractdata = json.decode(res.body);
      bidderlist = extractdata['users'];
      bidder = new Bidder(
          name:bidderlist[0]['NAME'],
          address:bidderlist[0]['ADDRESS'],
          phone:bidderlist[0]['PHONE']
      ) ;

      print(bidder.phone);
    }).catchError((err) {
      print(err);
    });
  }


  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email'))??'';
    String password = (prefs.getString('pass'))??'';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
