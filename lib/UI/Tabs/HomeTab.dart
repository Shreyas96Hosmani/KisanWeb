import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Models/AdsObject.dart';
import 'package:kisanweb/Models/WebinarListParser.dart';
import 'package:kisanweb/UI/BannerEvents/event_page.dart';
import 'package:kisanweb/UI/Categories/categories_page.dart';
import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';

//import 'package:kisanweb/UI/BannerEvents/event_page.dart';
//import 'package:kisanweb/UI/Categories/categories_page.dart';
//import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
//import 'package:kisanweb/UI/DemosAndLaunches/DemoLaunch.dart';
//import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
//import 'package:kisanweb/UI/DetailedScreens/VideoScreen.dart';
import 'package:kisanweb/UI/HomeScreen/HomeScreen.dart';
import 'package:kisanweb/UI/HomeScreen/Widgets/SubTile.dart';
import 'package:kisanweb/UI/Intro/InitialScreen.dart';
import 'package:kisanweb/UI/Profile/BasicProfile.dart';
import 'package:kisanweb/UI/ViewAll/ViewAllWebinars.dart';

//import 'package:kisanweb/UI/SearchScreen/SearchScreen.dart';
//import 'package:kisanweb/UI/Subscribe/SubscribeToMembership.dart';
//import 'package:kisanweb/UI/NotficationScreen/Notifications.dart';
//import 'package:kisanweb/UI/Offers/offer_page.dart';
import 'package:kisanweb/UI/Webinars/webinar_main_screen.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/Models/DemoListParser.dart';
import 'package:kisanweb/Models/OfferListParser.dart';
import 'package:kisanweb/Models/LaunchListParser.dart';
import 'package:kisanweb/Models/CategoryListParser.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kisanweb/UI/ViewAll/ViewAllWebinars.dart';

