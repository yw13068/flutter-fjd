import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/CartServices.dart';
import '../../widget/JdButton.dart';
import '../../services/ScreenAdapter.dart';
import '../../config/Config.dart';
import '../../model/ProductContentModel.dart';
import './CartNum.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
//广播
import '../../services/EventBus.dart';

class ProductContentFirst extends StatefulWidget {
  final List _productContentData;
  ProductContentFirst(this._productContentData, {Key key}) : super(key: key);

  _ProductContentFirstState createState() => _ProductContentFirstState();
}

class _ProductContentFirstState extends State<ProductContentFirst>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ProductContentItem _productContent;
  List _attr = [];
  String attrValue;
  var actionEventBus;
  var cartProvider;
  @override
  void initState() {
    super.initState();
    this._productContent = widget._productContentData[0];
    this._attr = this._productContent.attr;
    this._initAttr();
    this.actionEventBus=eventBus.on<ProductContentBus>().listen((event) {//广播事件监听
      print(event);
      this._attrBottomSheet();
    });
  }
  void dispose(){
    super.dispose();
    this.actionEventBus.cancel();//广播事件销毁
  }

  //初始化Attr 格式化数据
  _initAttr() {
    var attr = this._attr;
    for (var i = 0; i < attr.length; i++) {
      attr[i].attrList.clear();//清空数组里的数据
      for (var j = 0; j < attr[i].list.length; j++) {
        if (j == 0) {
          attr[i].attrList.add({"title": attr[i].list[j], "checked": true});
        } else {
          attr[i].attrList.add({"title": attr[i].list[j], "checked": false});
        }
      }
    }
    _getSelectedAttrValue();
  }

  //点击选中颜色
  _changeAttr(cate, title,setBottomState) {
    var attr = this._attr;
    for (var i = 0; i < attr.length; i++) {
      if (attr[i].cate == cate) {
        for (var j = 0; j < attr[i].attrList.length; j++) {
          attr[i].attrList[j]['checked'] = false;
          if (attr[i].attrList[j]['title'] == title) {
            attr[i].attrList[j]['checked'] = true;
          }
        }
      }
    }
    setBottomState(() {//注意 改变showModalBottomSheet里面的数据，来源于StatefulBuilder
      this._attr = attr;
    });
    _getSelectedAttrValue();
  }

  //获取选中的配置
  _getSelectedAttrValue(){
    var attr = this._attr;
    var tempAttr=[];
    for (var i = 0; i < attr.length; i++) {
      for (var j = 0; j < attr[i].attrList.length; j++) {
        if (attr[i].attrList[j]['checked'] == true) {
          tempAttr.add(attr[i].attrList[j]['title']);
        }
      }
    }
    setState(() {
      this.attrValue= tempAttr.join(',');
      this._productContent.selectedAttr=this.attrValue;
    });
  }
  List<Widget> _getAttrItemWidget(attrItem,setBottomState) {
    List<Widget> attrItemList = [];
    attrItem.attrList.forEach((item) {
      attrItemList.add(Container(
        margin: EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            this._changeAttr(attrItem.cate, item['title'],setBottomState);
          },
          child: Chip(
            label: Text("${item['title']}",style: TextStyle(color:item['checked'] ?Colors.white : Colors.black),),
            padding: EdgeInsets.all(10),
            backgroundColor: item['checked'] ? Colors.red : Colors.black12,
          ),
        ),
      ));
    });
    return attrItemList;
  }

//封装一个组件 渲染attr；
  List<Widget> _getAttrWidget(setBottomState) {
    List<Widget> attrList = [];
    this._attr.forEach((attrItem) {
      attrList.add(
        Wrap(
          children: <Widget>[
            Container(
              width: ScreenAdapter.width(120),
              child: Padding(
                padding: EdgeInsets.only(top: ScreenAdapter.height(28)),
                child: Text("${attrItem.cate}: ",
                    style: TextStyle(fontSize: ScreenAdapter.size(28))),
              ),
            ),
            Container(
              width: ScreenAdapter.width(580),
              child: Wrap(children: _getAttrItemWidget(attrItem,setBottomState)),
            )
          ],
        ),
      );
    });
    return attrList;
  }

  _attrBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setBottomState) {
              return GestureDetector(
                onTap: (){
                  return false;//解决showModalBottomSheet点击消失的问题
                },
                child:Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _getAttrWidget(setBottomState)),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: ScreenAdapter.height(60),
                              child: Row(
                                children: <Widget>[
                                  Text("数量：", style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(width: 10,),
                                  CartNum(this._productContent)
                                ],
                              ),
                            )
                      ],
                    ),
                  ),
                  Positioned(
                    width: ScreenAdapter.width(750),
                    height: ScreenAdapter.height(88),
                    bottom: 0,
                    child: Container(
                      width: ScreenAdapter.width(750),
                      height: ScreenAdapter.height(88),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              child: JdButton(
                                  color: Colors.red,
                                  text: "加入购物车",
                                  cd: () async{
                                    print("加入购物车");
                                    await CartServices.addCart(this._productContent);//这是个异步方法
                                    Navigator.of(context).pop();
                                    this.cartProvider.upDataList();
                                    Fluttertoast.showToast(
                                        msg: "加入购物车成功！",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                              child: JdButton(
                                  color: Colors.orange,
                                  text: "立即购买",
                                  cd: () {
                                    print("立即购买");
                                    
                                    CartServices.addCart(this._productContent);
                                    Navigator.of(context).pop();
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    this.cartProvider=Provider.of<Cart>(context);
    String pic = Config.domain + this._productContent.pic;
    pic = pic.replaceAll('\\', '/');
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
              child: AspectRatio(
            aspectRatio: 16 / 12,
            child: Image.network(
              '${pic}',
              fit: BoxFit.cover,
            ),
          )),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "${this._productContent.title}",
              style: TextStyle(
                  fontSize: ScreenAdapter.size(36), color: Colors.black87),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text("${this._productContent.subTitle}",
                style: TextStyle(
                    fontSize: ScreenAdapter.size(24), color: Colors.black45)),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text('特价：'),
                      Text(
                        '￥${this._productContent.price}',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenAdapter.size(48)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('原价： '),
                      Text(
                        '￥${this._productContent.oldPrice}',
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: ScreenAdapter.size(28),
                            decoration: TextDecoration.lineThrough),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              _attrBottomSheet();
            },
            child:this._attr.length>0?Container(
              margin: EdgeInsets.only(top: 10),
              height: ScreenAdapter.height(60),
              child: Row(
                children: <Widget>[
                  Text("已选：", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${this.attrValue}")
                ],
              ),
            ):Text(''),
          ),
          Divider(),
          Container(
            height: ScreenAdapter.height(60),
            child: Row(
              children: <Widget>[
                Text("运费：", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("免运费")
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
