import 'package:flutter/material.dart';
import 'package:secretgender/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({Key key}) : super(key: key);

  @override
  _FeedbackPageState createState() {
    return _FeedbackPageState();
  }
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  TextEditingController _typeController = new TextEditingController();
  TextEditingController _describeController = new TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _sendFeedback() {
    String urlLoadJobs = "http://yuka.one/bidder/feedback.php";
    print(_typeController.text+" "+_describeController.text);
    http.post(urlLoadJobs, body: {
      "type":_typeController.text,
      "describe": _describeController.text,
    }).then((res) {
      print(res.body);
      if (res.body == 'success') {
        Toast.show("Submit success", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }  else{
        Toast.show("Submit failed", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }


  @override
  Widget build(BuildContext context) {
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
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.black,
          elevation: 2.0,
          title: Text(
            "Feedback",
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context,
                  MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
            },
            icon: Icon(Icons.arrow_back,color: Colors.white,),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 6,),
              Text(
                  "Please select the type of the feedback",
                style: TextStyle(color: Color(0xffc5c5c5),fontSize: 15),
              ),
              SizedBox(height: 10,),
              buildCheckItem("Login trouble"),
              buildCheckItem("Phone number related"),
              buildCheckItem("Other issues"),
              buildCheckItem("Suggestions"),
              SizedBox(height: 10,),
              buildFeedbackForm(),
              SizedBox(height: 10,),
              Spacer(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: (){
                        _sendFeedback();
                      },
                      color: Color(0xff2186f3),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "SUBMIT",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildFeedbackForm(){
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            height: 38,
            child: TextField(
              maxLines: 1,
              controller: _typeController,
              decoration: InputDecoration(
                hintText: "feedback type",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xffc5c5c5),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffe5e5e5)),
                ),
              ),
            ),
          ),
          SizedBox(height: 6,),
          TextField(
            maxLines: 9,
            controller: _describeController,
            decoration: InputDecoration(
              hintText: "Please briefly describe the issue",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Color(0xffc5c5c5),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffe5e5e5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildCheckItem(title){
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
        child: Row(
          children: <Widget>[
             Icon(Icons.check_circle,color: Colors.blue),
            SizedBox(height: 5,),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

          ],
        )
    );
  }
}