SharedPreferences _prefs;
String languageCode = 'en';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<void> initTask() async {
    _prefs = await SharedPreferences.getInstance();
    languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  }

  @override
  void initState() {
    super.initState();
    initTask();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    print("Images : ${providerListener.homeAdsListImages.length}");

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(200)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              providerListener.membershipInfo != null
                  ? providerListener.membershipInfo.status != "active"
                      ? InkWell(
                          onTap: () {
                            //push(context, SubscribeToMembership());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: SubTile(),
                          ),
                        )
                      : InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: SubTileGreen(),
                          ),
                        )
                  : SizedBox(
                      height: 1,
                    ),
              //Ads now showing
              providerListener.homeAdsListImages.length > 0
                  ? Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFF3FFF0),
                          border: Border.all(color: Color(0xFF88D974))),
                      child: ImageSlider())
                  : SizedBox(
                      height: 1,
                    ),
              //temp reference only
              /*Container(
                height: getProportionateScreenHeight(313),
                decoration: BoxDecoration(
                    color: Color(0xFFF3FFF0),
                    border: Border.all(color: Color(0xFF88D974))),
              ),*/
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            providerListener.categoryList.length > 0
                                ? Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: SubCatTitles(
                                          title: getTranslated(
                                              context, 'categories_label'),
                                        ),
                                      ),
                                      Container(
                                        height: 130,
                                        child: ListView.builder(
                                            itemCount: providerListener
                                                .categoryList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return CategoryTiles(
                                                  context,
                                                  providerListener
                                                      .categoryList[index]);
                                            }),
                                      )
                                    ],
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                            //Divider(),
                            providerListener.featuredproductsList.length > 0
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: SubCatTitles(
                                          title: getTranslated(
                                              context, 'featured_products'),
                                          image: "assets/images/star1.png",
                                        ),
                                      ),
                                      Container(
                                        height:
                                            getProportionateScreenHeight(300),
                                        child: ListView.builder(
                                            itemCount: providerListener
                                                .featuredproductsList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return FeaturedProducts(
                                                name: providerListener
                                                    .featuredproductsList[index]
                                                    .title_english,
                                                desc: providerListener
                                                    .featuredproductsList[index]
                                                    .organisation_name,
                                                image: providerListener
                                                    .featuredproductsList[index]
                                                    .bigthumb_url,
                                                onPressed: () {
                                                  push(
                                                      context,
                                                      DetailedProducts(
                                                          providerListener
                                                              .featuredproductsList[
                                                                  index]
                                                              .id,
                                                          providerListener
                                                              .featuredproductsList[
                                                                  index]
                                                              .user_id));
                                                },
                                              );
                                            }),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                            //CustomDivider(),
                            providerListener.featuredcompaniesList.length > 0
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: SubCatTitles(
                                          title: getTranslated(
                                              context, 'featured_brands'),
                                          image: "assets/images/bookmark.png",
                                        ),
                                      ),
                                      Container(
                                        height:
                                            getProportionateScreenHeight(170),
                                        color: Colors.white,
                                        child: ListView.builder(
                                            itemCount: providerListener
                                                .featuredcompaniesList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return FeaturedBrands(
                                                id: providerListener
                                                    .featuredcompaniesList[
                                                        index]
                                                    .user_id,
                                                organisation_name:
                                                    providerListener
                                                        .featuredcompaniesList[
                                                            index]
                                                        .organisation_name,
                                                image: providerListener
                                                    .featuredcompaniesList[
                                                        index]
                                                    .image_bigthumb_url,
                                              );
                                            }),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                            SizedBox(
                              height: getProportionateScreenHeight(30),
                            ),

                            //---------------"Newly Adds" Section---------------------

                            SizedBox(
                              height: getProportionateScreenHeight(30),
                            ),
                            providerListener.productsList.length > 0
                                ? Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: SubCatTitles(
                                          title: getTranslated(
                                              context, 'newly_added_products'),
                                          image: "assets/images/flag.png",
                                        ),
                                      ),
                                      Container(
                                        height:
                                            getProportionateScreenHeight(300),
                                        child: ListView.builder(
                                            itemCount: providerListener
                                                .productsList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return FeaturedProducts(
                                                name: providerListener
                                                    .productsList[index]
                                                    .title_english,
                                                desc: providerListener
                                                    .productsList[index]
                                                    .organisation_name,
                                                image: providerListener
                                                    .productsList[index]
                                                    .bigthumb_url,
                                                onPressed: () {
//                                    push(
//                                        context,
//                                        DetailedProducts(
//                                            providerListener
//                                                .productsList[index].id,
//                                            providerListener
//                                                .productsList[index].user_id));
                                                },
                                              );
                                            }),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                            //CustomDivider(),
                            providerListener.companiesList.length > 0
                                ? Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: SubCatTitles(
                                          title: getTranslated(
                                              context, 'newly_added_brands'),
                                          image: "assets/images/bookmark.png",
                                        ),
                                      ),
                                      Container(
                                        height: 140,
                                        child: ListView.builder(
                                            itemCount: providerListener
                                                .companiesList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return FeaturedBrands(
                                                id: providerListener
                                                    .companiesList[index]
                                                    .user_id,
                                                organisation_name:
                                                    providerListener
                                                        .companiesList[index]
                                                        .organisation_name,
                                                image: providerListener
                                                    .companiesList[index]
                                                    .image_bigthumb_url,
                                              );
                                            }),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                            SizedBox(
                              height: getProportionateScreenHeight(30),
                            ),

                            //-------------Webinars Sections--------------

                            SizedBox(
                              height: getProportionateScreenHeight(30),
                            ),
                            providerListener.eventList.length > 0
                                ? Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SubCatTitles(
                                            title: getTranslated(
                                                context, 'upcoming_webinars'),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          height: 250,
                                          child: ListView.builder(
                                              itemCount: 5 + 1,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                if (index == 5) {
                                                  return ViewAllButton(
                                                    OnPressed: () {
                                                      push(context,
                                                          ViewAllWebinars());
                                                    },
                                                  );
                                                }

                                                return WebinarTile(
                                                    context,
                                                    providerListener
                                                        .eventList[index]);
                                              }),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            providerListener.featuredeventList.length > 0
                                ? Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SubCatTitles(
                                            title: getTranslated(
                                                context, 'featured_webinars'),
                                          ),
                                        ),
                                        Container(
                                          height: 220,
                                          child: ListView.builder(
                                              itemCount: providerListener
                                                  .featuredeventList.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return FeaturesWebinar(
                                                    context,
                                                    providerListener
                                                            .featuredeventList[
                                                        index]);
                                              }),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            //CustomDivider(),
                            /*    providerListener.offersList.length > 0
                  ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: SubCatTitles(
                                title: "Latest Offers",
                              ),
                            ),
                            Container(
                              height: getProportionateScreenHeight(263),
                              padding: EdgeInsets.only(left: 20),
                              child: ListView.builder(
                                  itemCount: providerListener.offersList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return LatestOfferTile(
                                        providerListener.offersList[index]);
                                  }),
                            ),
                          ],
                        )
                  : SizedBox(
                          height: 1,
                        ),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),*/
                            /* SizedBox(
                height: getProportionateScreenHeight(30),
              ),

              providerListener.demosList.length > 0
                  ? Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(20)),
                              child: SubCatTitles(
                                title: "Latest Demo",
                              ),
                            ),
                            Container(
                              height: getProportionateScreenHeight(263),
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenWidth(20)),
                              child: ListView.builder(
                                  itemCount: providerListener.demosList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return LatestDemo(
                                        context, providerListener.demosList[index]);
                                  }),
                            ),
                          ],
                        )
                  : SizedBox(
                          height: 1,
                        ),
              SizedBox(
                height: 30,
              ),*/
                            //CustomDivider(),
                            /*  providerListener.launchList.length > 0
                  ? Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(22)),
                              child: SubCatTitles(
                                title: "Latest Product Launch",
                              ),
                            ),
                            Container(
                              height: 450,
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenWidth(20)),
                              child: ListView.builder(
                                  itemCount: providerListener.launchList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return LatestProductLaunch(context,
                                        providerListener.launchList[index]);
                                  }),
                            ),
                          ],
                        )
                  : SizedBox(
                          height: 1,
                        ),*/
                            providerListener.notificationsList.length > 0
                                ? CustomDivider()
                                : SizedBox(
                                    height: 1,
                                  ),
                            providerListener.notificationsList.length > 0
                                ? InkWell(
                                    onTap: () {
                                      //push(context, NotificationScreen());
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: [
                                          SubCatTitles(
                                            title: providerListener
                                                    .notificationsList.length
                                                    .toString() +
                                                " " +
                                                getTranslated(context,
                                                    'unread_notification'),
                                          ),
                                          /*SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "View all Notification",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Color(COLOR_ACCENT),
                                    ),
                                  ),
                                ),*/
                                        ],
                                      ),
                                    ))
                                : SizedBox(
                                    height: 1,
                                  ),
                            CustomDivider(),
                            /*ColouredCustomButtons(
                              imgPath: "assets/images/discount.png",
                              bgColour: Color(0xFFF7F2D4),
                              primaryColour: Color(0xFFA27000),
                              text: "Offers",
                              onPressed: () {},
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            ColouredCustomButtons(
                              imgPath: "assets/images/calender.png",
                              bgColour: Color(0xFFCEF7F5),
                              primaryColour: Color(0xFF05AEBA),
                              text: "Webinar",
                              onPressed: () {},
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            ColouredCustomButtons(
                              imgPath: "assets/images/video_play.png",
                              bgColour: Color(0xFFD8FCD8),
                              primaryColour: Color(0xFF008840),
                              text: "Demo",
                              onPressed: () {},
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            ColouredCustomButtons(
                              imgPath: "assets/images/rocket.png",
                              bgColour: Color(0xFFFFE6E2),
                              primaryColour: Color(0xFFC8341C),
                              text: "Product Launch",
                              onPressed: () {},
                            ),*/
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: getProportionateScreenWidth(350),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LiveEventButton(),
                          /*SizedBox(
                            height: getProportionateScreenHeight(16.3),
                          ),
                          Container(
                            height: 350,
                            width: 350,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(16.3),
                          ),
                          Container(
                            height: 350,
                            width: 350,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(16.3),
                          ),
                          Container(
                            height: 350,
                            width: 350,
                            color: Colors.tealAccent,
                          ),*/
                          SizedBox(
                            height: 20,
                          ),
                          AdTile(context, providerListener.topAd),
                          SizedBox(
                            height: 20,
                          ),
                          AdTile(context, providerListener.middleAd),
                          SizedBox(
                            height: 20,
                          ),
                          AdTile(context, providerListener.bottomAd),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget LatestOfferTile(OfferListParser offerOBJ) {
    return GestureDetector(
      onTap: () {
        //push(context, OfferPage(offerOBJ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF08A796),
        ),
        margin: EdgeInsets.only(
            top: getProportionateScreenHeight(20),
            right: getProportionateScreenHeight(20),
            bottom: getProportionateScreenHeight(20)),
        width: getProportionateScreenWidth(172),
        child: Stack(
          children: [
            Center(
              child: Container(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: NetworkImage(offerOBJ.bigthumb_url ?? ""),
                      fit: BoxFit.fill),
                ),
              )),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                //height: MediaQuery.of(context).size.width / 3 / 1.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ])
                    // image: DecorationImage()
                    ),
              ),
            ),
            Positioned(
                top: 10,
                left: 10,
                child: CompanyName(
                  smallthumb_url: offerOBJ.smallthumb_url,
                  organisation_name: offerOBJ.organisation_name,
                )),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (offerOBJ.percentage_discount ?? "0") + "%",
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
    );
  }
}

