import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart'; //for random method

import '../providers/newsprovider.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//Making list for the things that will be shwn in the slideshow using the package caroseal slider
  List sliderItems = [Colors.yellow, Colors.blue, Colors.red, Colors.grey];
  var _isLoading = true;
  var _hasFetcheddata = false;
  TextEditingController searchTextController = TextEditingController();
  List<String> topics = [
    "Top News",
    "Indian",
    "Economics",
    "Sports",
    "Health",
    "World"
  ]; //will use this in our navigation bar
  void onSearched(String val) {
    print(val);
  }

  @override
  void didChangeDependencies() {
    //since did change runs more than once before build to have to give this hsfetched condition too
    if (_hasFetcheddata == false) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<newsProvider>(context)
          .fetchNews("general", "india")
          .then((_) {
        setState(() {
          _isLoading =
              false; //in .then function only as we will make loading false only after the getting of data is finished..ie now we can stop shoeing the loading spinner (not using async await...in didChangeDependency and initstate like these functions as we should hinder with what they return)
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
        .itemSlider; //getting the list once we have fetched the data
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
                    return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          topics[index],
                          style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ));
                  },
                  itemCount: 5,
                ),
              ),

              //Making side show using coursel slider package that will be storing our news
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    enlargeCenterPage:
                        true, //the page which is in front gets enlarged
                    autoPlay:
                        true, //will be plaed aitomatically as well as can be scrlled manuall
                    enableInfiniteScroll: false,
                  ),
                  //items: sliderItems.map((item) {
                  //item is each item of ur list sliderIems...ie here in items we will have  return a list of the widgets hats why using map and making i a list and returning it
                  items: dataSlider.map((item) {
                    //this data is now containing maps(object or instanmce of newsData class) and each map is one news
                    return Container(
                      color: Colors.red,
                      child: Card(
                        child: Stack(
                          children: [
                            // Image.asset(
                            //   "assets/images/try.jpg",
                            Image.network(
                              item.ImageToUrl,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                //his tells the positioning of the child inside this over the children of the stack
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding:
                                        EdgeInsets.only(left: 5, bottom: 15),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0),
                                              Colors.black
                                            ],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.bottomRight),
                                        borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(
                                                13))), //bottm righ was not having border radius even becuase of its parent's radius so have to do it manually
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ])))
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              //making a listview builder that will show news from network image (3rd container)
              Container(
                color: Colors.black,
                child: Column(
                  children: [
                    //will show a text saying current news:-
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "LATEST NEWS",
                            style:
                                TextStyle(fontSize: 20, color: Colors.yellow),
                          ),
                        ),
                        Icon(Icons.arrow_downward_outlined,
                            size: 20, color: Colors.white),
                      ],
                    ),
                    ListView.builder(
                      itemBuilder: (ctx, index) {
                        return _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                height: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color: Colors.red),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
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
                                            margin: EdgeInsets.only(left: 10),
                                            padding: EdgeInsets.only(
                                                left: 5, bottom: 15),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.bottomRight),
                                                borderRadius: const BorderRadius
                                                        .only(
                                                    bottomRight: Radius.circular(
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
                                                    data[index].title.length >
                                                            55
                                                        ? "${data[index].desc.substring(0, 56)}..."
                                                        : data[index]
                                                            .desc, //if length of the decs is more than 55 characters then dont show the whole and only show till 56 ...otherwise show the full if its kength is less than 55
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white54))
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                      },
                      itemCount: data.length > 6 ? 6 : data.length,
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
                              onPressed: () {},
                              icon: Icon(Icons.expand_more_sharp),
                              label: Text("Show more")),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
