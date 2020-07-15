import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
class JdText extends StatelessWidget {
  final String text;
  final bool password;
  final Object onChanged;
  JdText({Key key,this.text='',this.password=false,this.onChanged=null}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(  
        obscureText: this.password,  
        decoration: InputDecoration(
          hintText: this.text,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
        onChanged:this.onChanged,
      ),
      height: ScreenAdapter.height(68),
      decoration: BoxDecoration(      
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black26
            )
          )
    ),
    );
  }
}