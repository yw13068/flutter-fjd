import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/Storage.dart';
class Cart with ChangeNotifier{
  List _cartList=[];
  bool _isCheckAll=false;//状态
  double _allPrice=0;
  List get cartList=>this._cartList;
  bool get isCheckAll=>this._isCheckAll;
  double get allPrice=>this._allPrice;
  Cart(){
    this.init();
  }
  //初始化购物车数据
  init() async{
    try{
      this._cartList=json.decode(await Storage.getString('cartList'));
    }catch(e){
      this._cartList=[];
    }
    //计算总价
    this.computeAllPrice();
    //判断初始化是否全选
    this._isCheckAll=this.isCheckedAll();
    notifyListeners();
  }
  //更新数据
  upDataList(){
    this.init();
  }
  //改变数据
  changeItemList(){
    //计算总价
    this.computeAllPrice();
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }
  checkAll(value){
    for(var i=0;i<this._cartList.length;i++){
        this._cartList[i]['checked']=value;
    }    
    this._isCheckAll=value;
    //计算总价
    this.computeAllPrice();
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }

  //判断是否权限
  bool isCheckedAll(){
    if(this._cartList.length>0){
      for(var i=0;i<this._cartList.length;i++){
        if(this._cartList[i]['checked']==false){
          return false;
        }
      }
      return true;
    }
    return false;
  }
  //监听每一项选择
  changeItemCheck(){
    if(isCheckedAll()){
      this._isCheckAll=true;
    }else{
      this._isCheckAll=false;
    }
    //计算总价
    this.computeAllPrice();
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }
  //计算总价
  computeAllPrice(){
    double tempPrcie=0;
    for(var i=0;i<this._cartList.length;i++){
      if(this._cartList[i]['checked']){
        tempPrcie+=this._cartList[i]['count']*this._cartList[i]['price'];
      }
    }
    this._allPrice=tempPrcie;
    notifyListeners();
  }
  //删除选中的数据
  deleteItem(){
    List tempList=[];
    for(var i=0;i<this._cartList.length;i++){
      if(this._cartList[i]['checked']==false){
        tempList.add(this._cartList[i]);
      }
    }
    this._cartList=tempList;
    //计算总价
    this.computeAllPrice();
    Storage.setString('cartList', json.encode(this._cartList));  
    notifyListeners();
  }

}