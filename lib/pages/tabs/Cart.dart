import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import '../Cart/CartItem.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isEidt=false;
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("购物车"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.launch),
              onPressed: () {
                setState(() {
                    this._isEidt=!this._isEidt; 
                });
              },
            )
          ],
        ),
        body: cartProvider.cartList.length > 0
            ? Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Column(
                        children: cartProvider.cartList.map((value) {
                          return CartItem(value);
                        }).toList()
                      ),
                      SizedBox(height: ScreenAdapter.height(100),)
                    ],
                      ),
                  Positioned(
                    bottom: 0,
                    width: ScreenAdapter.width(750),
                    height: ScreenAdapter.height(76),
                    child: Container(
                      width: ScreenAdapter.width(750),
                      height: ScreenAdapter.height(76),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top:
                                  BorderSide(width: 1, color: Colors.black12))),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: ScreenAdapter.width(80),
                                  child: Checkbox(
                                    value: cartProvider.isCheckAll,
                                    activeColor: Colors.pink,
                                    onChanged: (value) {
                                      setState(() {
                                        cartProvider.checkAll(value); 
                                      });
                                    },
                                  ),
                                ),
                                Text('全选'),
                                SizedBox(width: 15,),
                                this._isEidt?Text(""):Text('合计：'),
                                this._isEidt?Text(""):Text("${cartProvider.allPrice}",style: TextStyle(fontSize: 20,color: Colors.red),)
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child:this._isEidt? RaisedButton(
                              child: Text('删除',
                                  style: TextStyle(color: Colors.red)),
                              color: Colors.black12,
                              onPressed: () {
                                cartProvider.deleteItem();
                              },
                            ): RaisedButton(
                              child: Text('结算',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.red,
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Center(child: Text("购物车空空如也~~~")));
  }
}
