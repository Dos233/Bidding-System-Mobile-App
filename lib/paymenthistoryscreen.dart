import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:secretgender/mainscreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentHistoryScreen extends StatefulWidget {

  const PaymentHistoryScreen({Key key}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  _PaymentHistoryScreenState({Key key}) : super();
  List _paymentdata;
  String email;
  String titlecenter = "Loading History";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    loadPref();
    Future.delayed(Duration(milliseconds: 200), (){
      _loadPaymentHistory();
    });

  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Column(children: <Widget>[
        _paymentdata == null
            ? Flexible(
            child: Container(
                child: Center(
                    child: Text(
                      titlecenter,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ))))
            : Expanded(
            child: ListView.builder(
              //Step 6: Count the data
                itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                      child: InkWell(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
                            color: Colors.white,
                            elevation: 10,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/login.jpg"), fit: BoxFit.cover)),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        "No."+
                                            (index + 1).toString(),
                                        style:
                                        TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        "RM " +
                                            _paymentdata[index]['total'],
                                        style:
                                        TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Order Id: \n"+
                                                _paymentdata[index]['orderid'],
                                            style: TextStyle(
                                                color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                            "Bill Id: \n"+
                                                _paymentdata[index]['billid'],
                                            style: TextStyle(
                                                color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          )));
                }))
      ]),
    );
  }
  void loadPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email1 = (prefs.getString('email'))??'';
    email = email1;
    print("Test loadPref: "+email);
  }

  void _loadPaymentHistory() {
    print("Start"+email);
    String urlLoadJobs =
        "http://yuka.one/bidder/load_paymenthistory.php";
    http.post(urlLoadJobs, body: {"email": email}).then((res) {
      print(res.body);
      if (res.body.replaceAll('\n', "") == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
          print(_paymentdata);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}