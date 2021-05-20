import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:secretgender/ManageBidsPage.dart';
import 'package:secretgender/feedbackpage.dart';
import 'package:secretgender/homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secretgender/makepaymentpage.dart';
import 'package:secretgender/paymenthistoryscreen.dart';
import 'package:secretgender/profilepage.dart';
import 'package:toast/toast.dart';
import 'bidder.dart';

class MainScreen extends StatefulWidget{
  MainScreen({Key key,this.bidder}) : super(key: key);
  Bidder bidder;

  @override
  _MainScreenState createState() {
    return _MainScreenState(bidder: bidder);
  }
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  _MainScreenState({Key key,this.bidder}) : super();
  PageController pageController;
  Bidder bidder;
  int _currentIndex = 0;
  double screenHeight, screenWidth;
  DateTime _lastPressedAt; //上次点击时间


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  void _changePage(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  void _pressAdd() {
    _changePage(2);
  }

  void onPageChanged(int page) {
    setState(() {
      this._currentIndex = _currentIndex;
    });
  }

  // 切换底部导航栏需要跳转的页面
  final pages = <Widget>[
    HomePage(),
    ManageBidsPage(),
    MakePaymentPage(),
    PaymentHistoryScreen(),
    ProfilePage()
  ];

// 底部导航栏要显示的所有子项
  final List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text("Home")
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.menu_rounded),
        title: Text("Manage")
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.payment),
        title: Text("Pay")
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.history),
        title: Text("History")
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text("Profile")
    ),
  ];


  @override
  Widget build(BuildContext context) {
    TextEditingController _flowerController=new TextEditingController();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.black
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("One Bid"),
              centerTitle: true,
              toolbarHeight:40,
              actions: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.message),
                    tooltip: 'Feedback',
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) => FeedbackPage()));
                    }
                ),
              ],
            ),
            body: pages[this._currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: bottomNavBarItems,
              onTap: _changePage,
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _pressAdd,
              child: Icon(
                Icons.payment,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
      );
  }
}



