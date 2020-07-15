import 'dart:convert';
import './Storage.dart';
class  CartServices{
  static addCart(item) async{
    item=CartServices.formatCartData(item);
    try{
      List cartListData=json.decode(await Storage.getString('cartList'));//获取本地存储数据
      bool hasData=cartListData.any((value){//判断本条数据是否存在
        if(value['_id']==item['_id']&&value['selectedAttr']==item['selectedAttr']){
          return true;
        }else{
          return false;
        }
      });
      if(hasData){//有的话就+1
        for(var i=0;i<cartListData.length;i++){
          if(cartListData[i]['_id']==item['_id']&&cartListData[i]['selectedAttr']==item['selectedAttr']){
              cartListData[i]['count']=cartListData[i]['count']+1;
          }
          await Storage.setString('cartList', json.encode(cartListData));
        }
      }else{//没有的话就整条数据添加
        cartListData.add(item);
        await Storage.setString('cartList', json.encode(cartListData));
      }

    }catch(e){//如果没有加入购物车的本地存储
      var tempList=[];
      tempList.add(item);
      await Storage.setString('cartList', json.encode(tempList));
    }
  }
  //过滤数据
  static formatCartData(item){
    final Map data = new Map<String, dynamic>();
    data['_id'] = item.sId;
    data['title'] = item.title;
    //处理返回的价格为int或者string类型
    if(item.price is int || item.price is double){     
      data['price'] = item.price;
    }else{
      data['price'] = double.parse(item.price);
    }
    data['selectedAttr'] = item.selectedAttr;
    data['count'] = item.count;
    data['pic'] = item.pic;
    //是否选中
    data['checked'] = true;    
    return data;
  }
}