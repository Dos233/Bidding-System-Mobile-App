import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

import 'bidder.dart';
import 'paymentscreen.dart';

class MakePaymentPage extends StatefulWidget {
  MakePaymentPage({Key key}) : super(key: key);

  @override
  _MakePaymentPageState createState() {
    return _MakePaymentPageState();
  }
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  @override
  double screenHeight, screenWidth;
  List bidsdata;
  Bidder bidder;
  List bidderlist;
  String email;
  String urlLoadUser = "http://yuka.one/bidder/load_user.php";


  void initState() {
    super.initState();
    loadPref();
    Future.delayed(Duration(milliseconds: 200), (){
      _loadData();
      _loadUser();
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
    print("Test loadPref: "+email);
  }

  void _loadData() {
    String urlLoadJobs = "http://yuka.one/bidder/load_payment.php";
    print("Test load data: "+email);
    http.post(urlLoadJobs, body: {
      "email": email,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        bidsdata = extractdata["product"];
        bidsdata.length;
      });
    }).catchError((err) {
      print(err);
    });
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
                  "Loading Payment",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ));
    }  else{
      return Flex(
        direction: Axis.vertical,
        children: <Widget>[
          SizedBox(
            height: 1,
          ),
          Expanded(
            child: Container(
              height: screenHeight/4,
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
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
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
                                                      bottomLeft: Radius.circular(10),
                                                      topLeft: Radius.circular(10)), //单独加某一边圆角
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage("https://img.tt98.com/d/file/96kaifa/2019011800431251/5c3eddd0878df.jpg"),
                                                  )
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                            color: Colors.black, //边框颜色
                                            width: 1, //边框宽度
                                          ), // 边色与边宽度
                                          color: Colors.white, // 底色
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: NetworkImage("http://yuka.one/bidder/productimage/${bidsdata[index]['NAME']}.jpg"),
                                          )
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 8,),
                                    Text(
                                      ""+bidsdata[index]['NAME'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5,),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        Text(
                                          "Your Bid: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "    "+bidsdata[index]['MAX'],
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12,),
                                    Container(
                                      padding: EdgeInsets.only(left: 12),
                                      child: Wrap(
                                        children: <Widget>[
                                          Text(
                                            "Note: Please pay for",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            softWrap: true,
                                          ),
                                          Text(
                                            "your bids as soon !\n",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 12,top: 6),
                                      alignment: Alignment.topRight,
                                      child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0)
                                          ),
                                          minWidth: 60,
                                          height: 40,
                                          child: Text('Pay Now'),
                                          color: Colors.blue[700],
                                          textColor: Colors.white,
                                          elevation: 10,
                                          onPressed: () async {
                                            var now = new DateTime.now();
                                            var formatter = new DateFormat('ddMMyyyy-');
                                            String orderid = email.substring(1,4) +
                                                "-" +
                                                formatter.format(now) +
                                                randomAlphaNumeric(6);
                                            print(orderid);
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) => PaymentScreen(
                                                        phone: bidder.phone,
                                                        email: email,
                                                        val: bidsdata[index]['MAX'],
                                                        address: bidder.address,
                                                        orderid: orderid,
                                                        name: bidsdata[index]['NAME']
                                                    )));
                                          }
                                      ),
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