import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../models/newsmodel.dart';

class newsProvider with ChangeNotifier {
  List<newsData> _items = [];
  List<newsData> _itemsSlider = [];

  List<newsData> get item {
    return [..._items]; //returning the clone of this _items list
  }

  List<newsData> get itemSlider {
    return [..._itemsSlider]; //returning the clone of this _items list
  }

  Future<void> fetchNews(String kiskeuper, String what) async {
    var url1 =
        "https://newsapi.org/v2/top-headlines?country=in&category=$kiskeuper&apiKey=dde8eb71d71b4f79a8f5e0b9943fd73a";
    var url2 =
        "https://newsapi.org/v2/top-headlines?q=$what&apiKey=dde8eb71d71b4f79a8f5e0b9943fd73a";
    try {
      final res1 = await http.get(Uri.parse(url1));
      final res2 = await http.get(Uri.parse(url2));
      final data1 = jsonDecode(res1.body);
      final data2 = jsonDecode(res2.body);
      data1["articles"].forEach((ele) {
        //since data["articles"] is a list having all the properties which we want so using the loop on this list and each ele here is a map having a key value pair
        newsData instace = newsData(
            //creating a new instance
            UrltoMore: ele["url"],
            ImageToUrl: ele["urlToImage"],
            desc: ele["description"],
            title: ele["title"]);

        _items.add(instace); //adding this new instamce to the _items list
      });
      data2["articles"].forEach((ele) {
        newsData instace = newsData(
            //creating a new instance
            UrltoMore: ele["url"],
            ImageToUrl: ele["urlToImage"],
            desc: ele["description"],
            title: ele["title"]);

        _itemsSlider.add(instace); //adding this new instamce to the _items list
      });
      notifyListeners();
    } catch (err) {}
  }
}


// The category you want to get headlines for. Possible options: business entertainment general healths cience sports technology
