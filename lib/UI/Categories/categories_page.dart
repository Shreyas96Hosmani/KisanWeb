import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/BannerEvents/event_page.dart';
import 'package:kisanweb/UI/Categories/productsFound.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/Tabs/HomeTab.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  final event_id, title, id;

  CategoriesPage(this.event_id,this.title, this.id);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _isloaded = false;

  bool _isSearchBarOpen = false;
  TextEditingController searchTextController = new TextEditingController();

  FocusNode focusSearch = FocusNode();

  Future<void> initTask() async {
    setState(() {
      _isloaded = false;
    });
    Provider.of<CustomViewModel>(context, listen: false)
        .GetSubCategories(widget.event_id, widget.id)
        .then((value) {
      setState(() {
        if (value == "error") {
        } else if (value == "success") {
          _isloaded = true;
        } else {}
      });
    });
    Provider.of<CustomViewModel>(context, listen: false)
        .GetAdsForCategorySlider(widget.event_id,widget.id);
  }

  Future<void> _SearchSubCategories(String text) async {
    Provider.of<CustomViewModel>(context, listen: false)
        .SearchSubCategories(text);
  }

  @override
  void initState() {
    super.initState();
    initTask();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_isSearchBarOpen == true) {
      setState(() {
        _isSearchBarOpen = false;
        searchTextController.clear();
      });
      Provider.of<CustomViewModel>(context, listen: false)
          .SearchSubCategories("");
    } else {
      pop(context);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

    return _isloaded == true
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: ResponsiveWidget.isSmallScreen(context) ? PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: _isSearchBarOpen == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                width: 55,
                                height: 55,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: () {
                                  if (_isSearchBarOpen == true) {
                                    setState(() {
                                      _isSearchBarOpen = false;
                                      searchTextController.clear();
                                    });
                                    Provider.of<CustomViewModel>(context,
                                            listen: false)
                                        .SearchSubCategories("");
                                  } else {
                                    pop(context);
                                  }
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: getProportionateMobileScreenWidth(10),
                            ),
                            Container(
                              width: getProportionateMobileScreenWidth(240),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      widget.title.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    (providerListener.subcategoryCouts
                                                    .products ??
                                                0)
                                            .toString() +
                                        " " +
                                        getTranslated(context, 'products')
                                            .toString() +
                                        " | " +
                                        (providerListener.subcategoryCouts
                                                    .companies ??
                                                0)
                                            .toString() +
                                        " " +
                                        getTranslated(context, 'companies')
                                            .toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                width: 55,
                                height: 55,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    //padding: EdgeInsets.symmetric(horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: () {
                                  setState(() {
                                    _isSearchBarOpen = true;
                                    focusSearch.requestFocus();
                                  });
                                },
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                focusNode: focusSearch,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 14),
                                decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  fillColor: Colors.grey.shade100,
                                  prefixIcon: InkWell(
                                    onTap: () {
                                      if (_isSearchBarOpen == true) {
                                        setState(() {
                                          _isSearchBarOpen = false;
                                          searchTextController.clear();
                                        });
                                        Provider.of<CustomViewModel>(context,
                                                listen: false)
                                            .SearchSubCategories("");
                                      } else {
                                        pop(context);
                                      }
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ),
                                  suffixIconConstraints:
                                      BoxConstraints.tightFor(height: 50),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        searchTextController.clear();
                                      });
                                      _SearchSubCategories("");
                                    },
                                    child: Padding(
                                        padding:
                                            EdgeInsetsDirectional.only(end: 10),
                                        child: Icon(
                                          Icons.clear,
                                          size: 30,
                                        )),
                                  ),
                                ),
                                /*onChanged: (value) {

                                },*/
                                onEditingComplete: () {
                                  _SearchSubCategories(
                                      searchTextController.text.toString());
                                  focusSearch.unfocus();
                                },
                                controller: searchTextController,
                              ),
                            )
                          ],
                        ),
                ),
              ),
            )
                : PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 200),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: _isSearchBarOpen == false
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          width: 55,
                          height: 55,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding:
                              EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15))),
                          onPressed: () {
                            if (_isSearchBarOpen == true) {
                              setState(() {
                                _isSearchBarOpen = false;
                                searchTextController.clear();
                              });
                              Provider.of<CustomViewModel>(context,
                                  listen: false)
                                  .SearchSubCategories("");
                            } else {
                              pop(context);
                            }
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: getProportionateScreenWidth(240),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                widget.title.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              (providerListener.subcategoryCouts
                                  .products ??
                                  0)
                                  .toString() +
                                  " " +
                                  getTranslated(context, 'products')
                                      .toString() +
                                  " | " +
                                  (providerListener.subcategoryCouts
                                      .companies ??
                                      0)
                                      .toString() +
                                  " " +
                                  getTranslated(context, 'companies')
                                      .toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          width: 55,
                          height: 55,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              //padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15))),
                          onPressed: () {
                            setState(() {
                              _isSearchBarOpen = true;
                              focusSearch.requestFocus();
                            });
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      Container(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          focusNode: focusSearch,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14),
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            fillColor: Colors.grey.shade100,
                            prefixIcon: InkWell(
                              onTap: () {
                                if (_isSearchBarOpen == true) {
                                  setState(() {
                                    _isSearchBarOpen = false;
                                    searchTextController.clear();
                                  });
                                  Provider.of<CustomViewModel>(context,
                                      listen: false)
                                      .SearchSubCategories("");
                                } else {
                                  pop(context);
                                }
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            suffixIconConstraints:
                            BoxConstraints.tightFor(height: 50),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchTextController.clear();
                                });
                                _SearchSubCategories("");
                              },
                              child: Padding(
                                  padding:
                                  EdgeInsetsDirectional.only(end: 10),
                                  child: Icon(
                                    Icons.clear,
                                    size: 30,
                                  )),
                            ),
                          ),
                          /*onChanged: (value) {

                                },*/
                          onEditingComplete: () {
                            _SearchSubCategories(
                                searchTextController.text.toString());
                            focusSearch.unfocus();
                          },
                          controller: searchTextController,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: ResponsiveWidget.isSmallScreen(context) ? EdgeInsets.symmetric(horizontal: 15) : EdgeInsets.symmetric(horizontal: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    providerListener.categoryAdsListImages.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: ImageSlider(),
                          )
                        : SizedBox(height: 1),
                    providerListener.searchedSubCategoryList.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: buildCategoryList(context),
                          )
                        : SizedBox(height: 1)
                  ],
                ),
              ),
            ),
          )
        : Container(
            height: SizeConfig.screenHeight,
            color: Colors.white,
            child: Center(
              child: new CircularProgressIndicator(
                strokeWidth: 1,
                backgroundColor: Color(COLOR_PRIMARY),
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
              ),
            ),
          );
  }


  buildCategoryList(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

    return ResponsiveWidget.isSmallScreen(context) ? ListView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: providerListener.searchedSubCategoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              List<int> ids = [];
              ids.add(providerListener.searchedSubCategoryList[index].id);
              push(
                context,
                productsFound(
                    widget.event_id,
                    providerListener.searchedSubCategoryList[index].name,
                    ids, 0),
              );
            },
            child: Container(
              width: screenWidth,
              height: 60,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xffF0F8F3),
                borderRadius: BorderRadius.all(Radius.circular(10)),
