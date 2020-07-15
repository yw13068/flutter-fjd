import 'package:flutter_screenutil/flutter_screenutil.dart';
class ScreenAdapter{
  static init(context){
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);//width和height是设计稿的宽高
  }
  static height(double value){
    return ScreenUtil.getInstance().setHeight(value);
  }
  static width(double value){
    return ScreenUtil.getInstance().setWidth(value);
  }
  static getScreenWidthDp(){//获取当前设备宽度dp
    return ScreenUtil.screenWidthDp;
  }
  static getScreenHeightDp(){//获取当前设备高度dp
    return ScreenUtil.screenHeightDp;
  }
  static size(double size){//适配字体大小
    return ScreenUtil.getInstance().setSp(size);
  }
}