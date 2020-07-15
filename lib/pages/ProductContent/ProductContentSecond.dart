import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class ProductContentSecond extends StatefulWidget {
  final List _productContentData;
  ProductContentSecond(this._productContentData, {Key key}) : super(key: key);

  _ProductContentSecondState createState() => _ProductContentSecondState();
}

class _ProductContentSecondState extends State<ProductContentSecond> with AutomaticKeepAliveClientMixin {
  var _id;
  
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    this._id=widget._productContentData[0].sId;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child:Column(
        children: <Widget>[
           Expanded(
              child: InAppWebView(
                    initialUrl:'https://cloud.baidu.com/', //"http://jd.itying.com/pcontent?id=${ this._id}",                   
                    onProgressChanged: (InAppWebViewController controller, int progress) {
                      
                    },
            ),
           )
        ],
      ),
    );
  }

}
