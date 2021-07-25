import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/BannerEvents/event_page.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/Tabs/HomeTab.dart';
import 'package:kisanweb/UI/Webinars/webinar_main_screen.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';

String search_string = "";
String language = "";
String min_scheduled_date = "";
String max_scheduled_date = "";
String category = "";

List<String> recencyTitle = ['Today', 'Tomorrow', 'This week'];
List<String> recencyDate = [];

// List<String> recencyLang = ["English", "Marathi", "हिंदी", "Konkani"];
//List<String> recencyLangFirstChar = ["A", "म", "अ", "K"];

List<String> ids = [];
List<String> langSelected = [];
int dateSelected = -1;
int pageCountW = 1;
bool isLoadingW = false;

int pageCountMW = 1;
bool isLoadingMW = false;

var formatter = new DateFormat('yyyy-MM-dd');

var now, nowTomorrow, nowLastDay;
bool _isFilApplied = false;

class ViewAllWebinars extends StatefulWidget {
  final tab;
  final _isMyWebinarOpen;
  final user_id;

  ViewAllWebinars(this.tab, this._isMyWebinarOpen, this.user_id);

  @override
  _ViewAllWebinarsState createState() => _ViewAllWebinarsState();
}

class _ViewAllWebinarsState extends State<ViewAllWebinars> {
  bool _isloaded = false;
  bool _isSearchBarOpen = false;
  bool _isMyWebinarOpen = false;

  TextEditingController searchTextController = new TextEditingController();

  FocusNode focusSearch = FocusNode();

