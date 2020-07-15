import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../services/SearchServices.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _historyListData=[];
  var _keywords;
  @override
  void initState() { 
    super.initState();
    this._getHisoryListData();
  }
  _showAlertDialog(keywords)async{
    var result=await showDialog(
      barrierDismissible: false,//表示点击灰色背景时是否消失弹窗
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('提示信息！'),
          content: Text('您确定要删除吗？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: (){
                Navigator.pop(context,'Cancle');
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: ()async{
                //注意异步
                await SearchServices.removeHistoryList(keywords);
                this._getHisoryListData();
                Navigator.pop(context,'Ok');
              },
            )
          ],
        );
      }
    );
  }
  _getHisoryListData() async{
    this._historyListData=await SearchServices.getHistoryList();
    setState(() {
      this._historyListData= _historyListData;
    });
  }
  Widget _historyListWidget() {
    if(this._historyListData.length>0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenAdapter.width(10)),
            child: Text('历史记录', style: Theme.of(context).textTheme.title),
          ),
          Divider(),
          Column(
            children: this._historyListData.map((value){
              return Column(
                children: <Widget>[
                   ListTile(
                    title: Text('${value}'),
                    onLongPress: (){
                      this._showAlertDialog('${value}');
                      this._getHisoryListData();
                    },
                  ),
                  Divider()
                ],
              );
            }).toList(),
          ),
          SizedBox(height: ScreenAdapter.height(100)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  width: ScreenAdapter.width(360),
                  height: ScreenAdapter.height(64),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black26)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.delete), Text("清空历史记录")],
                  ),
                ),
                onTap: () {
                  SearchServices.clearHistoryList();
                  this._getHisoryListData();
                },
              )
            ],
          )
        ],
      );
    }else{
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10), 0, 0, ScreenAdapter.width(6)),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25) //圆角
                  ),
            ),
            onChanged: (value) {
              this._keywords = value;
            },
          ),
          height: ScreenAdapter.height(60),
          decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.8),
              borderRadius: BorderRadius.circular(25) //圆角
              ),
        ),
        actions: <Widget>[
          InkWell(
            child: Container(
              height: ScreenAdapter.height(60),
              width: ScreenAdapter.width(80),
              child: Row(
                children: <Widget>[Text('搜索')],
              ),
            ),
            onTap: (){
              SearchServices.setHistoryList(this._keywords);
              Navigator.pushReplacementNamed(context, '/productlist',
                  arguments: {
                    //pushReplacementNamed替换当前路由
                    'keywords': this._keywords
                  });
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: ScreenAdapter.width(10)),
              child: Text('热搜', style: Theme.of(context).textTheme.title),
            ),
            Divider(),
            Wrap(
              children: <Widget>[
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("笔记本电脑"),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("女装"),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("女装1111"),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("时尚数码"),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("女装"),
                  ),
                  onTap: () {},
                )
              ],
            ),
            _historyListWidget()
          ],
        ),
      ),
    );
  }
}
