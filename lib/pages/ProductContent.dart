import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import './ProductContent/ProductContentFirst.dart';
import './ProductContent/ProductContentSecond.dart';
import './ProductContent/ProductContentThird.dart';
import '../widget/JdButton.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../model/ProductContentModel.dart';
import '../widget/LoadingWidget.dart';
import 'package:provider/provider.dart';
import '../provider/Cart.dart';
import '../services/CartServices.dart';
import 'package:fluttertoast/fluttertoast.dart';
//广播
import '../services/EventBus.dart';

class ProductContentPage extends StatefulWidget {
  final Map arguments;
  ProductContentPage({Key key,this.arguments}) : super(key: key);

  _ProductContentPageState createState() => _ProductContentPageState();
}

class _ProductContentPageState extends State<ProductContentPage> {
  List _productContentData=[];
  @override
  void initState() { 
    super.initState();
    this._getProductContentData();
  }
  _getProductContentData() async{
    var api="${Config.domain}api/pcontent?id=${widget.arguments['id']}";
    var result=await Dio().get(api);
    var productContent=ProductContentModel.fromJson(result.data);
    setState(() {
        this._productContentData.add(productContent.result);
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    var cartProvider=Provider.of<Cart>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar:AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenAdapter.width(400),
                child: TabBar(
                  indicatorColor: Colors.red,//设置底部线的颜色
                  indicatorSize: TabBarIndicatorSize.label,//设置选中底部线的宽度
                  tabs: <Widget>[
                    Tab(
                      child: Text('商品'),
                    ),
                    Tab(
                      child: Text('详情'),
                    ),
                    Tab(
                      child: Text('评价'),
                    )
                  ],
                ),                
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: (){
                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(ScreenAdapter.width(600), 80, 0, 0),
                    items:[
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.home),
                            Text("首页")
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search),
                            Text("搜索")
                          ],
                        ),
                      )
                    ]
                );
              },
            )
          ],
        ),
        body:this._productContentData.length>0? Stack(
          children: <Widget>[
            TabBarView(
              children: <Widget>[
                ProductContentFirst(this._productContentData),
                ProductContentSecond(this._productContentData),
                ProductContentThird(),
              ],
              physics: NeverScrollableScrollPhysics(),
            ),
            Positioned(
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(108),
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:BorderDirectional(
                    top: BorderSide(
                      width: 1,
                      color: Colors.black26
                    )
                  )
                ),
                child:Row(
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/cart');
                      },
                      child: Container(
                        padding: EdgeInsets.only(top:ScreenAdapter.width(10)),
                        width: ScreenAdapter.width(200),
                        height: ScreenAdapter.height(88),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.shopping_cart),
                            Text("购物车")
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: JdButton(
                        color: Colors.red,
                        text: "加入购物车",
                        cd:() async{
                          if(this._productContentData[0].attr.length>0){
                            eventBus.fire(ProductContentBus('加入购物车'));
                          }else{
                            await CartServices.addCart(this._productContentData[0]);//这是个异步方法
                             cartProvider.upDataList();
                             Fluttertoast.showToast(
                                  msg: "加入购物车成功！",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                          }
                        }
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: JdButton(
                        color: Colors.orange,
                        text: "立即购买",
                        cd: (){
                          print("立即购买");
                          if(this._productContentData[0].attr.length>0){
                            eventBus.fire(ProductContentBus('立即购买'));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ):LoadingWidget()
      ),
    );
  }
}