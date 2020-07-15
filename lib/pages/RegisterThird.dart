import 'dart:convert';
import './tabs/Tabs.dart';
import 'package:flutter/material.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../services/Storage.dart';
class RegisterThird extends StatefulWidget {
  final Map arguments;
  RegisterThird({Key key,this.arguments}) : super(key: key);

  _RegisterThirdState createState() => _RegisterThirdState();
}

class _RegisterThirdState extends State<RegisterThird> {
  String tel;
  String code;
  String password;
  String rePassword;
  @override
  void initState() { 
    super.initState();
    this.tel=widget.arguments['tel'];
    this.code=widget.arguments['code'];
  }
  reGister() async{
      if(this.password.length<6){
        Fluttertoast.showToast(
          msg: '密码不能少于6位数',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
      if(this.password!=this.rePassword){
        Fluttertoast.showToast(
          msg: '密码和确认密码不一致',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }else{
        var api='${Config.domain}api/register';
        var response=await Dio().post(api,data:{"tel":this.tel,"code":this.code,'password':this.password});
        if(response.data['success']){
          //保存用户信息 返回到根
          Storage.setString('userInfo', json.encode(response.data['userinfo']));
          Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context)=>new Tabs()) , (route)=>route==null);
        }else{
          Fluttertoast.showToast(
            msg: '${response.data["message"]}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('用户注册-第三步'),),
      body: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              JdText(
                text: "请输入密码",
                onChanged: (value) {
                  print(value);
                  this.password=value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              JdText(
                text: "再次确认密码",
                onChanged: (value) {
                  print(value);
                  this.rePassword=value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              JdButton(
                color: Colors.red,
                text: "完成",
                cd: this.reGister
              )
            ],
          ),
        ),
    );
  }
}