  Future<void> initTask(bool _isMyWebinarOpen) async {
    setState(() {
      _isMyWebinarOpen = _isMyWebinarOpen;
      ids.clear();
      langSelected.clear();
      dateSelected = -1;
      _isloaded = false;
      search_string = "";
      language = "";
      min_scheduled_date = "";
      max_scheduled_date = "";
      category = "";

      pageCountW = 1;
      isLoadingW = false;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .GetWebinarList(search_string, language, min_scheduled_date,
            max_scheduled_date, category)
        .then((value) {
      setState(() {
        if (value == "error") {
        } else if (value == "success") {
          Provider.of<CustomViewModel>(context, listen: false)
              .GetEventFilters()
              .then((value) {
            setState(() {
              if (value == "error") {
              } else if (value == "success") {
                _isloaded = true;
              } else {}
            });
          });
        } else {}
      });
    });
    widget._isMyWebinarOpen == true
        ? myWebinarsList(widget.user_id)
        : print("false");
  }

  Future<void> SearchWebinarsInList() {
    setState(() {
      _isloaded = false;
      pageCountW = 1;
      isLoadingW = false;
    });
    Provider.of<CustomViewModel>(context, listen: false)
        .GetWebinarList(searchTextController.text ?? "", language,
            min_scheduled_date, max_scheduled_date, category)
        .then((value) {
      setState(() {
        if (value == "error") {
        } else if (value == "success") {
          Provider.of<CustomViewModel>(context, listen: false)
              .GetEventFilters()
              .then((value) {
            setState(() {
              if (value == "error") {
              } else if (value == "success") {
                _isloaded = true;
              } else {}
            });
          });
        } else {}
      });
    });
  }

  Future<void> _AppendWebinarList() {
    setState(() {
      isLoadingW = true;
      pageCountW = pageCountW + 1;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .AppendWebinarList(searchTextController.text ?? "", language,
            min_scheduled_date, max_scheduled_date, category, pageCountW)
        .then((value) {
      setState(() {
        isLoadingW = false;
        /* if (value == "No more items") {
                toastCommon(context, "No more items!");
              }*/
      });
    });
  }

  Future<void> _AppendMyWebinarList() {
    setState(() {
      isLoadingMW = true;
      pageCountMW = pageCountMW + 1;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .AppendMyWebinarList(widget.user_id, pageCountMW)
        .then((value) {
      setState(() {
        isLoadingMW = false;
        /*if (value == "No more items") {
                toastCommon(context, "No more items!");
              }*/
      });
    });
  }

  Future<void> myWebinarsList(String user_id) async {
    setState(() {
      _isloaded = false;
      pageCountMW = 1;
      isLoadingMW = false;
    });
    Provider.of<CustomViewModel>(context, listen: false)
        .GetMyWebinarList(user_id)
        .then((value) {
      setState(() {
        _isloaded = true;
        _isMyWebinarOpen = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initTask(widget._isMyWebinarOpen);
    if (widget.tab == "push") BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    if (widget.tab == "push") BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_isSearchBarOpen == true) {
      setState(() {
        _isSearchBarOpen = false;
        searchTextController.clear();
      });
      SearchWebinarsInList();
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
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: _isSearchBarOpen == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                widget.tab == "push"
                                    ? ConstrainedBox(
                                        constraints: BoxConstraints.tightFor(
                                          width: 55,
                                          height: 55,
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                          onPressed: () {
                                            if (_isSearchBarOpen == true) {
                                              setState(() {
                                                _isSearchBarOpen = false;
                                                searchTextController.clear();
                                              });
                                              SearchWebinarsInList();
                                            } else {
                                              pop(context);
                                            }
                                          },
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 1,
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        _isMyWebinarOpen == false
                                            ? getTranslated(context, 'webinars')
                                            : getTranslated(
                                                context, 'my_webinars'),
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      (_isMyWebinarOpen == false
                                                  ? (providerListener
                                                          .webinarListViewAll
                                                          .length ??
                                                      0)
                                                  : (providerListener
                                                          .MyWebinarList
                                                          .length ??
                                                      0))
                                              .toString() +
                                          " " +
                                          getTranslated(context, 'webinars')
                                              .toString(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _isFilApplied == true
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isMyWebinarOpen = false;
                                            _isFilApplied = false;
                                          });
                                          initTask(widget._isMyWebinarOpen);
                                        },
                                        child: Stack(
                                          children: [
                                            Icon(
                                              FlutterIcons.filter_ant,
                                              color: Colors.grey,
                                              size: 25,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3)),
                                                  color: Colors.red,
                                                ),
                                                padding: EdgeInsets.all(0),
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isMyWebinarOpen = false;
                                          });
                                          push(context, WebinarFiliter());
                                        },
                                        child: Icon(
                                          FlutterIcons.filter_ant,
                                          color: Colors.grey,
                                          size: 25,
                                        ),
                                      ),
                                SizedBox(
                                  width: 25,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isMyWebinarOpen = true;
                                    });
                                    myWebinarsList(providerListener
                                        .userprofileData.user
                                        .toString());
                                  },
                                  child: Icon(
                                    FlutterIcons.calendar_ant,
                                    color: _isMyWebinarOpen == true
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isMyWebinarOpen = false;
                                      _isSearchBarOpen = true;
                                      focusSearch.requestFocus();
                                    });
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      : Container(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            textAlignVertical: TextAlignVertical.bottom,
                            focusNode: focusSearch,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 14),
                            decoration: InputDecoration(
                              hintText: _isFilApplied == true
                                  ? "Search In applied filters"
                                  : "Search In all webinars",
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
                                    SearchWebinarsInList();
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
                                  BoxConstraints.tightFor(height: 40),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchTextController.clear();
                                  });
                                  // SearchWebinarsInList("");
                                },
                                child: Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(end: 20),
                                    child: Icon(
                                      Icons.clear,
                                      size: 30,
                                    )),
                              ),
                            ),
                            /*onChanged: (value) {

                                },*/
                            onEditingComplete: () {
                              SearchWebinarsInList();
                              focusSearch.unfocus();
                            },
                            controller: searchTextController,
                          ),
                        ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: _isMyWebinarOpen == false
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isFilApplied == false && _isSearchBarOpen == false
                            ? providerListener.featuredeventList.length > 0
                                ? ImageSlider()
                                : SizedBox(
                                    height: 1,
                                  )
                            : SizedBox(
                                height: 1,
                              ),
                        SizedBox(
                          height: 15,
                        ),
                        providerListener.webinarListViewAll.length > 0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: buildWebinarList(context),
                              )
                            : SizedBox(height: 1)
                      ],
                    )
                  : providerListener.MyWebinarList.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 0, top: 10, bottom: 100),
                          child: buildMyWebinarList(context),
                        )
                      : SizedBox(
                          height: 1,
                        ),
            ),
            floatingActionButton: _isMyWebinarOpen == false
                ? providerListener.canLoadMoreWebinar == true
                    ? Container(
                        padding: EdgeInsets.only(bottom: 100.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              _AppendWebinarList();
                            },
                            backgroundColor: Color(COLOR_BACKGROUND),
                            label: Text(
                              isLoadingW == false ? "Load more" : "Loading...",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    : null
                : providerListener.canLoadMoreMyWebinar == true
                    ? Container(
                        padding: EdgeInsets.only(bottom: 100.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              _AppendMyWebinarList();
                            },
                            backgroundColor: Color(COLOR_BACKGROUND),
                            label: Text(
                              isLoadingMW == false ? "Load more" : "Loading...",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
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

  buildWebinarList(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

    return ResponsiveWidget.isSmallScreen(context) ? ListView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: providerListener.webinarListViewAll.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              push(
                  context,
                  WebinarMainScreen(
                      providerListener.webinarListViewAll[index].id));
            },
            child: Container(
              height: 220,
              margin: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(20),
                  right: getProportionateScreenWidth(20)),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                )
              ]),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                            color: Colors.green[700],
                            image: DecorationImage(
                                image: NetworkImage(providerListener
                                        .webinarListViewAll[index]
                                        .image_path_medium ??
                                    ""),
                                fit: BoxFit.fitWidth),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15))),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent
                              ])
                              // image: DecorationImage()
                              ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: CompanyName(
                          smallthumb_url: providerListener
                              .webinarListViewAll[index].image_bigthumb_url,
                          organisation_name: providerListener
                              .webinarListViewAll[index].organisation_name,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFFFEE6C)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                providerListener
                                    .webinarListViewAll[index].scheduled_date
                                    .substring(providerListener
                                            .webinarListViewAll[index]
                                            .scheduled_date
                                            .length -
                                        2),
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    height: 1.3,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat.MMM()
                                    .format(DateTime.parse(providerListener
                                        .webinarListViewAll[index]
                                        .scheduled_date))
                                    .toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  utf8.decode((providerListener
                                              .webinarListViewAll[index]
                                              .title ??
                                          "")
                                      .runes
                                      .toList()),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              DateFormat.EEEE()
                                      .format(DateTime.parse(providerListener
                                          .webinarListViewAll[index]
                                          .scheduled_date))
                                      .toString() +
                                  ", " +
                                  (DateFormat.jm().format(DateFormat("hh:mm:ss")
                                          .parse(providerListener
                                              .webinarListViewAll[index]
                                              .scheduled_time)))
                                      .toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: getProportionateScreenWidth(40),
                          height: getProportionateScreenWidth(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Image.asset(
                              "assets/images/filter/" +
                                      providerListener
                                          .webinarListViewAll[index].language +
                                      ".png" ??
                                  "",
                              fit: BoxFit.contain),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }) :
    GridView.builder(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,mainAxisSpacing: 20,crossAxisSpacing: 20,childAspectRatio:1.6),
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: providerListener.webinarListViewAll.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              push(
                  context,
                  WebinarMainScreen(
                      providerListener.webinarListViewAll[index].id));
            },
            child: Container(
              height: 220,
              /*margin: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(20),
                  right: getProportionateScreenWidth(20))*/
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                )
              ]),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                            color: Colors.green[700],
                            image: DecorationImage(
                                image: NetworkImage(providerListener
                                    .webinarListViewAll[index]
                                    .image_path_medium ??
                                    ""),
                                fit: BoxFit.fitWidth),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15))),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent
                                  ])
                            // image: DecorationImage()
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: CompanyName(
                          smallthumb_url: providerListener
                              .webinarListViewAll[index].image_bigthumb_url,
                          organisation_name: providerListener
                              .webinarListViewAll[index].organisation_name,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFFFEE6C)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                providerListener
                                    .webinarListViewAll[index].scheduled_date
                                    .substring(providerListener
                                    .webinarListViewAll[index]
                                    .scheduled_date
                                    .length -
                                    2),
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    height: 1.3,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat.MMM()
                                    .format(DateTime.parse(providerListener
                                    .webinarListViewAll[index]
                                    .scheduled_date))
                                    .toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 180,
                              child: Text(
                                utf8.decode((providerListener
                                    .webinarListViewAll[index]
                                    .title ??
                                    "")
                                    .runes
                                    .toList()),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              DateFormat.EEEE()
                                  .format(DateTime.parse(providerListener
                                  .webinarListViewAll[index]
                                  .scheduled_date))
                                  .toString() +
                                  ", " +
                                  (DateFormat.jm().format(DateFormat("hh:mm:ss")
                                      .parse(providerListener
                                      .webinarListViewAll[index]
                                      .scheduled_time)))
                                      .toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: getProportionateScreenWidth(40),
                          height: getProportionateScreenWidth(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Image.asset(
                              "assets/images/filter/" +
                                  providerListener
                                      .webinarListViewAll[index].language +
                                  ".png" ??
                                  "",
                              fit: BoxFit.contain),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  buildMyWebinarList(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

    return ResponsiveWidget.isSmallScreen(context)
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            itemCount: providerListener.MyWebinarList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  push(
                      context,
                      WebinarMainScreen(
                          providerListener.MyWebinarList[index].id));
                },
                child: Container(
                  height: 220,
                  /*margin: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(20),
                      right: getProportionateScreenWidth(20)),*/
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    )
                  ]),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                                color: Colors.green[700],
                                image: DecorationImage(
                                    image: NetworkImage(providerListener
                                            .MyWebinarList[index]
                                            .image_path_medium ??
                                        ""),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15))),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent
                                  ])
                                  // image: DecorationImage()
                                  ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: CompanyName(
                              smallthumb_url: providerListener
                                  .MyWebinarList[index].image_path_small,
                              organisation_name: providerListener
                                  .MyWebinarList[index].organisation_name,
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xFFFFEE6C)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    providerListener
                                        .MyWebinarList[index].scheduled_date
                                        .substring(providerListener
                                                .MyWebinarList[index]
                                                .scheduled_date
                                                .length -
                                            2),
                                    style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        height: 1.3,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat.MMM()
                                        .format(DateTime.parse(providerListener
                                            .MyWebinarList[index]
                                            .scheduled_date))
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      utf8.decode((providerListener
                                                  .MyWebinarList[index].title ??
                                              "")
                                          .runes
                                          .toList()),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  DateFormat.EEEE()
                                          .format(DateTime.parse(
                                              providerListener
                                                  .MyWebinarList[index]
                                                  .scheduled_date))
                                          .toString() +
                                      ", " +
                                      (DateFormat.jm().format(
                                              DateFormat("hh:mm:ss").parse(
                                                  providerListener
                                                      .MyWebinarList[index]
                                                      .scheduled_time)))
                                          .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 10, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: getProportionateScreenWidth(40),
                              height: getProportionateScreenWidth(40),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Image.asset(
                                  "assets/images/filter/" +
                                          providerListener
                                              .MyWebinarList[index].language +
                                          ".png" ??
                                      "",
                                  fit: BoxFit.contain),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
        : GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            itemCount: providerListener.MyWebinarList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  push(
                      context,
                      WebinarMainScreen(
                          providerListener.MyWebinarList[index].id));
                },
                child: Container(
                  height: 220,
                  /*margin: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(20),
                  right: getProportionateScreenWidth(20)),*/
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    )
                  ]),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                                color: Colors.green[700],
                                image: DecorationImage(
                                    image: NetworkImage(providerListener
                                            .MyWebinarList[index]
                                            .image_path_medium ??
                                        ""),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15))),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent
                                  ])
                                  // image: DecorationImage()
                                  ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: CompanyName(
                              smallthumb_url: providerListener
                                  .MyWebinarList[index].image_path_small,
                              organisation_name: providerListener
                                  .MyWebinarList[index].organisation_name,
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xFFFFEE6C)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    providerListener
                                        .MyWebinarList[index].scheduled_date
                                        .substring(providerListener
                                                .MyWebinarList[index]
                                                .scheduled_date
                                                .length -
                                            2),
                                    style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        height: 1.3,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat.MMM()
                                        .format(DateTime.parse(providerListener
                                            .MyWebinarList[index]
                                            .scheduled_date))
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      utf8.decode((providerListener
                                                  .MyWebinarList[index].title ??
                                              "")
                                          .runes
                                          .toList()),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  DateFormat.EEEE()
                                          .format(DateTime.parse(
                                              providerListener
                                                  .MyWebinarList[index]
                                                  .scheduled_date))
                                          .toString() +
                                      ", " +
                                      (DateFormat.jm().format(
                                              DateFormat("hh:mm:ss").parse(
                                                  providerListener
                                                      .MyWebinarList[index]
                                                      .scheduled_time)))
                                          .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 10, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: getProportionateScreenWidth(40),
                              height: getProportionateScreenWidth(40),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Image.asset(
                                  "assets/images/filter/" +
                                          providerListener
                                              .MyWebinarList[index].language +
                                          ".png" ??
                                      "",
                                  fit: BoxFit.contain),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: 55,
        height: 55,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: 55,
        height: 55,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            //padding: EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          //push(context, SearchScreen());
        },
        child: Icon(
          Icons.search,
          color: Colors.black,
        ),
      ),
    );
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
                          color: Colors.amber),
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
                      color: currentS == index
                          ? Colors.grey[700]
                          : Colors.grey[300],
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

