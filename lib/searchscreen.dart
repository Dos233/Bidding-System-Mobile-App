import 'package:flutter/material.dart';
import 'dart:async';

import 'package:secretgender/productpage.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key,this.email}) : super(key: key);
  @override
  SearchPageState createState() => new SearchPageState(email: email);
  String email;
}

class SearchPageState extends State<SearchScreen>{

  String email;
  static final TextEditingController controller = new TextEditingController();

  ///搜索页form文字
  static String searchStr = "";

  SearchPageState({Key key,this.email}) {
    ///监听搜索页form
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          searchStr = "";
          //默认显示
          centerContent = defaultDisplay();
          //显示历史记录
        });
      } else {
        setState(() {
          searchStr = "";
          //默认显示
          centerContent = defaultDisplay();
          //显示历史记录
        });
      }
    });
  }

  ///建议
  static List<String> recommend = ['Phone', 'Painting', 'Football', 'Laptop', 'iphone', 'basketball', 'watch', 'Ring',];
  ///历史 暂时使用本地默认数据
  static List<String> history = ['IPhone 7','Painting','Laptop'];

  ///中间内容
  Widget centerContent = defaultDisplay();

  ///默认显示(推荐 + 历史记录)
  static Widget defaultDisplay(){
    return Container(
      padding: const EdgeInsets.only(
        left: 25,
        bottom: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Text(
            "History Record：",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 5.0),
          Wrap(
            spacing: 10,
            children: defaultData(history),
          ),
          SizedBox(height: 10.0),
          Text(
            "Recommend：",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 5.0),
          Wrap(
            spacing: 10,
            children: defaultData(recommend),
          ),
        ],
      ),
    );
  }
  void _searchProduct(){
    String name = controller.text;
    Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context)=>ProductPage(email: email,name: name,))
    );
  }

  ///默认显示内容
  static List<Widget> defaultData(List<String> items){
    return items.map((item) {
      return InkWell(
        child: Chip(
            label: Text(item),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
        ),
        onTap: () {
          //更新到搜索框
          controller.text = item;
        },
      );
    }).toList();
  }

  ///实时搜索结果
  static List list  = new List();
  ///实时搜索url
  String realTimeSearchUrl = "http://192.168.0.121:8091/article/test/";
  ///参数
  String paramStr = "qwe";



  @override
  Widget build(BuildContext context) {
    //屏幕宽度
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      //iconSize: 30,
                      iconSize: width * 1/12,
                      icon: Icon(Icons.arrow_back),
                      onPressed: (){
                        //回到原来页面
                        controller.clear();
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      //设置 child 居中
                      //alignment: Alignment(0, 0),
                      height: width * 1/9,
                      width: 240,
                      //边框设置
                      decoration: new BoxDecoration(
                        //背景
                        color: Colors.black12,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        //设置四周边框
                        border: new Border.all(width: 1, color: Colors.white12),
                      ),
                      child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 3,left:12),
                              border: InputBorder.none,
                              hintText: '   Enter search content...',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize:17,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: (){
                                  _searchProduct();
                                },
                              )
                            ),

                          ),
                    ),
                    //清空按钮
                    IconButton(
                        iconSize: 25,
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            controller.text = "";
                          });
                        }
                    )
                  ],
                ),
                centerContent,
              ],
            ),
          ),
        )
    );
  }

}