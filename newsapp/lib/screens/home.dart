import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart'; //for random method

import '../providers/newsprovider.dart';
import '../screens/category.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//Making list for the things that will be shwn in the slideshow using the package caroseal slider
  // List sliderItems = [Colors.yellow, Colors.blue, Colors.red, Colors.grey];
  var _isShowmore = false;
  var _isLoading1 = true;
  var _isLoading2 = true; //for slider news
  var _hasFetcheddata = false;
  TextEditingController searchTextController = TextEditingController();
  // business entertainment general health science sports technology
  List<String> topics = [
    "Business",
    "India",
    "Entertainment",
    "Sports",
    "Health",
    "General",
    "Technology",
    "Science",
  ]; //will use this in our navigation bar
  void onSearched(String val) {
    print(val);
  }

  @override
  void didChangeDependencies() {
    //since did change runs more than once before build to have to give this hsfetched condition too
    if (_hasFetcheddata == false) {
      setState(() {
        _isLoading1 = true;
        _isLoading2 = true;
      });
      Provider.of<newsProvider>(context).fetchNews("general").then((_) {
        setState(() {
          _isLoading1 =
              false; //in .then function only as we will make loading false only after the getting of data is finished..ie now we can stop shoeing the loading spinner (not using async await...in didChangeDependency and initstate like these functions as we should hinder with what they return)
        });
      });

      Provider.of<newsProvider>(context, listen: false)
          .fetchCategoryNews("india")
          .then((_) {
        //one provider above is enough to listen for the chnages this is just to call the function and fetch data and when notify listerners is called then the above will listen to the changes
        setState(() {
          _isLoading2 = false;
        });
      });
    }
    _hasFetcheddata = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<newsProvider>(context, listen: false)
        .item; //getting the list once we have fetched the data
    var dataSlider = Provider.of<newsProvider>(context, listen: false)
        .itemCategory("india"); //getting the list once we have fetched the data

    var smalldataSlider = dataSlider.length >
            7 //if we have like 1000 items and we want only few then it is better to make contraint inside the for loop in the provider where we are fetching data ...because agar usse is tarike se krenge to uper vali list me sab kuch store hoga and that will take a lot of memory
        ? dataSlider.sublist(1, 7)
        : dataSlider; //so that if we have 30 or 40 news so we dont wan that many to keep showing in the slider thats why short listing it here
    //print(dataSlider[0].title);
    final List<String> genre = [
      "fashion",
      "tech",
      "sports",
      "entertainment",
      "cooking"
    ];
    final random = Random(); //creating instance of random class
    final String exgenre = genre[random.nextInt(genre.length)];
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Title(color: Colors.black, child: const Text("Zap News")),
          centerTitle: true, //will make title appear on center
        ),
        body: SingleChildScrollView(
          //making enire page scrllable
          child: Container(
            decoration: _isLoading2
                ? const BoxDecoration(color: Colors.transparent)
                : const BoxDecoration(
                    gradient: LinearGradient(
                        stops: [0, 0.4],
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
            child: Column(
              //1st cntainer-> search bar
              children: [
                Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black38),
                    child: Row(children: [
                      GestureDetector(
                        onTap: () {
                          onSearched("hello");
                        },
                        child: const Icon(Icons.search),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          //textfield should be kept in expanded if used inside a row
                          child: TextField(
                        onSubmitted: (str) {
                          onSearched(str);
                        },
                        controller:
                            searchTextController, //assigning controller and the text in extfield will be stored in this controller now
                        decoration: InputDecoration(
                            // label: Text("Search a place..."),
                            hintText:
                                "search some news eg, $exgenre", //this is a placeholder which fades away when we starts typing
                            border: InputBorder.none),
                        textInputAction: TextInputAction
                            .search, //will show the search icon in the keypad
                      )),
                    ])),

                //2nd column-> will have our horizontal nav bar
                Container(
                  height: 60,
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap:
                        true, //such that the contents of the list wrap will nly take that much space which is needed and dont try to fill the container parent's space if is extra
                    scrollDirection: Axis
                        .horizontal, //horizontal direction de di scroll ke liye
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              //not using push named as we want to pass a single value to the constructor of category
                              context,
                              MaterialPageRoute(
                                  builder: (context) => categoryScreen(
                                      category: topics[index].toLowerCase())));
                        },
                        child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            margin: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                border:
                                    Border.all(width: 3, color: Colors.black),
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              topics[index],
                              style: TextStyle(
                                color: Colors.blueGrey[900],
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      );
                    },
                    itemCount: topics.length,
                  ),
                ),

                //Making side show using coursel slider package that will be storing our news
                Container(
                  //color: Colors.green,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: _isLoading2
                      ? Container(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 18 / 10, //width to height ratio
                            enlargeCenterPage:
                                true, //the page which is in front gets enlarged
                            autoPlay:
                                true, //will be plaed aitomatically as well as can be scrlled manuall
                            enableInfiniteScroll: false,
                          ),
                          //items: sliderItems.map((item) {
                          //item is each item of ur list sliderIems...ie here in items we will have  return a list of the widgets hats why using map and making i a list and returning it
                          items: smalldataSlider.map((item) {
                            //this data is now containing maps(object or instanmce of newsData class) and each map is one news
                            try {
                              return Container(
                                // color: _isLoading2
                                //     ? Colors.transparent
                                //     : Colors.brown,
                                child: Card(
                                  child: Stack(
                                    children: [
                                      // Image.asset(
                                      //   "assets/images/try.jpg",
                                      Image.network(
                                        item.ImageToUrl,
                                        height: double.infinity,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      Positioned(
                                          //his tells the positioning of the child inside this over the children of the stack
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                              //margin: EdgeInsets.only(left: 10),
                                              padding: EdgeInsets.only(
                                                  left: 5, bottom: 15),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end:
                                                        Alignment.bottomCenter),
                                              ), //bottm righ was not having border radius even becuase of its parent's radius so have to do it manually
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.title,
                                                      //"hello",
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ])))
                                    ],
                                  ),
                                ),
                              );
                            } catch (e) {
                              print(e);
                              return Container(); //if there is some problem in this particular slide due to some api error or anything it will not be displayed because of try block and we will return an empty container in catch for that
                            }
                          }).toList(),
                        ),
                ),

                //making a listview builder that will show news from network image (3rd container)
                Container(
                  decoration: BoxDecoration(
                      color: _isLoading1 ? Colors.transparent : Colors.black,
                      border: const Border(
                          top: BorderSide(width: 2, color: Colors.white70))),
                  child: _isLoading1
                      ? Container(
                          height: 400,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          children: [
                            //will show a text saying current news:-
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              margin: EdgeInsets.only(left: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "LATEST NEWS",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              itemBuilder: (ctx, index) {
                                try {
                                  //handling for any errors in displaying this too
                                  return Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        color: Colors.red),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            child:
                                                // Image.asset(
                                                //   "assets/images/try.jpg",

                                                Image.network(
                                              data[index].ImageToUrl,
                                              height: double.infinity,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          Positioned(
                                            //his tells the positioning of the child inside this over the children of the stack
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 5, bottom: 15),
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black
                                                              .withOpacity(0),
                                                          Colors.black
                                                        ],
                                                        begin: Alignment
                                                            .bottomLeft,
                                                        end: Alignment
                                                            .bottomRight),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    13))), //bottm righ was not having border radius even becuase of its parent's radius so have to do it manually
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data[index].title,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                        data[index]
                                                                    .title
                                                                    .length >
                                                                55
                                                            ? "${data[index].desc.substring(0, 56)}..."
                                                            : data[index]
                                                                .desc, //if length of the decs is more than 55 characters then dont show the whole and only show till 56 ...otherwise show the full if its kength is less than 55
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white54))
                                                  ],
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  print(e);
                                  return Container();
                                }
                              },
                              itemCount: data.length > 5
                                  ? _isShowmore
                                      ? data.length < 10
                                          ? data.length
                                          : 10
                                      : 5
                                  : data.length,
                              physics:
                                  const NeverScrollableScrollPhysics(), //will nt use the scrlling feature of the listview rather will make he whole page scrllable ie body of home screen
                              shrinkWrap:
                                  true, //so nw we dont have to give an height r anything  he conainer binding this builder since i will take nl hat height which each return conainer will need
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: OutlinedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _isShowmore = !_isShowmore;
                                        });
                                      },
                                      icon: _isShowmore
                                          ? Icon(Icons.expand_less_outlined)
                                          : Icon(Icons.expand_more_sharp),
                                      label: _isShowmore
                                          ? Text("Show less")
                                          : Text("Show more")),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ));
  }
}
