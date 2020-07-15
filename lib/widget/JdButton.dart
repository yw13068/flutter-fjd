import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
class JdButton extends StatelessWidget {
  final Color color;
  final String text;
  final Object cd;
  final double height;
  JdButton({Key key,this.color=Colors.black,this.text="按钮",this.cd=null,this.height=72}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return InkWell(
      onTap: this.cd,
      child: Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(8),
      height: ScreenAdapter.height(this.height),
      width: double.infinity,                        
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text("${this.text}",style: TextStyle(color:Colors.white,fontSize: 18 ),),
      ),
    ),
    );
  }
}