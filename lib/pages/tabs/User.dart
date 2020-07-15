import 'package:flutter/material.dart';
import 'package:flutter_fjd/services/EventBus.dart';
import '../../widget/JdButton.dart';
import '../../services/ScreenAdapter.dart';
import '../../services/UserServices.dart';
import '../../services/EventBus.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool userLogin=false;
  List userData=[];
  @override
  void initState() { 
    super.initState();
    this._getUserSate();
    //监听登录事件
    eventBus.on<UserBus>().listen((event){
      this._getUserSate();
    });
  }
  _getUserSate()async{
    var userLogin=await UserServices.getUserLoginState();
    var userData=await UserServices.getUserInfo();
    setState(() {
      this.userData=userData;
      this.userLogin=userLogin;
    });
     
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('用户中心'),
        // ),
        body: ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/user_bg.jpg'), fit: BoxFit.cover)),
          width: double.infinity,
          height: ScreenAdapter.height(220),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ClipOval(
                  child: Image.asset(
                    'images/user.png',
                    fit: BoxFit.cover,
                    width: ScreenAdapter.width(100),
                    height: ScreenAdapter.width(100),
                  ),
                ),
              ),
              !this.userLogin? Expanded(
                flex: 1,
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Container(
                    child: Text("注册/登录", style: TextStyle(color: Colors.white,fontSize: ScreenAdapter.size(36))),
                  ),
                ),
              ):Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('用户：${this.userData[0]['username']}',style: TextStyle(color: Colors.white,fontSize: ScreenAdapter.size(32))),
                    Text('普通会员',style: TextStyle(color: Colors.white,fontSize: ScreenAdapter.size(28)))
                  ],
                ),
              )
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.access_time,
            color: Colors.blue,
            size: ScreenAdapter.size(56),
          ),
          title: Text("个人中心"),
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.search,
            color: Colors.green,
            size: ScreenAdapter.size(56),
          ),
          title: Text("个人中心"),
        ),
        Container(
          height: ScreenAdapter.height(40),
          color: Colors.black12,
        ),
        ListTile(
          leading: Icon(
            Icons.home,
            color: Colors.red,
            size: ScreenAdapter.size(56),
          ),
          title: Text("个人中心"),
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.unfold_more,
            color: Colors.blue,
            size: ScreenAdapter.size(56),
          ),
          title: Text("个人中心"),
        ),
        Divider(height: ScreenAdapter.height(50),),
        this.userLogin?JdButton(
          text: "退出登录",
          color: Colors.red,
          cd: (){
            UserServices.loginOut();
            this._getUserSate();
            Navigator.of(context).pushNamed('/login');
          },
        ):JdButton(
          text: "登录",
          color: Colors.red,
          cd: (){
            UserServices.loginOut();
            this._getUserSate();
            Navigator.of(context).pushNamed('/login');
          },
        )
      ],
    ));
  }
}
