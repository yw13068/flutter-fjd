import 'package:event_bus/event_bus.dart';
EventBus eventBus = EventBus();
class ProductContentBus{
  String str;
  ProductContentBus(this.str);
}
//用户中心事件广播
class UserBus{
  String str;
  UserBus(this.str);
}