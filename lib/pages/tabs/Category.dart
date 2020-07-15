import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../model/CategoryModel.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int _selectIndex = 0;
  List _leftListData = [];
  List _rightListData = [];
  @override
  void initState() {
    super.initState();
    _getLeftListData();
  }

  //获取左边列表的数据
  _getLeftListData() async {
    var api = '${Config.domain}api/pcate';
    var result = await Dio().get(api);
    var leftCateList = CateModel.fromJson(result.data);
    print(leftCateList.result);
    setState(() {
      this._leftListData = leftCateList.result;
    });
    _getRightListData(leftCateList.result[0].sId);
  }

  //获取左边列表的数据
  _getRightListData(pid) async {
    var api = '${Config.domain}api/pcate?pid=${pid}';
    var result = await Dio().get(api);
    var rightCateList = CateModel.fromJson(result.data);
    print(rightCateList.result);
    setState(() {
      this._rightListData = rightCateList.result;
    });
  }

  //左边容器
  Widget _leftListWidget(leftWidth) {
    if (this._leftListData.length > 0) {
      return Container(
        width: leftWidth,
        height: double.infinity,
        child: ListView.builder(
          itemCount: this._leftListData.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: double.infinity,
                    height: ScreenAdapter.height(84),
                    padding: EdgeInsets.only(top: ScreenAdapter.height(24)),
                    child: Text("${this._leftListData[index].title}",
                        textAlign: TextAlign.center),
                    color: this._selectIndex == index
                        ? Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      this._selectIndex = index;
                    });
                    _getRightListData(this._leftListData[index].sId);
                  },
                ),
                Divider(height: 1)
              ],
            );
          },
        ),
      );
    } else {
      return Container(
        width: leftWidth,
        height: double.infinity,
      );
    }
  }

  //右边容器
  Widget _rightListWidget(rightWidth, rightHeight) {
    if (this._rightListData.length > 0) {
      return Expanded(
        //右边自适应
        flex: 1, //自适应
        child: Container(
            height: double.infinity,
            padding: EdgeInsets.all(10),
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //三列
                    childAspectRatio: rightWidth / rightHeight, //宽高比
                    crossAxisSpacing: 10, //水平间距
                    mainAxisSpacing: 10 //垂直间距
                    ),
                itemCount: this._rightListData.length,
                itemBuilder: (context, index) {
                  //处理图片
                  String pic = this._rightListData[index].pic;
                  pic = Config.domain + pic.replaceAll('\\', '/');
                  return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/productlist',
                            arguments: {'cid': this._rightListData[index].sId});
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.network(
                                '${pic}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              height: ScreenAdapter.height(28),
                              child:
                                  Text("${this._rightListData[index].title}"),
                            )
                          ],
                        ),
                      ));
                })),
      );
    } else {
      return Expanded(
          //右边自适应
          flex: 1, //自适应
          child: Container(
            height: double.infinity,
            child: Text("加载中..."),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    //计算右侧GridView宽高比
    var leftWidth = (ScreenAdapter.getScreenWidthDp()) / 4;
    //右侧每一项宽度=（总宽度-左侧宽度-GridView两侧宽度-GridView内部间隔）/3
    var rightWidth =
        (ScreenAdapter.getScreenWidthDp() - leftWidth - 20 - 20) / 3;
    rightWidth = ScreenAdapter.width(rightWidth); //宽度的占总屏幕的比例
    var rightHeight = rightWidth + ScreenAdapter.height(28);
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
        body: Row(
          children: <Widget>[
            _leftListWidget(leftWidth),
            _rightListWidget(rightWidth, rightHeight)
          ],
        )
      );
  }
}
