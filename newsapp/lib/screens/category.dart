import 'package:flutter/material.dart';
import 'package:newsapp/models/newsmodel.dart';
import 'package:provider/provider.dart';

import '../providers/newsprovider.dart';

class categoryScreen extends StatefulWidget {
  static final routeName = "/category";
  final String category;
  const categoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _categoryScreenState createState() => _categoryScreenState();
}

class _categoryScreenState extends State<categoryScreen> {
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
          .fetchCategoryNews(widget.category)
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

  @override
  Widget build(BuildContext context) {
    var _isShowmore = true;
    var data = Provider.of<newsProvider>(context, listen: false).itemCategory(
        widget.category); //getting the list of news of desired category
    return Scaffold(
      appBar: AppBar(
        title: Text("AB News"),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: _isLoading ? Colors.transparent : Colors.black,
              border: const Border(
                  top: BorderSide(width: 2, color: Colors.white70))),
          child: _isLoading
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
                      padding: const EdgeInsets.only(top: 10),
                      margin: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.category,
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
                                color: Colors.red),
                            margin: const EdgeInsets.symmetric(
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
                                        padding: EdgeInsets.only(
                                            left: 5, bottom: 15),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black.withOpacity(0),
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
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white54))
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
                              ? data.length > 10
                                  ? 10
                                  : data.length
                              : data.length
                          : data
                              .length, //this is nested ternery..and  first iam checking if data.length is greter than 5 if it is then checking for show more variable..if its length is not greter than give just data.length...and in the showmore condition then if it is true then checking if data.length is greter than 10 then return 10 otherwise data.length and if show more is not active then too data.length
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
      ),
    );
  }
}
