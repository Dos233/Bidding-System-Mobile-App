import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:secretgender/mainscreen.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key key,this.name,this.email}) : super(key: key);
  String name,email;
  @override
  _ProductPageState createState() {
    return _ProductPageState(name: name,email: email);
  }
}

class _ProductPageState extends State<ProductPage> {
  _ProductPageState({Key key,this.name,this.email}) : super();
  String name,email;
  double screenHeight, screenWidth;
  TextEditingController _initialBidController = new TextEditingController();
  List bidsdata;
  Timer _timer;
  int curentTimer = 0;
  int productPosition = 0;

  @override
  void initState() {
    super.initState();
    _loadData();

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }



  void _loadData() {
    String urlLoadJobs = "http://yuka.one/bidder/load_products.php";

    http.post(urlLoadJobs, body: {
      "name": name,
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

  void _addChart(){
    String urlAddChart = "http://yuka.one/bidder/add_product.php";

    for(int i=0;i<bidsdata.length;i++){
      if(bidsdata[i]['NAME'] == name){
        productPosition = i;
      }
    }
    if (int.parse(_initialBidController.text) > int.parse(bidsdata[productPosition]['INITIAL'])) {
      http.post(urlAddChart, body: {
        "name": name,
        "email": email,
        "max_bid": _initialBidController.text
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          Toast.show("Add Success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }else{
          Navigator.of(context).pop();
          Toast.show("Add Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }

      }).catchError((err) {
        print(err);
      });
    }else{
      Toast.show("Must be greater than the initial value", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth  = MediaQuery.of(context).size.width;

    if (bidsdata == null) {
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context)=>MainScreen())
                );
              },
            ),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.message),
                  tooltip: 'Feedback',
                  onPressed: () {}
              ),
            ],
          ),
          body: Center(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      widthFactor: screenWidth/1.3,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Loading Products...",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "If keep loading, \nit means that there is no such product",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              )
          ),
        ),
      );
    } else{
      /*String _text=bidsdata[0]['REST_DATE'];
      int seconds = 0;
      Timer.periodic(Duration(seconds: 1), (timer) {
        if(_text=='00:00:00'){
          timer.cancel(); // 取消重复计时
        }
        _textkey.currentState.setState(() {
          _text = seconds.toString();
        });
        seconds++;// 秒数+1
      });*/
      /*int seconds = 0;
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        if (curentTimer==60) {
          timer.cancel();
        }
        setState(() {
          _loadData();
        });
        curentTimer++;
      });*/

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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context)=>MainScreen())
                );
              },
            ),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.message),
                  tooltip: 'Feedback',
                  onPressed: () {}
              ),
            ],
          ),
          body: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: screenHeight/5,
                  width: screenWidth,
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 5),
                    itemCount: 1,
                    itemBuilder: (context,index){
                      return Container(
                        height: screenHeight/1.22,
                        alignment: Alignment.center,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: Row(
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
                                              bottomLeft: Radius.circular(10),
                                              topLeft: Radius.circular(10)), //单独加某一边圆角
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage("https://img95.699pic.com/photo/50047/8862.jpg_wh300.jpg"),
                                          )
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
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
                                  child: Container(
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
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(right: 12,top: 12),
                                          alignment: Alignment.topRight,
                                          child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0)
                                              ),
                                              minWidth: 70,
                                              height: 48,
                                              child: Text('Make a Bid'),
                                              color: Colors.blue[700],
                                              textColor: Colors.white,
                                              elevation: 10,
                                              onPressed: () {
                                                if (bidsdata[productPosition]['REST_DATE'].compareTo('00:00:00') == -1) {
                                                  Toast.show("Live bid has ended, the product cannot be added !", context,
                                                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                }  else{
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return RenameDialog(
                                                          contentWidget: RenameDialogContent(
                                                            title: "Enter Initial Bid (RM)",
                                                            okBtnTap: () {
                                                              _addChart();
                                                            },
                                                            vc: _initialBidController,
                                                            cancelBtnTap: () {},
                                                          ),
                                                        );
                                                      });
                                                }
                                              }
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          ""+bidsdata[productPosition]['NAME'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 10,),
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
                                              "    "+bidsdata[productPosition]['REST_DATE'],
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
                                              "   "+bidsdata[productPosition]['INITIAL'],
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Description: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                bidsdata[productPosition]['DESCRIPTION'],
                                                maxLines: 14,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                          height: screenWidth/1.2,
                                          padding: EdgeInsets.only(left: 5),
                                        )
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
          ),
        ),
      );
    }
  }
}

class RenameDialog extends AlertDialog {
  RenameDialog({Widget contentWidget})
      : super(
    content: contentWidget,
    contentPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blue, width: 3)),
  );
}
double btnHeight = 60;
double borderWidth = 1;

class RenameDialogContent extends StatefulWidget {
  String title;
  String cancelBtnTitle;
  String okBtnTitle;
  VoidCallback cancelBtnTap;
  VoidCallback okBtnTap;
  TextEditingController vc;
  RenameDialogContent(
      {@required this.title,
        this.cancelBtnTitle = "Cancel",
        this.okBtnTitle = "Ok",
        this.cancelBtnTap,
        this.okBtnTap,
        this.vc});

  @override
  _RenameDialogContentState createState() =>
      _RenameDialogContentState();
}

class _RenameDialogContentState extends State<RenameDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        height: 200,
        width: 10000,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: TextStyle(color: Colors.grey),
                )),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                style: TextStyle(color: Colors.black87),
                controller: widget.vc,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    )),
              ),
            ),
            Container(
              // color: Colors.red,
              height: btnHeight,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                children: [
                  Container(
                    // 按钮上面的横线
                    width: double.infinity,
                    color: Colors.blue,
                    height: borderWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        onPressed: () {
                          widget.vc.text = "";
                          widget.cancelBtnTap();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style: TextStyle(fontSize: 22, color: Colors.blue),
                        ),
                      ),
                      Container(
                        // 按钮中间的竖线
                        width: borderWidth,
                        color: Colors.blue,
                        height: btnHeight - borderWidth - borderWidth,
                      ),
                      FlatButton(
                          onPressed: () {
                            widget.okBtnTap();
                            Navigator.of(context).pop();
                            widget.vc.text = "";
                          },
                          child: Text(
                            widget.okBtnTitle,
                            style: TextStyle(fontSize: 22, color: Colors.blue),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}