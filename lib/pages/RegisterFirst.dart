import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../config/Config.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterFirst extends StatefulWidget {
  RegisterFirst({Key key}) : super(key: key);

  _RegisterFirstState createState() => _RegisterFirstState();
}

class _RegisterFirstState extends State<RegisterFirst> {
  String tel='';
  sendCode()async{
    RegExp reg=new RegExp(r'^1\d{10}$');//正则手机号验证
    if(reg.hasMatch(this.tel)){
        var api='${Config.domain}api/sendCode';
        var result=await Dio().post(api,data:{"tel":this.tel});
        if(result.data["success"]){   
          print(result.data);       
          Navigator.pushNamed(context, '/registersecond',arguments:{
            'tel':this.tel
          });
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
    }else{
      Fluttertoast.showToast(
          msg: "手机号格式错误",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('用户注册-第一步'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(ScreenAdapter.width(20)),
                child: Text('请输入手机号码获取验证码',style: TextStyle(color: Colors.black45),),
              ),
              JdText(
                text: "请输入手机号",
                onChanged: (value){
                  this.tel=value;
                },
                
              ),
              SizedBox(
                height: 10,
              ),
              JdButton(
                color: Colors.red,
                text: "下一步",
                cd: () {
                  this.sendCode();
                },
              )
            ],
          ),
        ));
  }
}
