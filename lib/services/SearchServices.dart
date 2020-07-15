import 'dart:convert';

import 'Storage.dart';

class SearchServices {
  static setHistoryList(keywords) async {
    try {
      List searchListData = json.decode(await Storage.getString('searchList'));
      var hasData = searchListData.any((v) {
        return v == keywords; //查找本地存储有值，有没有当前搜索值
      });
      if (!hasData) {
        searchListData.add(keywords); //本地存储有值，但是没有当前搜索值
        await Storage.setString('searchList', json.encode(searchListData));
      }
    } catch (e) {
      //本地存储没有值
      List tempList = new List();
      tempList.add(keywords);
      await Storage.setString('searchList', json.encode(tempList));
    }
  }

  static getHistoryList() async {
    try {
      List searchListData = json.decode(await Storage.getString('searchList'));
      return searchListData;
    } catch (e) {
      //本地存储没有值
      return [];
    }
  }
  static clearHistoryList() async {
      Storage.remove('searchList');
      return [];
  }
  static removeHistoryList(keywords) async {
      List searchListData = json.decode(await Storage.getString('searchList'));
      searchListData.remove(keywords);
      await Storage.setString('searchList', json.encode(searchListData));
  }
  
}
