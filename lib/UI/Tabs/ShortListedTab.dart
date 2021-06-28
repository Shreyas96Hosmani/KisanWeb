import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
//import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
//import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/Tabs/HomeTab.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';

var show = "1";

class ShortListedTab extends StatefulWidget {
  @override
  _ShortListedTabState createState() => _ShortListedTabState();
}

class _ShortListedTabState extends State<ShortListedTab> {
  bool _isloaded = false;
  bool _isProductLoaded = false;
  bool _isCompaniesLoaded = false;
  bool _isOffersLoaded = false;

  Future<void> initTask() async {
    setState(() {
      _isProductLoaded = false;
      _isOffersLoaded = false;
      _isCompaniesLoaded = false;
    });

    //TODO
    Provider.of<CustomViewModel>(context, listen: false)
        .GetFavProducts()
        .then((value) {
      setState(() {
        _isProductLoaded = true;
      });
    });
    Provider.of<CustomViewModel>(context, listen: false)
        .GetFavOffers()
        .then((value) {
      setState(() {
        _isOffersLoaded = true;
      });
    });
    Provider.of<CustomViewModel>(context, listen: false)
        .GetFavCompanies()
        .then((value) {
      setState(() {
        _isCompaniesLoaded = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTask();
    setState(() {
      show = "1";
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    buildFilterContainer(BuildContext context) {
      return Center(
        child: Container(
          width: screenWidth / 1.3,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Color(0xffF5F5F5),
              border: Border.all(color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    show = "1";
                  });
                },
                child: Container(
                  //width: screenWidth / 1.3 / 3.02,
                  width: screenWidth / 1.3 / 2,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                    color: show == "1"
                        ? Color(constants.COLOR_BACKGROUND)
                        : Color(0xffF5F5F5),
                  ),
                  child: Center(
                    child: Text(
                      getTranslated(context, 'products'),
                      style: GoogleFonts.poppins(
                        color: show == "1" ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.black,
              ),
              /* GestureDetector(
                onTap: () {
                  setState(() {
                    show = "2";
                  });
                },
                child: Container(
                  width: screenWidth / 1.3 / 3.1,
                  height: 50,
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.black),
                    color: show == "2"
                        ? Color(constants.COLOR_BACKGROUND)
                        : Color(0xffF5F5F5),
                  ),
                  child: Center(
                    child: Text(
                      "Offers",
                      style: GoogleFonts.poppins(
                        color: show == "2" ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.black,
              ),*/
              GestureDetector(
                onTap: () {
                  setState(() {
                    show = "3";
                  });
                },
                child: Container(
                  // width: screenWidth / 1.3 / 3.02,
                  width: screenWidth / 1.3 / 2 - 3,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    //border: Border.all(color: Colors.black),
                    color: show == "3"
                        ? Color(constants.COLOR_BACKGROUND)
                        : Color(0xffF5F5F5),
                  ),
                  child: Center(
                    child: Text(
                      getTranslated(context, 'companies'),
                      style: GoogleFonts.poppins(
                        color: show == "3" ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    buildGridViewProducts(BuildContext context) {
      final providerListener = Provider.of<CustomViewModel>(context);

      return _isProductLoaded == true
          ? GridView.builder(
              scrollDirection: Axis.vertical,
              primary: false,
              shrinkWrap: true,
              itemCount: providerListener.favproductsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 10,childAspectRatio: 0.9),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    width: getProportionateScreenWidth(174),
                    height: getProportionateScreenHeight(211),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            blurRadius: 1,
                            spreadRadius: 1)
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
//                        push(
//                            context,
//                            DetailedProducts(
//                                providerListener.favproductsList[index].id,
//                                providerListener
//                                    .favproductsList[index].user_id));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: getProportionateScreenHeight(125),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              color: Colors.white,
                              image: DecorationImage(
                                  image: NetworkImage(providerListener
                                          .favproductsList[index]
                                          .bigthumb_url ??
                                      ""),
                                  fit: BoxFit.cover),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[200],
                                    blurRadius: 1,
                                    spreadRadius: 1)
                              ],
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7, left: 10),
                              child: Container(
                                color: Colors.white,
                                child: Text(
                                  parseHtmlString(providerListener
                                      .favproductsList[index].title_english),
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                color: Colors.white,
                                child: Text(
                                  parseHtmlString(providerListener
                                      .favproductsList[index].organisation_name),
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[700],
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Container(
              height: SizeConfig.screenHeight / 2,
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

    buildGridViewOffers(BuildContext context) {
      final providerListener = Provider.of<CustomViewModel>(context);

      return _isOffersLoaded == true
          ? GridView.builder(
              scrollDirection: Axis.vertical,
              primary: false,
              shrinkWrap: true,
              itemCount: providerListener.favoffersList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 10),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      show == "1" ? EdgeInsets.all(10.0) : EdgeInsets.all(0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      height: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green[700],
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[200],
                              blurRadius: 2,
                              spreadRadius: 2)
                        ],
                      ),
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(10),
                          right: getProportionateScreenHeight(20),
                          bottom: getProportionateScreenHeight(10)),
                      width: getProportionateScreenWidth(172),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: getProportionateScreenWidth(125),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                color: Colors.green[700],
                                image: DecorationImage(
                                    image: NetworkImage(providerListener
                                            .favoffersList[index]
                                            .bigthumb_url ??
                                        ""),
                                    fit: BoxFit.cover),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 1,
                                      spreadRadius: 1)
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 10,
                              left: 10,
                              child: CompanyName(
                                smallthumb_url: providerListener
                                    .favoffersList[index].smallthumb_url,
                                organisation_name: providerListener
                                    .favoffersList[index].organisation_name,
                              )),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (providerListener.favoffersList[index]
                                                    .percentage_discount ??
                                                0)
                                            .toString() +
                                        "%",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Discount",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
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
              })
          : Container(
              height: SizeConfig.screenHeight / 2,
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

    buildGridViewCompanies(BuildContext context) {
      final providerListener = Provider.of<CustomViewModel>(context);

      return _isCompaniesLoaded == true
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              primary: false,
              shrinkWrap: true,
              itemCount: providerListener.favcompaniesList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: screenWidth,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            blurRadius: 1,
                            spreadRadius: 1)
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
//                        push(
//                            context,
//                            CompanyDetails(providerListener
//                                .favcompaniesList[index].user_id));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 125,
                            padding: EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              /*image: DecorationImage(
                                  image: NetworkImage(providerListener
                                          .favcompaniesList[index]
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
                                .favcompaniesList[index]
                                .image_bigthumb_url ??
                                "",fit: BoxFit.contain,),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  providerListener.favcompaniesList[index]
                                      .organisation_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                              .favcompaniesList[index].products
                                              .toString() +
                                          " products",
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Container(
              color: Colors.white,
              height: SizeConfig.screenHeight / 2,
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

    buildViews(BuildContext context) {
      return Padding(
        padding: show == "1"
            ? EdgeInsets.only(left: 20, right: 20)
            : show == "2"
                ? EdgeInsets.only(left: 20, right: 0)
                : EdgeInsets.only(left: 20, right: 20),
        child: Center(
            child: show == "3"
                ? buildGridViewCompanies(context)
                : show == "1"
                    ? buildGridViewProducts(context)
                    : buildGridViewOffers(context)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            buildFilterContainer(context),
            SizedBox(
              height: 50,
            ),
            Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(child: buildViews(context))),
          ],
        ),
      ),
    );
  }
}