class LiveEventButton extends StatelessWidget {
  const LiveEventButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          height: getProportionateScreenHeight(99), width: 350),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            primary: Color(0xFFFC7E67),
            onPrimary: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(31)),
            side: BorderSide(color: Color(0xFFCC4026), width: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: getProportionateScreenHeight(23),
            )),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/icons/dot_circle.svg",
              height: 31,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "Attend\nLive Events Now",
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}

class ViewAllButton extends StatelessWidget {
  final Function OnPressed;

  ViewAllButton({this.OnPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: 170,
          height: getProportionateScreenHeight(65),
        ),
        child: ElevatedButton(
          onPressed: OnPressed,
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 0,
              side: BorderSide(width: 2, color: Colors.green),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "View All",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green),
              ),
              SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                "assets/icons/forwardIcon.svg",
                width: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ColouredCustomButtons extends StatelessWidget {
  const ColouredCustomButtons({
    Key key,
    this.bgColour,
    this.primaryColour,
    this.imgPath,
    this.text,
    this.onPressed,
  }) : super(key: key);

  final Color bgColour, primaryColour;
  final String imgPath, text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
            width: getProportionateScreenWidth(370), height: 60),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                primary: bgColour,
                elevation: 0,
                alignment: Alignment.center,
                onPrimary: primaryColour,
                side: BorderSide(color: primaryColour, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Image.asset(
                        imgPath,
                        width: getProportionateScreenWidth(30),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(10),
                      ),
                      Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: primaryColour,
                            fontFamily: 'Poppins Bold',
                            fontSize: 18),
                      )
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: primaryColour,
                )
              ],
            )),
      ),
    );
  }
}

