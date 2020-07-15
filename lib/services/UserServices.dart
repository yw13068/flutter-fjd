import 'package:flutter/material.dart';
import './Storage.dart';
import 'dart:convert';
class UserServices{
    static getUserInfo()async{   
      List userInfo;   
      try {
        userInfo= json.decode(await Storage.getString('userInfo'));
      } catch (e) {
      //本地存储没有值
        userInfo= [];
      }
      return userInfo;
    }
    static getUserLoginState()async{
      var userInfo=await UserServices.getUserInfo();
      if(userInfo.length>0&&userInfo[0]['username']!=''){
        return true;
      }
      return false;
    }
    static loginOut(){
      Storage.remove('userInfo');
    }
}