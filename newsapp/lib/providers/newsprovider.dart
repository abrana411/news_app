import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/newsmodel.dart';

// ignore: camel_case_types
class newsProvider with ChangeNotifier {
  final List<newsData> _items = [];
  final List<newsData> _itemsindia = [];
  final List<newsData> _itembusiness = [];
  final List<newsData> _itemgeneral = [];
  final List<newsData> _itemhealth = [];
  final List<newsData> _itemscience = [];
  final List<newsData> _itemsports = [];
  final List<newsData> _itemtechnology = [];
  final List<newsData> _itementertainment = [];
  final List<newsData> _itemSearched = [];
  final List<newsData> _itemadditional = [];

  List<newsData> get item {
    return [..._items]; //returning the clone of this _items list
  }

  List<newsData> itemCategory(String cat, bool isadditional) {
    //here not making a getter rather a method that will give the copy of the desired ategory list having news
    if (cat == "india" && !isadditional) {
      return [..._itemsindia];
    } else if (cat == "business" && !isadditional) {
      return [..._itembusiness];
    } else if (cat == "entertainment" && !isadditional) {
      return [..._itementertainment];
    } else if (cat == "general" && !isadditional) {
      return [..._itemgeneral];
    } else if (cat == "health" && !isadditional) {
      return [..._itemhealth];
    } else if (cat == "science" && !isadditional) {
      return [..._itemscience];
    } else if (cat == "sports" && !isadditional) {
      return [..._itemsports];
    } else if (cat == "technology" && !isadditional) {
      return [..._itemtechnology];
    } else //if any thing is searched
    {
      if (isadditional) {
        //agar country ya language h to
        //print("yoyoyo");
        return [..._itemadditional];
      } else {
        return [..._itemSearched];
      }
    }
  }

  Future<void> fetchNews(String kiskeuper) async {
    var url1 =
        "https://newsapi.org/v2/top-headlines?country=in&category=$kiskeuper&apiKey=dde8eb71d71b4f79a8f5e0b9943fd73a";

    try {
      final res1 = await http.get(Uri.parse(url1));

      final data1 = jsonDecode(res1.body);

      data1["articles"].forEach((ele) {
        //since data["articles"] is a list having all the properties which we want so using the loop on this list and each ele here is a map having a key value pair
        try {
          //checking for a particular news error here too
          newsData instance = newsData(
              //creating a new instance
              UrltoMore: ele["url"],
              ImageToUrl: ele["urlToImage"],
              desc: ele["description"],
              title: ele["title"]);

          _items.add(instance); //adding this new instamce to the _items list
        } catch (e) {
          //print(e);
        }
      });
      notifyListeners();
    } catch (err) {
      // print(err);
    }
  }

  Future<void> fetchAdditional(String counlan, bool iscountry) async {
    _itemadditional
        .clear(); //shuru me khali kar denge koi previous chej hogi isme to
    //print(counlan + "   coun");
    var url = "";
    if (!iscountry) //agar language ki chahiyie to
    {
      url =
          "https://newsapi.org/v2/everything?language=$counlan&q=-china&apiKey=dde8eb71d71b4f79a8f5e0b9943fd73a";
    } else {
      url =
          "https://newsapi.org/v2/top-headlines?country=$counlan&apiKey=dde8eb71d71b4f79a8f5e0b9943fd73a";
    }

    try {
      final res = await http.get(Uri.parse(url));
      final data = jsonDecode(res.body);
      //print(url);
      data["articles"].forEach((ele) {
        try {
          newsData instance = newsData(
              //creating a new instance
              UrltoMore: ele["url"],
              ImageToUrl: ele["urlToImage"],
              desc: ele["description"],
              title: ele["title"]);
          if (ele["url"].toString().substring(0, 5) == "https") {
            _itemadditional.add(instance);
          }
        } catch (err) {
          //print(err);
          //print("1");
        }
      });
      notifyListeners();
    } catch (err) {
      //print(err);
      //print("2");
    }
  }

  Future<void> fetchCategoryNews(String what, bool isSearched) async {
    //print("why bro");
    var url2 = "";
    // if (what == "india") {
    //   url2 =
    //       "https://newsapi.org/v2/top-headlines?q=$what&apiKey=dde8eb71d71b4f79a8f5e0b9943fd73a";
    // }
    if (isSearched) {
      _itemSearched.clear(); //clearing the previous data before entering new
    }
    if (what == "general" ||
        what == "business" ||
        what == "entertainment" ||
        what == "health" ||
        what == "science" ||
        what == "sports" ||
        what == "technology") {
      url2 =
          "https://newsapi.org/v2/top-headlines?country=in&category=$what&apiKey=dde8eb71d71b4f79a8f5e0b9943fd73a";
    } else //if searched text is there then it can be anything and for the initial india also
    {
      url2 =
          "https://newsapi.org/v2/top-headlines?country=in&q=$what&apiKey=dde8eb71d71b4f79a8f5e0b9943fd73a";
    }
    try {
      final res2 = await http.get(Uri.parse(url2));
      final data2 = jsonDecode(res2.body);
      data2["articles"].forEach((ele) {
        try {
          //if there is a problem in fetching a particular data then we are handling it here and will skip that if thats the case
          newsData instance = newsData(
              //creating a new instance
              UrltoMore: ele["url"],
              ImageToUrl: ele["urlToImage"],
              desc: ele["description"],
              title: ele["title"]);
          // if (ele["url"] != null &&
          //     ele["urlToImage"] != null &&
          //     ele["description"] != null &&
          //     ele["title"] !=
          //         null) //if we have any one of the above values as null then dont add this instance
          // {
          if (ele["url"].toString().substring(0, 5) == "https") {
            //so that it will take only those news having https and not http only
            if (isSearched) //agar search kara h to sidha _iem/serached me add krenge...agar search nhi kara tab he check krenge bakiyo ko
            {
              //print("here");
              _itemSearched.add(instance);
            } else {
              if (what == "india") {
                _itemsindia.add(
                    instance); //adding this new instance to the _items list
              } else if (what == "business") {
                _itembusiness.add(instance);
              } else if (what == "entertainment") {
                _itementertainment.add(instance);
              } else if (what == "general") {
                _itemgeneral.add(instance);
              } else if (what == "health") {
                _itemhealth.add(instance);
              } else if (what == "science") {
                _itemscience.add(instance);
              } else if (what == "sports") {
                _itemsports.add(instance);
              } else //if what is equal to technology
              {
                _itemtechnology.add(instance);
              }
            }
          }
          //}

// business entertainment general health science sports technology
        } catch (e) {
          //print(e);
          //print("hello2");
        }
      });
      //print(_itemSearched);
      notifyListeners();
    } catch (err) {
      //print(err);
      //print("hello1");
    }
  }
}
