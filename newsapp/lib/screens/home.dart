import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart'; //for random method

import '../providers/newsprovider.dart';
import '../screens/category.dart';
import '../screens/search.dart';
import '../widgets/newsviews.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

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
    "Entertainment",
    "Sports",
    "Health",
    "General",
    "Technology",
    "Science",
  ]; //will use this in our navigation bar
  void onSearched() {
    if (searchTextController.text == "") //blank text
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Add Something to search news for",
              style: TextStyle(color: Colors.red))));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => searchScreen(
                  searchedText: searchTextController.text.trim())));
    }
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
          .fetchCategoryNews("india", false)
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
        extendBodyBehindAppBar:
            true, //this make the content of body behind appbar too..and making it true as want to show rounded brder in appbar so...have to make color behind appbar same with body i will exend body from top itself

        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Title(color: Colors.black, child: const Text("Ab News")),
          centerTitle: true, //will make title appear on center
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          flexibleSpace: Container(
            //to give gradient we can use flexible
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.pink],
                    begin: Alignment.topRight,
                    end: Alignment.topLeft)),
          ),
        ),
        body: SingleChildScrollView(
          //making enire page scrllable
          child: Container(
            decoration: _isLoading2
                ? const BoxDecoration(color: Colors.transparent)
                : BoxDecoration(
                    gradient: LinearGradient(stops: const [
                      0,
                      0.2
                    ], colors: [
                      Colors.pinkAccent.shade100,
                      Colors.redAccent.shade200
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
            child: Column(
              //1st cntainer-> search bar
              children: [
                const SizedBox(
                  //therwise it will be behind appbar since i made he body look behind appbar too
                  height: 92,
                ),
                Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Row(children: [
                      GestureDetector(
                        onTap: () {
                          onSearched();
                        },
                        child: const Icon(Icons.search),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          //textfield should be kept in expanded if used inside a row
                          child: TextField(
                        onSubmitted: (val) {
                          onSearched();
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
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.red.shade900)),
                  height: 70,
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
                                color: Colors.amber[300],
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
                      ? const SizedBox(
                          height: 150,
                          child: Center(
                            child: SpinKitSpinningLines(
                              color: Colors.black,
                              size: 50.0,
                            ),
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
                              return InkWell(
                                //like gesture detector but also shows a ripple effect
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              newsView(
                                                  url: item
                                                      .UrltoMore))); //passing the url to the web view
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Stack(
                                    children: [
                                      // Image.asset(
                                      //   "assets/images/try.jpg",
                                      //item.ImageToUrl.substring(1, 5) != "http"
                                      //   ?
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.white,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          child: Image.network(
                                            item.ImageToUrl,
                                            height: double.infinity,
                                            fit: BoxFit.fitHeight,
                                            errorBuilder: (BuildContext
                                                    context, //if there is an error in showing the image then the widget inside his will be shown instead
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                "assets/images/try.jpg",
                                                height: double.infinity,
                                                fit: BoxFit.fill,
                                                width: double.infinity,
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      // : Image.asset(
                                      //     "assets/images/fail.png"),
                                      Positioned(
                                          //his tells the positioning of the child inside this over the children of the stack
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                              //margin: EdgeInsets.only(left: 10),
                                              padding: const EdgeInsets.only(
                                                  left: 5, bottom: 15),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.orange
                                                          .withOpacity(0.7),
                                                      Colors.pink
                                                          .withOpacity(0.5)
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
                              //print(e);
                              //print("abab");
                              return Container(); //if there is some problem in this particular slide due to some api error or anything it will not be displayed because of try block and we will return an empty container in catch for that
                            }
                          }).toList(),
                        ),
                ),

                //making a listview builder that will show news from network image (3rd container)
                Container(
                  decoration: _isLoading1
                      ? const BoxDecoration(color: Colors.transparent)
                      : BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.deepOrangeAccent.shade200,
                                Colors.pink.shade500
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          border: const Border(
                              top:
                                  BorderSide(width: 2, color: Colors.white70))),
                  child: _isLoading1
                      ? const SizedBox(
                          height: 400,
                          child: Center(
                            child: SpinKitSpinningLines(
                              color: Colors.black,
                              size: 50.0,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            //will show a text saying current news:-
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              margin: const EdgeInsets.only(left: 20),
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
                                  Icon(
                                    Icons.fiber_new_outlined,
                                    color: Colors.white,
                                  )
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
                                        color: Colors.green),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: InkWell(
                                      //like gesture detector but also shows a ripple effect
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    newsView(
                                                        url: data[index]
                                                            .UrltoMore))); //passing the url to the web view
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(13),
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
                                                  fit: BoxFit.fill,
                                                  width: double.infinity,
                                                  errorBuilder: (BuildContext
                                                          context, //if there is an error in showing the image then the widget inside his will be shown instead
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                      "assets/images/try.jpg",
                                                      height: double.infinity,
                                                      fit: BoxFit.fill,
                                                      width: double.infinity,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                //his tells the positioning of the child inside this over the children of the stack
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            bottom: 15),
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            colors: [
                                                              Colors.green
                                                                  .withOpacity(
                                                                      0.5),
                                                              Colors.blue
                                                            ],
                                                            begin: Alignment
                                                                .bottomLeft,
                                                            end: Alignment
                                                                .bottomRight),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        13))), //bottm righ was not having border radius even becuase of its parent's radius so have to do it manually
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data[index].title,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
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
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white54))
                                                      ],
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  //print(e);
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: OutlinedButton.icon(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.deepOrange)),
                                        onPressed: () {
                                          setState(() {
                                            _isShowmore = !_isShowmore;
                                          });
                                        },
                                        icon: _isShowmore
                                            ? const Icon(
                                                Icons.expand_less_outlined,
                                                color: Colors.purple,
                                              )
                                            : const Icon(
                                                Icons.expand_more_sharp,
                                                color: Colors.purple,
                                              ),
                                        label: _isShowmore
                                            ? const Text("Show less",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))
                                            : const Text("Show more",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                      )),
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
