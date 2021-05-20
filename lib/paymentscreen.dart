import 'dart:async';
import 'package:secretgender/mainscreen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';


class PaymentScreen extends StatefulWidget {
  String orderid, val,email,phone,name,address;
  PaymentScreen({this.phone,this.name,this.address,this.email,this.orderid, this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState(phone: phone,email: email,val: val,address: address,orderid: orderid,name: name);
}

class _PaymentScreenState extends State<PaymentScreen> {
  String orderid, val,email,phone,name,address;
  _PaymentScreenState({this.phone,this.name,this.address,this.email,this.orderid, this.val}) : super();
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.black
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Payment'),
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context)=>MainScreen())
              );
            }),

            // backgroundColor: Colors.deepOrange,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: WebView(
                  initialUrl:
                  'http://yuka.one/bidder/payment.php?email=' +
                      email +
                      '&mobile=' +
                      phone +
                      '&name=' +
                      name +
                      '&amount=' +
                      val +
                      '&orderid=' +
                      orderid,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
            ],
          )),
    );
  }
}
