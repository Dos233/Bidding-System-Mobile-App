import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:secretgender/productpage.dart';
import 'package:secretgender/searchscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'bidder.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key,this.bidder}) : super(key: key);
  Bidder bidder;

  @override
  _HomePageState createState() {
    return _HomePageState(bidder: bidder);
  }
}

class _HomePageState extends State<HomePage> {
  _HomePageState({Key key,this.bidder}) : super();
  Bidder bidder;
  List bidderlist;
  List bidsdata;
  Timer _timer;
  int curentTimer = 0;
  double screenHeight, screenWidth;
  String urlLoadUser = "http://yuka.one/bidder/load_user.php";
  String email;

  @override
  void initState() {
    super.initState();
    _loadData();
    loadPref();
  }

  @override
  void dispose() {
    //_timer.cancel();
    super.dispose();
  }
  void loadPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email1 = (prefs.getString('email'))??'';
    email = email1;
  }

  void _loadUser() async{
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

    }).catchError((err) {
      print(err);
    });
  }


  void _loadData() {
    String urlLoadJobs = "http://yuka.one/bidder/load_products.php";

    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        bidsdata = extractdata["product"];
        bidsdata.length;
      });

    }).catchError((err) {
      print(err);
    });
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth  = MediaQuery.of(context).size.width;

    if (bidsdata == null) {
      return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Loading Products",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ));
    } else{

      _loadUser();
      return Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            child: new Form(
              child: GestureDetector(
                onTap: (){},

                child: Container(
                    margin: EdgeInsets.only(left: 50, top: 13,right: 50,bottom: 0),
                    //设置 child 居中
                    alignment: Alignment(0, 0),
                    height: 40,
                    width: 290,
                    //边框设置
                    decoration: new BoxDecoration(
                      //背景
                      color: Colors.black12,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      //设置四周边框
                      border: new Border.all(width: 1, color: Colors.white12),
                    ),
                    child: Container(
                        margin: EdgeInsets.only(left: 2),
                        child: Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.search),
                                    color: Colors.black26,
                                    iconSize: 21,
                                    onPressed: () {
                                      //跳转搜索
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (BuildContext context)=>SearchScreen(email: email))
                                      );
                                    }
                                ),
                                Text(
                                  "Search...",
                                  style: new TextStyle(
                                    color: Colors.black26,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    )
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: Container(
              height: screenHeight/5,
              width: screenWidth,
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: bidsdata.length,
                itemBuilder: (context,index){
                  return Container(
                    height: screenHeight/3.5,
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Container(

                                  alignment: Alignment.center,
                                  decoration: new BoxDecoration(
                                      border: new Border.all(
                                        color: Colors.grey, //边框颜色
                                        width: 1, //边框宽度
                                      ), // 边色与边宽度
                                      color: Colors.white, // 底色

                                      //borderRadius: BorderRadius.circular(19), // 圆角也可控件一边圆角大小
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)), //单独加某一边圆角
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage("https://img95.699pic.com/photo/50047/8862.jpg_wh300.jpg"),
                                      )
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (BuildContext context)=>ProductPage(name: bidsdata[index]['NAME'],email: email,)
                                  ));
                                },
                                child:  Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                      Border.all(color: Colors.black),
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage("http://yuka.one/bidder/productimage/${bidsdata[index]['NAME']}.jpg")
                                      )
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 79,),
                                    Text(
                                      ""+bidsdata[index]['NAME'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                        ),

                                        Text(
                                          "Live Bid: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        Text(
                                          "    "+bidsdata[index]['REST_DATE'],
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        Text(
                                          "Initial (RM) :",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "   "+bidsdata[index]['INITIAL'],
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    decoration: new BoxDecoration(
                      border: new Border.all(
                        color: Colors.grey, //边框颜色
                        width: 1, //边框宽度
                      ), // 边色与边宽度
                      color: Colors.white, // 底色
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2, //阴影范围
                          spreadRadius: 1, //阴影浓度
                          color: Colors.grey, //阴影颜色
                        ),
                      ],
                      borderRadius: BorderRadius.circular(19), // 圆角也可控件一边圆角大小
                      //borderRadius: BorderRadius.only(
                      //  topRight: Radius.circular(10),
                      // bottomRight: Radius.circular(10)) //单独加某一边圆角
                    ),

                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10,);
                },
              ),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      );
    }
  }
}