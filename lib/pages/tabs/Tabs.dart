import 'package:flutter/material.dart';
import 'Home.dart';
import 'Category.dart';
import 'Cart.dart';
import 'User.dart';
import '../../services/ScreenAdapter.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex=3;
  PageController _pageController;
  @override
  void initState() { 
    super.initState();
    this._pageController=new PageController(initialPage:this._currentIndex );
  }
  List<Widget> _pageList=[
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage()
  ];
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
        
        body: PageView(//保持页面状态
          controller: this._pageController,
          children: this._pageList,
          onPageChanged: (index){
            setState(() {
              this._currentIndex=index;
            });
          },
         // physics: NeverScrollableScrollPhysics(),//禁止PageView滑动
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex:this._currentIndex ,//选中的index
          onTap: (index){
            this.setState((){
              this._currentIndex=index;//点击的index
              this._pageController.jumpToPage(index);//保持页面状态传点击索引
            });
          },
          type: BottomNavigationBarType.fixed,//可以显示多个导航按钮
          fixedColor: Colors.red,//选中按钮的红色
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('首页')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              title: Text('分类')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('购物车')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('我的')
            )
          ],
        ),
      );
  }
}