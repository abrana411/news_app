import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/newsmodel.dart';
import 'package:provider/provider.dart';

import '../providers/newsprovider.dart';
import '../widgets/newsviews.dart';

class categoryScreen extends StatefulWidget {
  static final routeName = "/category";
  final String category;
  const categoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _categoryScreenState createState() => _categoryScreenState();
}

class _categoryScreenState extends State<categoryScreen> {
  var _isShowmore = false;
  var _isLoading = true;
  var _hasInitialized = false;
  @override
  void didChangeDependencies() {
    if (!_hasInitialized) //data is not yet fetched
    {
      setState(() {
        _isLoading = true;
      });

      Provider.of<newsProvider>(context)
          .fetchCategoryNews(widget.category, false)
          .then((val) {
        setState(() {
          _isLoading = false;
        });
      });
      _hasInitialized =
          true; //taki bs ek bar he initialize ho kyunki ye didChangeDependencies runs a few times before the build method
    }
    super.didChangeDependencies();
  }

  //mehod to make first character of a string capital and rest small
  String firstcharCap(String str) {
    return (str[0].toUpperCase() + str.substring(1).toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<newsProvider>(context, listen: false).itemCategory(
        widget.category); //getting the list of news of desired category
    return Scaffold(
      extendBodyBehindAppBar:
          true, //this make the content of body behind appbar too..and making it true as want to show rounded brder in appbar so...have to make color behind appbar same with body i will exend body from top itself

      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Title(
            color: Colors.black,
            child: Text(firstcharCap(widget.category) + " News")),
        centerTitle: true, //will make title appear on center
        shape: RoundedRectangleBorder(
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
        child: Container(
          decoration: _isLoading
              ? const BoxDecoration(color: Colors.transparent)
              : BoxDecoration(
                  gradient: LinearGradient(
                      // stops: [0, 0.9],
                      colors: [Colors.red.shade200, Colors.deepOrange.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  border:
                      Border(top: BorderSide(width: 2, color: Colors.white70))),
          child: _isLoading
              ? Container(
                  height: 400,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
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
                                        builder: (BuildContext context) => newsView(
                                            url: data[index]
                                                .UrltoMore))); //passing the url to the web view
                              },
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
                                          padding: EdgeInsets.only(
                                              left: 5, bottom: 15),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.orange.shade400
                                                        .withOpacity(0.5),
                                                    Colors.pink.shade400
                                                        .withOpacity(0.5)
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
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                  data[index].title.length > 55
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
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border:
                                  Border.all(width: 2, color: Colors.white54),
                              color: Colors.red),
                          child: TextButton.icon(
                            onPressed: () {
                              print("hello");
                              setState(() {
                                _isShowmore = !_isShowmore;
                              });
                            },
                            icon: _isShowmore
                                ? Icon(
                                    Icons.expand_less_outlined,
                                    color: Colors.amber,
                                  )
                                : Icon(
                                    Icons.expand_more_sharp,
                                    color: Colors.amber,
                                  ),
                            label: _isShowmore
                                ? Text(
                                    "Show Less",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                : Text(
                                    "Show More",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
