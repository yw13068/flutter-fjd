import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
class CartNum extends StatefulWidget {
  final Map _itemData;
  CartNum(this._itemData,{Key key}) : super(key: key);

  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  Map _itemData;
  var cartProvider;
  @override
  void initState() { 
    super.initState();
    this._itemData=widget._itemData;
  }
  @override
  Widget build(BuildContext context) {
    this.cartProvider = Provider.of<Cart>(context);
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width:ScreenAdapter.width(2),
            color: Colors.black12
          )
        ),
        width: ScreenAdapter.width(168),
        child: Row(
          children: <Widget>[
            _leftBtn(),
            _centerArea(),
            _rightBtn()
          ],
        ),
    );
  }
  //左边按钮
  Widget _leftBtn(){
    return InkWell(
      onTap: (){
        if(this._itemData['count']>1){
          this._itemData['count']--;
          cartProvider.changeItemList();
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(45),
        height: ScreenAdapter.height(45),
        child: Text('-'),
      ),
    );
  }
  //右边按钮
  Widget _rightBtn(){
    return InkWell(
      onTap: (){
        this._itemData['count']++;
        cartProvider.changeItemList();
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(45),
        height: ScreenAdapter.height(45),
        child: Text('+'),
      ),
    );
  }
  //中间
  Widget _centerArea(){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: ScreenAdapter.width(2),
            color: Colors.black12
          ),
          right: BorderSide(
            width: ScreenAdapter.width(2),
            color: Colors.black12
          )
        )
      ),
      alignment: Alignment.center,
      width: ScreenAdapter.width(70),
      height: ScreenAdapter.height(45),
      child: Text('${this._itemData["count"]}'),
    );
  }
}