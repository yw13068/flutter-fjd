import 'package:flutter/material.dart';
import '../pages/tabs/Tabs.dart';
import '../pages/ProductList.dart';
import '../pages/Search.dart';
import '../pages/ProductContent.dart';
import '../pages/tabs/Cart.dart';
import '../pages/Login.dart';
import '../pages/RegisterFirst.dart';
import '../pages/RegisterSecond.dart';
import '../pages/RegisterThird.dart';



//配置路由
final routes = {
  '/': (context) => Tabs(),
  '/cart':(context)=>CartPage(),
  '/login':(context)=>LoginPage(),
  '/registerfirst':(context)=>RegisterFirst(),
  '/registersecond':(context,{arguments})=>RegisterSecond(arguments:arguments),
  '/registerthird':(context,{arguments})=>RegisterThird(arguments:arguments),
  '/productlist':(context,{arguments})=>ProductListPage(arguments:arguments),
  '/search':(context)=>SearchPage(),
  '/productcontent':(context,{arguments})=>ProductContentPage(arguments:arguments)
};

//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
