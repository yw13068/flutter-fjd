import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fjd/services/EventBus.dart';
import 'package:flutter_fjd/widget/JdText.dart';
import '../services/ScreenAdapter.dart';
import '../widget/JdButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/Storage.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../services/EventBus.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //监听登录页面销毁的事件
  dispose(){
    super.dispose();
    eventBus.fire(new UserBus('登录成功...'));
  }
  String tel='';
  String password='';
  _signLogin() async{
     RegExp reg=new RegExp(r'^1\d{10}$');//正则手机号验证
     if(!reg.hasMatch(this.tel)){
        Fluttertoast.showToast(
          msg: "手机号格式不正确",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
        );
     }else if(this.password.length<6){
       Fluttertoast.showToast(
          msg: "密码格式不正确",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
     }else{
        var api='${Config.domain}api/doLogin';
        var result=await Dio().post(api,data:{"tel":this.tel,'password':this.password});
        if(result.data["success"]){ 
          print(result);
          //保存密码
          Storage.setString('userInfo', json.encode(result.data[0]['userinfo'])); 
          Navigator.pop(context);     
        }else{
          Fluttertoast.showToast(
              msg: "${result.data["message"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
     }
       
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {},
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(ScreenAdapter.width(10)),
                alignment:Alignment.center ,
                child: Text("客服",style: TextStyle(fontSize: ScreenAdapter.size(28)),),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child:ListView(
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
                  width: ScreenAdapter.width(160),
                  height: ScreenAdapter.width(160),
                  child: Image.network(
                    'https://www.itying.com/images/flutter/list5.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              JdText(
                text: "请输入用户名",
                onChanged: (value) {
                  this.tel=value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              JdText(
                text: "请输入密码",
                password: true,
                onChanged: (value) {
                  this.password=value;
                },
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text("首页",style: TextStyle(fontSize: ScreenAdapter.size(28)),),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/registerfirst');
                        },
                        child: Text("新用户注册",style: TextStyle(fontSize: ScreenAdapter.size(28))),
                      ),
                    )
                  ],
                ),
              ),
              JdButton(
                color: Colors.red,
                text: "登录",
                height: 84,
                cd: this._signLogin,
              )
            ],
          ),
        ));
  }
}
