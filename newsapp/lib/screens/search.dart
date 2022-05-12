import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_plus/share_plus.dart';

import 'package:provider/provider.dart';
import '../providers/newsprovider.dart';
import '../widgets/newsviews.dart';

// ignore: camel_case_types
class searchScreen extends StatefulWidget {
  final String searchedText;
  const searchScreen({Key? key, required this.searchedText}) : super(key: key);

  @override
  _searchScreenState createState() => _searchScreenState();
}

// ignore: camel_case_types
class _searchScreenState extends State<searchScreen> {
  TextEditingController searchTextController = TextEditingController();
  var _isLoading = true;
  var _hasInitialized = false;

  @override
  void didChangeDependencies() {
    if (!_hasInitialized) {
      //print("ini");
      setState(() {
        _isLoading = true;
      });

      Provider.of<newsProvider>(context)
          .fetchCategoryNews(widget.searchedText, true)
          .then((val) {
        setState(() {
          _isLoading = false;
        });
      });

      _hasInitialized = true;
    }
    super.didChangeDependencies();
  }

  void onSearched() {
    if (searchTextController.text == "") //blank text
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Add Something to search news for",
              style: TextStyle(color: Colors.red))));
    } else {
      // searchTextController.text = "";
      setState(() {
        _isLoading =
            true; //have to manage lading again....when getting new data
      });
      Provider.of<newsProvider>(context,
              listen:
                  false) //not listening here as have the abve provider to listen to changes that will make he build of this to run
          .fetchCategoryNews(searchTextController.text.trim(), true)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void onShare(BuildContext context, String link) {
    Share.share(
      link,
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("built");
    final List<String> genre = [
      "fashion",
      "tech",
      "sports",
      "entertainment",
      "cooking"
    ];
    final random = Random(); //creating instance of random class
    final String exgenre = genre[random.nextInt(genre.length)];
    var data = Provider.of<newsProvider>(context, listen: false)
        .itemCategory(widget.searchedText, false);
    var _isvalidSearch = data.isEmpty
        ? false
        : true; //if we haven't got any news related to this then we will simply show an image or a message indicating no news related to particular seach perform
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.pink],
                    begin: Alignment.topRight,
                    end: Alignment.topLeft)),
            child: SingleChildScrollView(
              //have to make the column scrollable too ...otherwise it was have render problems
              child: Column(
                children: [
                  //search bar for further searches
                  Container(
                      height: 50,
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
                          onSubmitted: (str) {
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
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/");
                          },
                          child: const Icon(
                            Icons.home,
                            color: Colors.pink,
                          ),
                        )
                      ])),
                  //container showing all the news
                  if (_isLoading)
                    SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: const Center(
                          child: SpinKitSpinningLines(
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                      ),
                    ), //100 is the height of search bar
                  if (!_isLoading &&
                      !_isvalidSearch) //if loading is finished and even then the data isnot here then it means that there is no mews corresponding to the searched text
                    Stack(
                      //this stack will be shown if the above condition is met
                      children: [
                        Image.asset(
                          "assets/images/fail.png",
                          fit: BoxFit.fitHeight,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height - 50,
                        ),
                        Positioned(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            searchTextController.text == ""
                                ? "No news related to '${widget.searchedText}' :("
                                : "No news related to '${searchTextController.text}' :(",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        )),
                        Positioned(
                          right: 10,
                          bottom: 80,
                          child: FloatingActionButton(
                            child: const Icon(
                              Icons.home,
                            ),
                            backgroundColor: Colors.orange,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, "/");
                            },
                          ),
                        ),
                      ],
                    ),
                  if (!_isLoading &&
                      _isvalidSearch) //the below container will be shown if the loading is false but the data we get is valid
                    Container(
                      decoration: _isLoading
                          ? const BoxDecoration(color: Colors.transparent)
                          : BoxDecoration(
                              gradient: LinearGradient(
                                  // stops: [0, 0.9],
                                  colors: [
                                    Colors.red.shade300,
                                    Colors.deepOrange.shade300
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              border: const Border(
                                  top: BorderSide(
                                      width: 2, color: Colors.white70))),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            margin: const EdgeInsets.only(left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  searchTextController.text == ""
                                      ? "Latest News Related To '${widget.searchedText}'"
                                      : "Latest News Related To '${searchTextController.text}'",
                                  style: const TextStyle(
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
                                      color: Colors.pink),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  child: InkWell(
                                    //like gesture detector but also shows a ripple effect
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  newsView(
                                                      url: data[index]
                                                          .UrltoMore))); //passing the url to the web view
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                child:
                                                    // Image.asset(
                                                    //   "assets/images/try.jpg",
                                                    Stack(children: [
                                                  Image.network(
                                                    data[index].ImageToUrl,
                                                    height: double.infinity,
                                                    fit: BoxFit.fill,
                                                    width: double.infinity,
                                                    errorBuilder: (BuildContext
                                                            context, //if there is an error in showing the image then the widget inside his will be shown instead
                                                        Object exception,
                                                        StackTrace?
                                                            stackTrace) {
                                                      return Image.asset(
                                                        "assets/images/try.jpg",
                                                        height: double.infinity,
                                                        fit: BoxFit.fill,
                                                        width: double.infinity,
                                                      );
                                                    },
                                                  ),
                                                  Positioned(
                                                      top: 10,
                                                      right: 10,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          onShare(
                                                              context,
                                                              data[index]
                                                                  .UrltoMore);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black54,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          child: const Icon(
                                                            Icons.share,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ))
                                                ])),
                                            Positioned(
                                              //his tells the positioning of the child inside this over the children of the stack
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, bottom: 15),
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
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                          data[index]
                                                                      .title
                                                                      .length >
                                                                  55
                                                              ? "${data[index].desc.substring(0, 56)}..."
                                                              : data[
                                                                      index]
                                                                  .desc, //if length of the decs is more than 55 characters then dont show the whole and only show till 56 ...otherwise show the full if its kength is less than 55
                                                          style:
                                                              const TextStyle(
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
                            itemCount: data.length > 10 ? 10 : data.length,
                            physics:
                                const NeverScrollableScrollPhysics(), //will nt use the scrlling feature of the listview rather will make he whole page scrllable ie body of home screen
                            shrinkWrap:
                                true, //so nw we dont have to give an height r anything  he conainer binding this builder since i will take nl hat height which each return conainer will need
                          ),
                          Container(
                            //to give margin from bottom
                            margin: const EdgeInsets.only(bottom: 30),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