class InvitationTile extends StatelessWidget {
  const InvitationTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: getProportionateScreenHeight(522),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 1.0,
              spreadRadius: 1.0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CompanyInvitationHeader(),
            Container(
              height: getProportionateScreenHeight(390),
              child: Image.asset(
                "assets/images/tractor2.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ],
        ));
  }
}

class CompanyInvitationHeader extends StatelessWidget {
  const CompanyInvitationHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Image.asset("assets/images/sample_featured_brands.png"),
          width: getProportionateScreenWidth(50),
          height: getProportionateScreenWidth(50),
        ),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
                text: "Sonalika Tractors",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: " has invited you to see their product ",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[700]),
                  ),
                  TextSpan(
                      text: "Tiger series tractor",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ]),
          ),
        ),
      ],
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(30),
        ),
        Divider(
          thickness: getProportionateScreenHeight(6),
          color: Color(0xFFBDC9C5),
          height: 0,
        ),
        SizedBox(
          height: getProportionateScreenHeight(30),
        ),
      ],
    );
  }
}

Widget LatestProductLaunch(BuildContext context, LaunchListParser lauchOBJ) {
  return GestureDetector(
    onTap: () {
      //push(context, DemoLaunch());
    },
    child: Container(
      padding: EdgeInsets.only(top: 13, bottom: 13, right: 13),
      width: MediaQuery.of(context).size.width / 1.3,
      margin: EdgeInsets.only(
        top: 30,
        bottom: getProportionateScreenHeight(30),
        right: 10,
      ),
      // decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: NetworkImage(lauchOBJ.bigthumb_url ?? ""),
      //       fit: BoxFit.fill,
      //       scale: 2,
      //       alignment: Alignment.bottomCenter,
      //     ),
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(20),
      //     boxShadow: [
      //       BoxShadow(color: Colors.grey[200], blurRadius: 2, spreadRadius: 2)
      //     ]),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(lauchOBJ.bigthumb_url ?? ""),
                  fit: BoxFit.cover,
                  scale: 2,
                  alignment: Alignment.bottomCenter,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200], blurRadius: 2, spreadRadius: 2)
                ]),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.width / 3 / 1.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent
                      ])
                  // image: DecorationImage()
                  ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: CompanyName(
                    smallthumb_url: lauchOBJ.smallthumb_url,
                    organisation_name: lauchOBJ.organisation_name,
                  ),
                ),
                /* Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20),
                  child: Text(
                    lauchOBJ.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )*/
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget LatestDemo(BuildContext context, DemoListParser demoOBJ) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      width: MediaQuery.of(context).size.width / 1.3,
      height: 200,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 3.0,
            spreadRadius: 2.5,
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      margin: EdgeInsets.only(top: 20, bottom: 10, right: 10, left: 5),
      child: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(demoOBJ.bigthumb_url ?? ""),
                      fit: BoxFit.cover),
                ),
              ),
              Center(
                child: Opacity(
                  opacity: 0.7,
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              )
            ],
          )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9),
            height: getProportionateScreenHeight(80),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CompanyName(
                    smallthumb_url: demoOBJ.smallthumb_url,
                    organisation_name: demoOBJ.organisation_name,
                    textColor: Color(0xFF585858),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    demoOBJ.title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget WebinarTile(BuildContext context, WebinarListParser eventOBJ) {
  return GestureDetector(
    onTap: () {
      if (eventOBJ.type == "WSM") {
        push(context, BannerEventPage(eventOBJ.id));
      } else {
        push(context, WebinarMainScreen(eventOBJ.id));
      }
    },
    child: Container(
      width: getProportionateScreenWidth(337),
      margin: EdgeInsets.only(
          top: getProportionateScreenHeight(20),
          bottom: getProportionateScreenHeight(20),
          right: getProportionateScreenWidth(20)),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          blurRadius: 5.0,
          spreadRadius: 1.0,
        )
      ]),
      child: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.green[700],
                    image: DecorationImage(
                        image: NetworkImage(eventOBJ.image_path_medium ?? ""),
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
                  height: getProportionateScreenHeight(71),
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
                  smallthumb_url: eventOBJ.image_bigthumb_url,
                  organisation_name: eventOBJ.organisation_name,
                ),
              )
            ],
          )),
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
                  width: getProportionateScreenWidth(60),
                  height: getProportionateScreenWidth(60),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFFFEE6C)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        eventOBJ.scheduled_date
                            .substring(eventOBJ.scheduled_date.length - 2),
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.MMM()
                            .format(DateTime.parse(eventOBJ.scheduled_date))
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
                      width: getProportionateScreenWidth(175),
                      child: Text(
                        utf8.decode(eventOBJ.title.runes.toList()),
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
                              .format(DateTime.parse(eventOBJ.scheduled_date))
                              .toString() +
                          ", " +
                          (DateFormat.jm().format(DateFormat("hh:mm:ss")
                                  .parse(eventOBJ.scheduled_time)))
                              .toString(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: Colors.black),
                    ),
                  ],
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color(0xff08763F),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          (eventOBJ.language ?? "") == "English"
                              ? "A"
                              : (eventOBJ.language ?? "") == "Marathi"
                                  ? "म"
                                  : "अ",
                          style: GoogleFonts.sourceSansPro(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          (eventOBJ.language ?? "") == "English"
                              ? "ENGLISH"
                              : (eventOBJ.language ?? "") == "Marathi"
                                  ? "मराठी"
                                  : "हिंदी",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget FeaturesWebinar(BuildContext context, WebinarListParser eventOBJ) {
  return GestureDetector(
    onTap: () {
      push(context, WebinarMainScreen(eventOBJ.id));
    },
    child: Container(
      width: getProportionateScreenWidth(337),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green[500],
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(
              2.0,
              2.0,
            ),
            blurRadius: 3.0,
            spreadRadius: 1.0,
          )
        ],
        image: DecorationImage(
            image: NetworkImage(eventOBJ.image_path_medium ?? ""),
            fit: BoxFit.fill),
      ),
      margin: EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 20,
      ),
      child: Stack(
        children: [
          Container(
            width: 89,
            height: 51,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Color(COLOR_BACKGROUND),
            ),
            child: Text(
              DateFormat.d()
                      .format(DateTime.parse(eventOBJ.scheduled_date))
                      .toString() +
                  " " +
                  DateFormat.MMMM()
                      .format(DateTime.parse(eventOBJ.scheduled_date))
                      .toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenHeight(13.3)),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 97,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
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
            bottom: 20,
            left: 20,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompanyName(
                    smallthumb_url: eventOBJ.image_bigthumb_url,
                    organisation_name: eventOBJ.organisation_name,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 250,
                    child: Text(
                      utf8.decode(eventOBJ.title.runes.toList()),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

class CompanyName extends StatelessWidget {
  const CompanyName({
    Key key,
    this.smallthumb_url,
    this.organisation_name,
    this.onPressed,
    this.textColor,
  }) : super(key: key);

  final String smallthumb_url, organisation_name;
  final Function onPressed;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2.0,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: Image.network(smallthumb_url ?? "", fit: BoxFit.contain),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 220,
          child: Text(
            organisation_name,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor ?? Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

Widget AdTile(BuildContext context, AdsObject adOBJ) {
  return adOBJ != null
      ? Stack(children: [
          InkWell(
            onTap: () {
              if (adOBJ.link_type == "internal") {
                if (adOBJ.link_for == "Event") {
                  push(context, BannerEventPage(adOBJ.linking_id ?? 0));
                } else if (adOBJ.link_for == "Webinar") {
                  //push(context, BannerEventPage());
                  toastCommon(context, "webinar coming soon");
                } else if (adOBJ.link_for == "Webinar") {
                  //push(context, BannerEventPage());
                  toastCommon(context, "webinar coming soon");
                } else if (adOBJ.link_for == "Product") {
//                  push(
//                      context,
//                      DetailedProducts(
//                          adOBJ.linking_id, adOBJ.organisation_id));
                } else if (adOBJ.link_for == "Category") {
//                  push(
//                      context,
//                      CategoriesPage(adOBJ.pavilion_name_for_category,
//                          adOBJ.organisation_id));
                } else if (adOBJ.link_for == "Brand") {
                  //push(context, CompanyDetails(adOBJ.organisation_id));
                }
              } else if (adOBJ.link_type == "external") {
                if (adOBJ.link_url != null) _launchURL(adOBJ.link_url);
              }
            },
            child: Container(
              height: getProportionateScreenWidth(350),
              width: getProportionateScreenWidth(350),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                      image: adOBJ.bigthumb_url == null
                          ? AssetImage("assets/images/product_placeholder.png")
                          : NetworkImage(adOBJ.bigthumb_url),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: getProportionateScreenWidth(35),
              height: getProportionateScreenHeight(25),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(3)),
              child: Text(
                "AD",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ])
      : SizedBox(
          height: 1,
        );
}

class FeaturedBrands extends StatefulWidget {
  const FeaturedBrands({
    Key key,
    this.id,
    this.organisation_name,
    this.image,
    this.onPressed,
  }) : super(key: key);

  final int id;
  final String organisation_name, image;
  final Function onPressed;

  @override
  _FeaturedBrandsState createState() => _FeaturedBrandsState();
}

class _FeaturedBrandsState extends State<FeaturedBrands> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: getProportionateScreenHeight(10),
        bottom: getProportionateScreenHeight(10),
        left: getProportionateScreenWidth(10),
      ),
      width: getProportionateScreenWidth(100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: getProportionateScreenWidth(88),
              height: getProportionateScreenWidth(88),
            ),
            child: ElevatedButton(
                onPressed: () {
                  push(context, CompanyDetails(widget.id));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  elevation: 3,
                  padding: EdgeInsets.all(10),
                  shadowColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          getProportionateScreenHeight(25))),
                ),
                child: Image.network(
                  widget.image ?? "",
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(
            height: 7,
          ),
          Text(
            widget.organisation_name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }
}

class FeaturedProducts extends StatefulWidget {
  const FeaturedProducts({
    Key key,
    this.name,
    this.desc,
    this.image,
    this.onPressed,
  }) : super(key: key);

  final String name, desc, image;
  final Function onPressed;

  @override
  _FeaturedProductsState createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: getProportionateScreenWidth(124),
        height: getProportionateScreenHeight(161),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            offset: const Offset(
              1.0,
              1.0,
            ),
            blurRadius: 3.0,
            spreadRadius: 1.0,
          )
        ]),
        margin: EdgeInsets.only(top: 20, bottom: 20, left: 20),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          image: widget.image == null
                              ? AssetImage(
                                  "assets/images/product_placeholder.png")
                              : NetworkImage(widget.image ?? ""),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                )),
            Expanded(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]),
                  ),
                  Text(
                    widget.desc,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 10),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

