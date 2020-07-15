import 'package:flutter/material.dart';
import './routers/router.dart';
import 'package:provider/provider.dart';
import './provider/Cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_)=>Cart(),)//引入Count.dart里面的数据，可以向下广播
      ],
      child: MaterialApp(
        //home:Tabs()
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
        debugShowCheckedModeBanner: false, //去掉右上角的debug
        theme: ThemeData(primaryColor: Colors.white),
      ),
    );
  }
}
