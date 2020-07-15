import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/ScreenAdapter.dart';
import './CartNum.dart';
import '../../config/Config.dart';
import '../../provider/Cart.dart';
class CartItem extends StatefulWidget {
  final Map _itemData;
  CartItem(this._itemData,{Key key}) : super(key: key);

  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  Map _itemData;
  @override
  Widget build(BuildContext context) {   
    //注意:属性变化
    this._itemData=widget._itemData; 
    var cartProvider=Provider.of<Cart>(context);
    String pic = this._itemData['pic'];
    pic = Config.domain + pic.replaceAll('\\', '/');
    return Container(
      width: ScreenAdapter.width(750),
      height: ScreenAdapter.height(160),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12
          )
        )
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenAdapter.width(80),
            child: Checkbox(
              value: this._itemData['checked'],
              onChanged: (val){
                this._itemData['checked']=!this._itemData['checked'];
                cartProvider.changeItemCheck();
              },
              activeColor: Colors.pink,
            ),
          ),
          Container(
            width: ScreenAdapter.width(156),
            child: Image.network('${pic}',fit: BoxFit.cover,)
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenAdapter.width(12), ScreenAdapter.height(0),ScreenAdapter.width(12),ScreenAdapter.height(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${this._itemData['title']}",maxLines: 2,),
                  Text("${this._itemData['selectedAttr']}",maxLines: 2,),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('￥${this._itemData['price']}',style:TextStyle(color: Colors.red)),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CartNum(this._itemData),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}