Widget CategoryTiles(BuildContext context, CategoryListParser categoryOBJ) {
  return Padding(
    padding: const EdgeInsets.only(right: 0, left: 20, top: 20, bottom: 20),
    child: Container(
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: getProportionateScreenWidth(100),
        ),
        child: ElevatedButton(
          onPressed: () {
            push(context,
               CategoriesPage(
                   languageCode == "en"
                       ? categoryOBJ.app_name_english ?? ""
                       : languageCode == "hi"
                           ? utf8.decode(categoryOBJ.app_name_hindi.runes
                                   .toList()) ??
                               ""
                           : utf8.decode(categoryOBJ.app_name_marathi.runes
                                   .toList()) ??
                               "",
                   categoryOBJ.id));
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 4,
            shadowColor: Colors.grey[100],
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: Image.network(
            categoryOBJ.app_image_url ?? "",
            fit: BoxFit.fill,
          ),
        ),
      ),
    ),
  );
}

class SubCatTitles extends StatelessWidget {
  const SubCatTitles({
    Key key,
    this.title,
    this.image,
  }) : super(key: key);

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    color: Color(COLOR_TEXT),
                    fontSize: getProportionateScreenHeight(20),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: getProportionateScreenWidth(3),
              ),
              SizedBox(
                width: 5,
              ),
              Container(height: 20, width: 20, child: Image.asset(image ?? "")),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey,
        ),
      ],
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

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              onPageChanged: (index, onTap) {
                setState(() {
                  currentS = index;
                });
                print(currentS.toString());
              },
              height: getProportionateScreenHeight(313),
              autoPlay: true,
              autoPlayAnimationDuration: Duration(milliseconds: 700)),
          items: providerListener.homeAdsListImages.map((url) {
            int index = providerListener.homeAdsListImages.indexOf(url);
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    if (providerListener.homeAdsList[index].link_type ==
                        "internal") {
                      if (providerListener.homeAdsList[index].link_for ==
                          "Event") {
                        push(
                            context,
                            BannerEventPage(providerListener
                                    .homeAdsList[index].linking_id ??
                                0));
                      } else if (providerListener.homeAdsList[index].link_for ==
                          "Webinar") {
                        //push(context, BannerEventPage());
                        toastCommon(context, "webinar coming soon");
                      } else if (providerListener.homeAdsList[index].link_for ==
                          "Webinar") {
                        //push(context, BannerEventPage());
                        toastCommon(context, "webinar coming soon");
                      } else if (providerListener.homeAdsList[index].link_for ==
                          "Product") {
//                          push(
//                              context,
//                              DetailedProducts(
//                                  providerListener
//                                      .homeAdsList[index].linking_id,
//                                  providerListener
//                                      .homeAdsList[index].organisation_id));
                      } else if (providerListener.homeAdsList[index].link_for ==
                          "Category") {
//                          push(
//                              context,
//                              CategoriesPage(
//                                  providerListener.homeAdsList[index]
//                                      .pavilion_name_for_category,
//                                  providerListener
//                                      .homeAdsList[index].pavilion_id));
                      } else if (providerListener.homeAdsList[index].link_for ==
                          "Brand") {
//                          push(
//                              context,
//                              CompanyDetails(providerListener
//                                  .homeAdsList[index].organisation_id));
                      }
                    } else if (providerListener.homeAdsList[index].link_type ==
                        "external") {
                      if (providerListener.homeAdsList[index].link_url != null)
                        _launchURL(
                            providerListener.homeAdsList[index].link_url);
                    }
                  },
                  child: Container(
                    width: getProportionateScreenWidth(429),
                    height: getProportionateScreenHeight(224),
                    margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(25),
                        vertical: getProportionateScreenHeight(24)),
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
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: providerListener.homeAdsListImages.map((url) {
              int index = providerListener.homeAdsListImages.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      currentS == index ? Colors.grey[700] : Colors.grey[300],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
      ],
    );
  }
}

_launchURL(String url) async {
  if (await urlLauncher.canLaunch(url)) {
    await urlLauncher.launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

int currentS = 0;
