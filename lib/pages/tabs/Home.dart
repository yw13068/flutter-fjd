import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  //AutomaticKeepAliveClientMixin保持页面状态
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  List _focusData = [];
  List _hotProductListData = [];
  List _bestProductListData = [];
  @override
  void initState() {
    super.initState();
    _getFocusData();
    _hotProductData();
    _bestProductData();
  }

  //轮播图数据
  _getFocusData() async {
    var api = '${Config.domain}api/focus';
    var result = await Dio().get(api);
    var focusList = FocusModel.fromJson(result.data);
    setState(() {
      this._focusData = focusList.result;
    });
  }

  //热门产品数据
  _hotProductData() async {
    var api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    var productList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotProductListData = productList.result;
    });
  }

  //推荐产品数据
  _bestProductData() async {
    var api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var productList = ProductModel.fromJson(result.data);
    setState(() {
      this._bestProductListData = productList.result;
    });
  }

  //轮播图
  Widget _swiperWidget() {
    if (this._focusData.length > 0) {
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1, //无论什么设备宽高比都是2：1
          child: new Swiper(
            itemBuilder: (BuildContext context, int index) {
              String pic = this._focusData[index].pic;
              pic = Config.domain + pic.replaceAll('\\', '/');
              return new Image.network(
                "${pic}",
                fit: BoxFit.fill,
              );
            },
            itemCount: this._focusData.length,
            pagination: new SwiperPagination(),
            autoplay: true, //自动播放
          ),
        ),
      );
    } else {
      return Text('加载中...');
    }
  }

  Widget _titleWidget(value) {
    return Container(
      height: ScreenAdapter.height(32),
      margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
      padding: EdgeInsets.only(left: ScreenAdapter.width(20)),
      decoration: BoxDecoration(
          //设置样式
          border: Border(
              //设置边框
              left: BorderSide(
                  //设置做边框
                  color: Colors.red,
                  width: ScreenAdapter.width(10) //宽是设计稿的宽
                  ))),
      child: Text(
        value,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

//热门产品
  Widget _hotProductList() {
    if (this._hotProductListData.length > 0) {
      return Container(
        height: ScreenAdapter.height(200),
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal, //设置为水平方向
          itemBuilder: (context, index) {
            var sPic = this._hotProductListData[index].sPic;
            sPic = Config.domain + sPic.replaceAll('\\', '/');
            return Column(
              children: <Widget>[
                Container(
                  width: ScreenAdapter.width(140),
                  height: ScreenAdapter.height(120),
                  margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
                  child: Image.network(
                    '${sPic}',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
                    height: ScreenAdapter.height(30),
                    child: Text(
                      "￥${this._hotProductListData[index].price}",
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            );
          },
          itemCount: this._hotProductListData.length,
        ),
      );
    } else {
      return Text("加载中...");
    }
  }

  //推荐商品
  Widget _recProductListWidget() {
    if (this._bestProductListData.length > 0) {
      //获取屏幕的宽度减去盒子的间距除以2就是盒子的宽度
      var itemWidth = (ScreenAdapter.getScreenWidthDp() - 30) / 2;
      return Container(
        padding: EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 10, //垂直间隔
          spacing: 10, //水平间隔
          children: this._bestProductListData.map((value) {
            //图片
            String sPic = value.sPic;
            sPic = Config.domain + sPic.replaceAll('\\', '/');
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/productcontent',
                    arguments: {'id': value.sId});
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
                width: itemWidth,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 1 / 1, //防止服务器返回的图片大小不一致导致高度不一致
                          child: Image.network(
                            '${sPic}',
                            fit: BoxFit.cover,
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                        child: Text(
                          "${value.title}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black54),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                      child: Stack(
                        //左右两边的价格用定位来做
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "￥${value.price}",
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("￥${value.oldPrice}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    decoration: TextDecoration.lineThrough)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Text("加载中..");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context); //必须写在build 里面
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.center_focus_weak,
            size: 28,
            color: Colors.black87,
          ),
          onPressed: null,
        ),
        title: InkWell(
          child: Container(
            height: ScreenAdapter.height(60),
            padding: EdgeInsets.only(left: ScreenAdapter.width(10)),
            decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.8),
                borderRadius: BorderRadius.circular(25) //圆角
                ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.search),
                Text(
                  "笔记本",
                  style: TextStyle(fontSize: ScreenAdapter.size(28)),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        actions: <Widget>[
          Icon(
            Icons.message,
            size: 28,
            color: Colors.black87,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _swiperWidget(),
          SizedBox(height: ScreenAdapter.height(20)),
          _titleWidget('猜你喜欢'),
          SizedBox(height: ScreenAdapter.height(20)),
          _hotProductList(),
          _titleWidget('热门推荐'),
          _recProductListWidget()
        ],
      ),
    );
  }
}
