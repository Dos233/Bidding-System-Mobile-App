import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageBidsPage extends StatefulWidget {
  ManageBidsPage({Key key}) : super(key: key);

  @override
  _ManageBidsPageState createState() {
    return _ManageBidsPageState();
  }
}

class _ManageBidsPageState extends State<ManageBidsPage> {
  double screenHeight, screenWidth;
  List bidsdata;
  String email;
  TextEditingController _maxBidController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPref();
    Future.delayed(Duration(milliseconds: 200), (){
      _loadData();
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
    String urlLoadJobs = "http://yuka.one/bidder/load_chart.php";
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
                  "Loading Chart",
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
                                          "    "+bidsdata[index]['MAX_BID'],
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        Text(
                                          "Max Bid: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Container(
                                          height: 15,
                                          width: screenWidth/5,
                                          child: TextField(
                                            keyboardType: TextInputType.text,
                                            controller: _maxBidController,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        MaterialButton(
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0)),
                                            minWidth: 25,
                                            height: 40,
                                            elevation: 10,
                                            child: Text('Give Up',style: TextStyle(fontSize: 11),),
                                            color: Colors.blueAccent,
                                            textColor: Colors.white,
                                            onPressed: (){
                                                String urlLoadJobs = "http://yuka.one/bidder/delete_product.php";
                                                http.post(urlLoadJobs, body: {
                                                  "name": bidsdata[index]['NAME'],
                                                  "email": email,
                                                }).then((res) {
                                                  print(res.body);
                                                  setState(() {
                                                    _loadData();
                                                  });
                                                }).catchError((err) {
                                                  print(err);
                                                });

                                            },
                                          ),
                                        ),
                                        MaterialButton(
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0)),
                                            minWidth: 25,
                                            height: 40,
                                            elevation: 10,
                                            child: Text('Update',style: TextStyle(fontSize: 11),),
                                            color: Colors.deepOrange,
                                            textColor: Colors.white,
                                            onPressed: (){
                                              String urlLoadJobs = "http://yuka.one/bidder/update_chart.php";
                                              http.post(urlLoadJobs, body: {
                                                "name": bidsdata[index]['NAME'],
                                                "email": email,
                                                "max_bid": _maxBidController.text
                                              }).then((res) {
                                                setState(() {
                                                  _loadData();
                                                });
                                                setState(() {
                                                  initState();
                                                });
                                              }).catchError((err) {
                                                print(err);
                                              });
                                            },
                                          ),
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