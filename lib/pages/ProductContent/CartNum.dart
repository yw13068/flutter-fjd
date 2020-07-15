import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';
import '../../model/ProductContentModel.dart';
class CartNum extends StatefulWidget {
  final ProductContentItem _productContent;
  CartNum(this._productContent,{Key key}) : super(key: key);

  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  ProductContentItem _productContent;
  @override
  void initState() { 
    super.initState();
  this._productContent=widget._productContent;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: ScreenAdapter.width(2),
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
        if(this._productContent.count>1){
          setState(() {
            this._productContent.count--;
          });
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
        setState(() {
          this._productContent.count++;
        });
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
            width:  ScreenAdapter.width(2),
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
      child: Text('${this._productContent.count}'),
    );
  }
}