class WebinarFiliter extends StatefulWidget {
  @override
  _WebinarFiliterState createState() => _WebinarFiliterState();
}

class _WebinarFiliterState extends State<WebinarFiliter> {
  bool _isloaded = true;

  Future<void> initTask2() async {
    now = new DateTime.now();

    recencyDate.add(DateFormat.MMMEd()
        .format(DateTime.parse(DateFormat('yyyy-MM-dd').format(now).toString()))
        .toString());

    nowTomorrow = now.add(new Duration(days: 1));

    recencyDate.add(DateFormat.MMMEd()
        .format(DateTime.parse(
            DateFormat('yyyy-MM-dd').format(nowTomorrow).toString()))
        .toString());

    nowLastDay = now.add(new Duration(days: 6));

    recencyDate.add(DateFormat.MMMd()
            .format(
                DateTime.parse(DateFormat('yyyy-MM-dd').format(now).toString()))
            .toString() +
        " - " +
        DateFormat.MMMd()
            .format(DateTime.parse(
                DateFormat('yyyy-MM-dd').format(nowLastDay).toString()))
            .toString());
  }

  @override
  void initState() {
    super.initState();
    initTask2();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

    return _isloaded == true
        ? Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Container(
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 13)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        ids.clear();
                        langSelected.clear();
                        dateSelected = -1;
                      });
                    },
                    child: Text(
                      "Clear filters",
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: getProportionateScreenWidth(180),
                        height: getProportionateScreenHeight(60)),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            language = "";
                            category = "";
                            language = langSelected.join(",");
                            category = ids.join(",");
                          });

                          print(search_string);
                          print(language);
                          print(min_scheduled_date);
                          print(max_scheduled_date);
                          print(category);

                          setState(() {
                            _isloaded = false;
                          });
                          Provider.of<CustomViewModel>(context, listen: false)
                              .GetWebinarList(
                                  search_string,
                                  language,
                                  min_scheduled_date,
                                  max_scheduled_date,
                                  category)
                              .then((value) {
                            setState(() {
                              _isloaded = true;
                              if (value == "error") {
                                toastCommon(context,
                                    getTranslated(context, 'no_data_tv') ?? "");
                              } else if (value == "success") {
                                setState(() {
                                  _isFilApplied = true;
                                });
                                pop(context);
                              } else {
                                toastCommon(context,
                                    getTranslated(context, 'no_data_tv') ?? "");
                              }
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFFE44E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              getTranslated(context, 'apply'),
                              style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  letterSpacing: 1,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black87,
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          BackButton(),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "Filter by",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Recency",
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Color(0xFF3B3B3B),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: _buildChips(context),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: Text(
                      getTranslated(context, 'categories_label'),
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Color(0xFF3B3B3B),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  providerListener.filterCategoryList.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 0),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            crossAxisCount: 4,
                            mainAxisSpacing: 20,
                            children: List.generate(
                                providerListener.filterCategoryList.length,
                                (index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (ids.contains(providerListener
                                        .filterCategoryList[index].c_id)) {
                                      ids.remove(providerListener
                                          .filterCategoryList[index].c_id);
                                    } else {
                                      ids.add(providerListener
                                          .filterCategoryList[index].c_id);
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    /*    ids.contains(providerListener
                                            .filterCategoryList[index].c_id)
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                                color: Color(COLOR_BACKGROUND),
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                size: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 1,
                                          ),*/
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Color(ids.contains(
                                                  providerListener
                                                      .filterCategoryList[index]
                                                      .c_id)
                                              ? COLOR_BACKGROUND
                                              : COLOR_WHITE),
                                          width: 3,
                                        ),
                                        image: DecorationImage(
                                            image: providerListener
                                                        .filterCategoryList[
                                                            index]
                                                        .c_image_url ==
                                                    null
                                                ? AssetImage(
                                                    "assets/images/product_placeholder.png")
                                                : NetworkImage(providerListener
                                                        .filterCategoryList[
                                                            index]
                                                        .c_image_url ??
                                                    ""),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      providerListener
                                          .filterCategoryList[index].c_name,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Color(ids.contains(
                                                  providerListener
                                                      .filterCategoryList[index]
                                                      .c_id)
                                              ? COLOR_BACKGROUND
                                              : COLOR_TEXT_BLACK),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 10, bottom: 15, top: 10),
                    child: Text(
                      getTranslated(context, 'language'),
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Color(0xFF3B3B3B),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 10, top: 0),
                      child: Container(
                        height: 90,
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: providerListener.recencyLang.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (langSelected.contains(
                                        providerListener.recencyLang[index])) {
                                      langSelected.remove(
                                          providerListener.recencyLang[index]);
                                    } else {
                                      langSelected.add(
                                          providerListener.recencyLang[index]);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 30),
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Color(langSelected.contains(
                                              providerListener
                                                  .recencyLang[index])
                                          ? COLOR_BACKGROUND
                                          : COLOR_WHITE),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Color(langSelected.contains(
                                                providerListener
                                                    .recencyLang[index])
                                            ? COLOR_PRIMARY
                                            : COLOR_TEXT_GREY),
                                        width: 1,
                                      )),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        langSelected.contains(providerListener
                                                .recencyLang[index])
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Container(
                                                  padding: EdgeInsets.all(1),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    color: Color(
                                                        langSelected.contains(
                                                                providerListener
                                                                        .recencyLang[
                                                                    index])
                                                            ? COLOR_TEXT_WHITE
                                                            : COLOR_BACKGROUND),
                                                  ),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 8,
                                                    color: Color(
                                                        langSelected.contains(
                                                                providerListener
                                                                        .recencyLang[
                                                                    index])
                                                            ? COLOR_BACKGROUND
                                                            : COLOR_TEXT_WHITE),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 1,
                                              ),
                                        /* Text(
                                            recencyLangFirstChar[index],
                                            style: GoogleFonts.sourceSansPro(
                                              color: Color(langSelected.contains(recencyLang[index])
                                                  ? COLOR_TEXT_WHITE
                                                  : COLOR_TEXT_BLACK),
                                              fontSize: 25,
                                            ),
                                          ),*/
                                        Text(
                                          providerListener.recencyLang[index],
                                          style: GoogleFonts.poppins(
                                            color: Color(langSelected.contains(
                                                    providerListener
                                                        .recencyLang[index])
                                                ? COLOR_TEXT_WHITE
                                                : COLOR_TEXT_BLACK),
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )),
                  SizedBox(
                    height: 50,
                  ),
                ],
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

  buildWebinarList(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return ListView.builder(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        itemCount: providerListener.webinarListViewAll.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              push(
                  context,
                  WebinarMainScreen(
                      providerListener.webinarListViewAll[index].id));
            },
            child: Container(
              height: 220,
              margin: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(20),
                  right: getProportionateScreenWidth(20)),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                )
              ]),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                            color: Colors.green[700],
                            image: DecorationImage(
                                image: NetworkImage(providerListener
                                        .webinarListViewAll[index]
                                        .image_path_medium ??
                                    ""),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15))),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent
                              ])
                              // image: DecorationImage()
                              ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: CompanyName(
                          smallthumb_url: providerListener
                              .webinarListViewAll[index].image_path_small,
                          organisation_name: providerListener
                              .webinarListViewAll[index].organisation_name,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFFFEE6C)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                providerListener
                                    .webinarListViewAll[index].scheduled_date
                                    .substring(providerListener
                                            .webinarListViewAll[index]
                                            .scheduled_date
                                            .length -
                                        2),
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    height: 1.3,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat.MMM()
                                    .format(DateTime.parse(providerListener
                                        .webinarListViewAll[index]
                                        .scheduled_date))
                                    .toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width /
                                    1.5 /
                                    1.9,
                                child: Text(
                                  utf8.decode((providerListener
                                              .webinarListViewAll[index]
                                              .title ??
                                          "")
                                      .runes
                                      .toList()),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              DateFormat.EEEE()
                                      .format(DateTime.parse(providerListener
                                          .webinarListViewAll[index]
                                          .scheduled_date))
                                      .toString() +
                                  ", " +
                                  (DateFormat.jm().format(DateFormat("hh:mm:ss")
                                          .parse(providerListener
                                              .webinarListViewAll[index]
                                              .scheduled_time)))
                                      .toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildChips(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Container(
      height: getProportionateScreenHeight(69),
      child: new ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                setState(() {
                  dateSelected = index;
                  if (index == 0) {
                    min_scheduled_date = formatter.format(now);
                    max_scheduled_date = formatter.format(now);
                  } else if (index == 1) {
                    min_scheduled_date = formatter.format(nowTomorrow);
                    max_scheduled_date = formatter.format(nowTomorrow);
                  } else {
                    min_scheduled_date = formatter.format(now);
                    max_scheduled_date = formatter.format(nowLastDay);
                  }
                });
              },
              child: Container(
                width: getProportionateScreenWidth(109),
                margin: EdgeInsets.only(right: getProportionateScreenWidth(20)),
                decoration: BoxDecoration(
                    color: Color(
                        index == dateSelected ? COLOR_BACKGROUND : COLOR_WHITE),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(index == dateSelected
                          ? COLOR_PRIMARY
                          : COLOR_TEXT_GREY),
                      width: 1,
                    )),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        recencyTitle[index],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Color(index == dateSelected
                                ? COLOR_TEXT_WHITE
                                : COLOR_TEXT_BLACK),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Plaster'),
                      ),
                      Text(
                        recencyDate[index],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Color(index == dateSelected
                                ? COLOR_TEXT_WHITE
                                : COLOR_TEXT_BLACK),
                            fontSize: 12,
                            fontFamily: 'Plaster'),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
