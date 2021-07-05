import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/Tabs/HomeTab.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController searchController = TextEditingController();

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SharedPreferences prefs;
  List<String> recetSearches = [];

  bool showSearchMenu = true;
  List<int> ids = [];
  FocusNode focusSearch = FocusNode();
  TextEditingController searchTextController = new TextEditingController();

  bool _isProductLoaded = false;
  bool _isCompaniesLoaded = false;
  bool _isOffersLoaded = false;

  Future<void> InitTask() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      recetSearches = prefs.getStringList('recetSearches') ?? [];
    });
  }

  Future<void> findResults() async {
    setState(() {
      if (searchTextController.text != "") {
        if (recetSearches.length > 4) {
          recetSearches.removeAt(0);
        }

        recetSearches.add(searchTextController.text);
        prefs.setStringList('recetSearches', recetSearches);
      }
      _isProductLoaded = false;
      _isCompaniesLoaded = false;
      _isOffersLoaded = false;
    });

    //TODO
    Provider.of<CustomViewModel>(context, listen: false)
        .GetProductsByCategoryIdsAndSearchString(
            ids
            /*[23, 24]*/,
            (searchTextController.text ?? ""))
        .then((value) {
      setState(() {
        _isProductLoaded = true;
      });
      Provider.of<CustomViewModel>(context, listen: false)
          .GetCompaniesByCategoryIdsAndSearchString(
              ids
              /*[23, 24]*/,
              (searchTextController.text ?? ""))
          .then((value) {
        setState(() {
          _isCompaniesLoaded = true;
        });
        Provider.of<CustomViewModel>(context, listen: false)
            .GetOffersBySearchString((searchTextController.text ?? ""))
            .then((value) {
          setState(() {
            _isOffersLoaded = true;
          });
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InitTask();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    print("Category Listist${((providerListener.categoryList.length)/4).ceil()}");

    return showSearchMenu == true
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(699)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SearchBar(context),
                  SizedBox(
                    height: 15,
                  ),
                  recetSearches != null
                      ? recetSearches.length > 0
                          ? Text(
                              getTranslated(context, 'recent_search_label'),
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Color(0xFF3B3B3B),
                                  fontWeight: FontWeight.w500),
                            )
                          : SizedBox(
                              height: 1,
                            )
                      : SizedBox(
                          height: 1,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  recetSearches != null
                      ? recetSearches.length > 0
                      ? Container(
                    height: recetSearches.length * 50.0,
                    padding: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFF0FFF7)),
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.separated(
                        itemCount: recetSearches.length,
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Color(0xFF3DA86F).withOpacity(0.2),
                            thickness: 2,
                            height: getProportionateScreenHeight(28),
                          );
                        },
                        itemBuilder: (context, index) {
                          return RecentSearch(
                              context,
                              recetSearches[
                              recetSearches.length - 1 - index]);
                        },
                      ),
                    ),
                  )
                      : SizedBox(
                    height: 1,
                  )
                      : SizedBox(
                    height: 1,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    getTranslated(context, 'categories_label'),
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color(0xFF3B3B3B),
                        fontWeight: FontWeight.w500),
                  ),
                  providerListener.categoryList.length > 0
                      ? Container(
                    height: ((providerListener.categoryList.length)/5).ceil().toDouble() *
                        100,
                    child: GridView.count(
                      crossAxisCount: 5,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.9,
                      children: List.generate(
                          providerListener.categoryList.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (ids.contains(providerListener
                                  .categoryList[index].id)) {
                                ids.remove(providerListener
                                    .categoryList[index].id);
                              } else {
                                ids.add(providerListener
                                    .categoryList[index].id);
                              }
                            });
                          },
                          child: Container(
                            child: Column(
                              children: [
                                ids.contains(providerListener
                                    .categoryList[index].id)
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
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(providerListener
                                            .categoryList[index]
                                            .app_image_url ??
                                            ""),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Text(
                                  providerListener.categoryList[index].name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Color(0xFF3B3B3B),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                      : SizedBox(
                    height: 1,
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            )),
          )
        : resultsTabs(context);
  }

  resultsTabs(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 130.0,
          title: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: SearchBar(context),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
          bottom: PreferredSize(
              child: TabBar(
                  isScrollable: true,
                  labelPadding: EdgeInsets.only(right: 30, left: 30),
                  unselectedLabelColor: Colors.grey,
                  labelColor: Color(COLOR_BACKGROUND),
                  indicator: BoxDecoration(),
                  tabs: [
                    Tab(
                      child: Text(
                        getTranslated(context, 'products'),
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Tab(
                      child: Text(
                        getTranslated(context, 'companies'),
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    /*Tab(
                      child: Text(
                        "Offers",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),*/
                  ]),
              preferredSize: Size.fromHeight(30.0)),
        ),
        body: TabBarView(
          children: <Widget>[
            _isProductLoaded == true
                ? SearchResultsProducts(context)
                : Container(
                    height: SizeConfig.screenHeight,
                    color: Colors.white,
                    child: Center(
                      child: new CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Color(COLOR_PRIMARY),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(COLOR_BACKGROUND)),
                      ),
                    ),
                  ),
            _isCompaniesLoaded == true
                ? SearchResultsCompanies(context)
                : Container(
                    height: SizeConfig.screenHeight,
                    color: Colors.white,
                    child: Center(
                      child: new CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Color(COLOR_PRIMARY),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(COLOR_BACKGROUND)),
                      ),
                    ),
                  ),
            /* _isOffersLoaded == true
                ? SearchResultsOffers(context)
                : Container(
                    height: SizeConfig.screenHeight,
                    color: Colors.white,
                    child: Center(
                      child: new CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Color(COLOR_PRIMARY),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(COLOR_BACKGROUND)),
                      ),
                    ),
                  ),*/
          ],
        ),
      ),
    );
  }

  SearchResultsProducts(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Result - " +
                  (providerListener
                              .productsListbycatidsandsearchstring.length ??
                          0)
                      .toString() +
                  " " +
                  getTranslated(context, 'products'),
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF3B3B3B),
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            providerListener.productsListbycatidsandsearchstring.length > 0
                ? Container(
                    height: getProportionateScreenHeight(600),
                    child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: (150 / 180),
                        children: List.generate(
                            providerListener.productsListbycatidsandsearchstring
                                .length, (index) {
                          return GridProds(
                            name: providerListener
                                .productsListbycatidsandsearchstring[index]
                                .title_english,
                            desc: parseHtmlString(providerListener
                                    .productsListbycatidsandsearchstring[index]
                                    .desc_english ??
                                ""),
                            imgPath: providerListener
                                .productsListbycatidsandsearchstring[index]
                                .bigthumb_url,
                            onPressed: () {
                              push(
                                  context,
                                  DetailedProducts(
                                      providerListener
                                          .productsListbycatidsandsearchstring[
                                              index]
                                          .id,
                                      providerListener
                                          .productsListbycatidsandsearchstring[
                                              index]
                                          .user_id));
                            },
                          );
                        })),
                  )
                : SizedBox(
                    height: 10,
                  ),
          ],
        ),
      ),
    );
  }

  SearchResultsCompanies(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Result - " +
                    (providerListener
                                .companiessListbycatidsandsearchstring.length ??
                            0)
                        .toString() +
                    " " +
                    getTranslated(context, 'companies'),
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Color(0xFF3B3B3B),
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            providerListener.companiessListbycatidsandsearchstring.length > 0
                ? Container(
                    height: providerListener.companiessListbycatidsandsearchstring.length.toDouble()* 120,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        primary: false,
                        shrinkWrap: true,
                        itemCount: providerListener
                            .companiessListbycatidsandsearchstring.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Container(
                              width: screenWidth,
                              height: 100,
                              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 2,
                                      spreadRadius: 1)
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 125,
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      /* image: DecorationImage(
                                          image: NetworkImage(providerListener
                                                  .companiessListbycatidsandsearchstring[
                                                      index]
                                                  .image_bigthumb_url ??
                                              ""),
                                          fit: BoxFit.cover),*/
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Image.network(providerListener
                                            .companiessListbycatidsandsearchstring[
                                                index]
                                            .image_bigthumb_url ??
                                        ""),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            getProportionateScreenWidth(220),
                                        child: Text(
                                          providerListener
                                              .companiessListbycatidsandsearchstring[
                                                  index]
                                              .organisation_name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 15,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            providerListener
                                                .companiessListbycatidsandsearchstring[
                                                    index]
                                                .products
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              push(
                                  context,
                                  CompanyDetails(providerListener
                                      .companiessListbycatidsandsearchstring[
                                          index]
                                      .user_id));
                            },
                          );
                        }),
                  )
                : SizedBox(
                    height: 10,
                  ),
          ],
        ),
      ),
    );
  }

  SearchResultsOffers(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Result - " +
                (providerListener.offersListbysearchstring.length ?? 0)
                    .toString() +
                " Offers",
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: Color(0xFF3B3B3B),
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          providerListener.offersListbysearchstring.length > 0
              ? Container(
                  height: 800,
                  child: Expanded(
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          primary: false,
                          shrinkWrap: true,
                          itemCount:
                              providerListener.offersListbysearchstring.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 20),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  height: 500,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blue[900],
                                    image: DecorationImage(
                                        image: NetworkImage(providerListener
                                                .offersListbysearchstring[index]
                                                .bigthumb_url ??
                                            ""),
                                        fit: BoxFit.cover),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[200],
                                          blurRadius: 2,
                                          spreadRadius: 2)
                                    ],
                                  ),
                                  /*margin: EdgeInsets.only(
                                      top: getProportionateScreenHeight(10),
                                      right: getProportionateScreenHeight(20),
                                      bottom: getProportionateScreenHeight(10)),*/
                                  width: getProportionateScreenWidth(172),
                                  child: Stack(
                                    children: [
                                      /*Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(providerListener
                                                        .offersListbysearchstring[
                                                            index]
                                                        .media_url ??
                                                    ""),
                                                fit: BoxFit.cover),
                                          ),
                                          width:
                                              getProportionateScreenWidth(125),
                                        ),
                                      ),*/
                                      Positioned(
                                          top: 10,
                                          left: 10,
                                          child: CompanyName(
                                            smallthumb_url: providerListener
                                                .offersListbysearchstring[index]
                                                .smallthumb_url,
                                            organisation_name: providerListener
                                                .offersListbysearchstring[index]
                                                .organisation_name,
                                          )),
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (providerListener
                                                                .offersListbysearchstring[
                                                                    index]
                                                                .percentage_discount ??
                                                            0)
                                                        .toString() +
                                                    "%",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 35,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Discount",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })),
                )
              : SizedBox(
                  height: 10,
                ),
        ],
      ),
    ));
  }

  SearchBar(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      focusNode: focusSearch,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: InkWell(
          onTap: () {
            pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey,
            size: 30,
          ),
        ),
        hintText: getTranslated(context, 'search_bar_hint'),
        hintStyle: GoogleFonts.poppins(
            color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w600),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        fillColor: Colors.grey.shade100,
        suffixIconConstraints: BoxConstraints.tightFor(height: 50),
        suffixIcon: showSearchMenu == false
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    showSearchMenu = true;
                    searchTextController.clear();
                  });
                },
                child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 10),
                    child: Icon(
                      Icons.clear,
                      size: 35,
                    )),
              )
            : null,
      ),
      onEditingComplete: () {
        findResults();
        focusSearch.unfocus();
        setState(() {
          showSearchMenu = false;
        });
      },
      controller: searchTextController,
    );
  }

  RecentSearch(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        setState(() {
          searchTextController.text = text;
        });
        findResults();
        focusSearch.unfocus();
        setState(() {
          showSearchMenu = false;
        });
      },
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/icons/searchIcon.svg",
              color: Colors.green,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}
