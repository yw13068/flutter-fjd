import 'dart:async';
import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
class RegisterSecond extends StatefulWidget {
  final Map arguments;
  RegisterSecond({Key key,this.arguments}) : super(key: key);

  _RegisterSecondState createState() => _RegisterSecondState();
}

class _RegisterSecondState extends State<RegisterSecond> {
  String tel;
  bool secondState=false;
  int secondNum=20;
  String code;
  @override
  void initState() {
    super.initState();
    this.tel=widget.arguments['tel'];
    this._showTimer();
  }
  //倒计时
  _showTimer(){
    Timer t;
    t=Timer.periodic(Duration(milliseconds:1000 ),(timer){
      setState(() {
        this.secondNum--;
      });
      if(this.secondNum==0){
        t.cancel();
        setState(() {          
          this.secondState=true; 
        });
      }
    });
  }
  //重新发送验证码
  sendCode()async{
      setState(() {
          this.secondState=false;
          this.secondNum=20;
          this._showTimer();
      });
      var api='${Config.domain}api/sendCode';
      var result=await Dio().post(api,data:{"tel":this.tel});
      if(result.data["success"]){ 
        print(result.data);         
      }
    }
    //验证验证码
    validateCode()async{
      var api='${Config.domain}api/validateCode';
      var response=await Dio().post(api,data:{"tel":this.tel,"code":this.code});
      print(this.tel);  
      print(this.code); 
      if (response.data["success"]) {
        Navigator.pushNamed(context, '/registerthird',arguments: {
          'tel':this.tel,'code':this.code
        });
      }else{
        Fluttertoast.showToast(
          msg: '${response.data["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }

    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('用户注册-第二步'),),
      body: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(ScreenAdapter.width(20)),
                child: Text('验证码已发送到您的${this.tel}手机，请输入${this.tel}手机收到的验证码',style: TextStyle(color: Colors.black45),),
              ),
              Stack(
                children: <Widget>[
                  JdText(
                    text: "请输入验证码",
                    onChanged: (value){
                      this.code=value;
                    },
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child:this.secondState? RaisedButton(
                      onPressed: this.sendCode,
                      child: Text('重新发送'),
                      color: Colors.red,
                      textColor: Colors.white,
                    ):RaisedButton(
                      onPressed: (){},
                      child: Text('${this.secondNum}秒后重新发送'),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              JdButton(
                color: Colors.red,
                text: "下一步",
                cd:this.validateCode,
              )
            ],
          ),
        ),
    );
  }
}