//                  boxShadow: [
//                    BoxShadow(color: Colors.grey[200], blurRadius: 1, spreadRadius: 1)
//                  ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 100,
                    //width: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        providerListener.searchedSubCategoryList[index].name,
                        style: GoogleFonts.poppins(
                          color: Color(0xff2DB571),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  /*Container(
                    width: getProportionateScreenWidth(50),
                    height: getProportionateScreenWidth(50),
                    decoration: BoxDecoration(
                        color: Colors.green[700],
                        image: DecorationImage(
                            image: NetworkImage(providerListener
                                    .searchedSubCategoryList[index].image ??
                                ""),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 10,
                  ),*/
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Color(0xff008940),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          );
        }): GridView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 370/70
        ),
        itemCount: providerListener.searchedSubCategoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              List<int> ids = [];
              ids.add(providerListener.searchedSubCategoryList[index].id);
              push(
                context,
                productsFound(
                    widget.event_id,
                    providerListener.searchedSubCategoryList[index].name,
                    ids, 0),
              );
            },
            child: Container(
              width: screenWidth,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xffF0F8F3),
                borderRadius: BorderRadius.all(Radius.circular(10)),
//                  boxShadow: [
//                    BoxShadow(color: Colors.grey[200], blurRadius: 1, spreadRadius: 1)
//                  ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 100,
                    width: 170,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      providerListener.searchedSubCategoryList[index].name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Color(0xff2DB571),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Spacer(),
                  /*Container(
                    width: getProportionateScreenWidth(50),
                    height: getProportionateScreenWidth(50),
                    decoration: BoxDecoration(
                        color: Colors.green[700],
                        image: DecorationImage(
                            image: NetworkImage(providerListener
                                    .searchedSubCategoryList[index].image ??
                                ""),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 10,
                  ),*/
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Color(0xff008940),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          );
        }) ;
  }
}

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
                onPageChanged: (index, onTap) {
                  setState(() {
                    currentS = index;
                  });
                  print(currentS.toString());
                },
                height: 200,
                autoPlay: true,
                viewportFraction: 1,
                autoPlayAnimationDuration: Duration(milliseconds: 700)),
            items: providerListener.categoryAdsListImages.map((url) {
              int index = providerListener.categoryAdsListImages.indexOf(url);
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      if (providerListener.categoryAdsList[index].link_for ==
                          "Event") {
                        push(
                            context,
                            BannerEventPage(providerListener
                                    .categoryAdsList[index].linking_id ??
                                0));
                      } else if (providerListener
                              .categoryAdsList[index].link_for ==
                          "Product") {
                        push(
                            context,
                            DetailedProducts(
                                providerListener
                                    .categoryAdsList[index].linking_id,
                                providerListener
                                    .categoryAdsList[index].organisation_id));
                      }
                    },
                    child: Container(
                      width: getProportionateScreenWidth(378),
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: NetworkImage(url), fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[200],
                              offset: const Offset(
                                2.0,
                                3.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            )
                          ],
                          color: Colors.green),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: providerListener.categoryAdsListImages.map((url) {
                  int index =
                      providerListener.categoryAdsListImages.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          currentS == index ? Colors.green : Colors.grey[300],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
