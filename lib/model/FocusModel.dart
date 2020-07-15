// {"result":[{"_id":"59f6ef443ce1fb0fb02c7a43","title":"笔记本电脑","status":"1","pic":"public\\upload\\UObZahqPYzFvx_C9CQjU8KiX.png","url":"12"},{"_id":"5a012efb93ec4d199c18d1b4","title":"第二个轮播图","status":"1","pic":"public\\upload\\f3OtH11ZaPX5AA4Ov95Q7DEM.png"},{"_id":"5a012f2433574208841e0820","title":"第三个轮播图","status":"1","pic":"public\\upload\\s5ujmYBQVRcLuvBHvWFMJHzS.jpg"},{"_id":"5a688a0ca6dcba0ff4861a3d","title":"教程","status":"1","pic":"public\\upload\\Zh8EP9HOasV28ynDSp8TaGwd.png"}]}
class FocusModel {//模型类
  List<FocusItemModel> result;

  FocusModel({this.result});

  FocusModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<FocusItemModel>();
      json['result'].forEach((v) {
        result.add(new FocusItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FocusItemModel {
  String sId;
  String title;
  String status;
  String pic;
  String url;

  FocusItemModel({this.sId, this.title, this.status, this.pic, this.url});

  FocusItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    status = json['status'];
    pic = json['pic'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['status'] = this.status;
    data['pic'] = this.pic;
    data['url'] = this.url;
    return data;
  }
}