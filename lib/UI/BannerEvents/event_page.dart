import 'dart:convert';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Models/WebinarListParser.dart';
import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
import 'package:kisanweb/UI/DetailedScreens/VideoScreen.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

SharedPreferences _prefs;
String languageCode = 'en';

class BannerEventPage extends StatefulWidget {
  final id;

  BannerEventPage(this.id);

  @override
  _BannerEventPageState createState() => _BannerEventPageState();
}

class _BannerEventPageState extends State<BannerEventPage> {
  PanelController _pc1 = new PanelController();
  bool _visible1 = true;
  bool _innerVisible = false;
  bool _isloaded = false;

  Future<void> initTask() async {
    _prefs = await SharedPreferences.getInstance();
    languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";

    if ((_prefs.getInt('paywall') ?? 0) == 1 &&
        (_prefs.getString('membership_status') ?? "") != "active") {
      //pushReplacement(context, SubscribeToMembership());
    } else {
      Provider.of<CustomViewModel>(context, listen: false)
          .GetEventsDetails(widget.id)
          .then((value) {
        setState(() {
          if (value == "error") {
          } else if (value == "webinar") {
            //pushReplacement(context, WebinarMainScreen(widget.id));
          } else if (value == "success") {
            _isloaded = true;
          } else {}
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.id);
    initTask();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    universalLoader = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    universalLoader.style(
        message: 'Loading...',
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
          strokeWidth: 10,
          backgroundColor: Color(COLOR_PRIMARY),
          valueColor: AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOutSine,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    );
    return _isloaded == true
        ? Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            bottomNavigationBar: providerListener.membershipInfo != null
                ? providerListener.membershipInfo.status != "active"
                    ? Container(
                        height: getProportionateScreenHeight(100),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                getTranslated(
                                    context, 'auto_renwe_a_day_before'),
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff298658)),
                              ),
                            ),
                            Container(
                              height: 60,
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 5),
                              child: SubscribeButton(
                                onPressed: () {
                                  //push(context, SubscribeToMembership());
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: getProportionateScreenHeight(97),
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: 15, left: 20, right: 20),
                              child: providerListener
                                          .eventDetails.event_date_status ==
                                      "live"
                                  ? EnterEventButton(
                                      onPressed: () {},
                                    )
                                  : DaysToGOButton(
                                      start_date: providerListener
                                          .eventDetails.start_date,
                                    ),
                            ),
                          ],
                        ),
                      )
                : SizedBox(
                    height: 1,
                  ),
            /*appBar: PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(),
                      ShareButton(),
                    ],
                  ),
                ),
              ),
            ),*/
            body:
                /*Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        providerListener.eventDetails.media_type ==
                                "youtubevideo"
                            ? push(
                                context,
                                SamplePlayer(null,
                                    providerListener.eventDetails.media_url))
                            : print("imageviewr should be called");
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 249,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              image: DecorationImage(
                                  image: NetworkImage(
                                      providerListener.eventDetails.media_url ??
                                          ""),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          providerListener.eventDetails.media_type ==
                                  "youtubevideo"
                              ? Container(
                                  height: 249,
                                  child: Center(
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.white,
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                        ],
                      ),
                    ),
                    Container(
                      height: 249,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        image: DecorationImage(
                            image: NetworkImage(providerListener
                                    .eventDetails.image_path_medium ??
                                ""),
                            fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        getTranslated(context, 'organised_by'),
                        style: GoogleFonts.poppins(
                          color: Color(0xff5A5A5A),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 50,
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/KISAN.png",
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 50,
                            child: Image.network(providerListener
                                    .eventDetails.image_path_small ??
                                ""),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        getTranslated(context, 'about_event'),
                        style: GoogleFonts.poppins(
                          color: Color(0xff5A5A5A),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(21)),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        parseHtmlString((languageCode == "en"
                            ? utf8.decode(providerListener.eventDetails.about
                                    .toString()
                                    .runes
                                    .toList() ??
                                "")
                            : languageCode == "hi"
                                ? utf8.decode(providerListener
                                        .eventDetails.about_hindi
                                        .toString()
                                        .runes
                                        .toList() ??
                                    "")
                                : utf8.decode(providerListener
                                        .eventDetails.about_marathi
                                        .toString()
                                        .runes
                                        .toList() ??
                                    ""))),
                        style: GoogleFonts.poppins(
                          color: Color(0xff5A5A5A),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    providerListener.webinarList.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              getTranslated(context, 'webinar'),
                              style: GoogleFonts.poppins(
                                color: Color(0xff5A5A5A),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : SizedBox(height: 1),
                    SizedBox(height: 20),
                    providerListener.webinarList.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              height: 250.0,
                              child: ListView.builder(
                                  itemCount:
                                      providerListener.webinarList.length,
                                  clipBehavior: Clip.none,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return WebinarTile(
                                        context,
                                        providerListener.webinarList[index],
                                        providerListener.userprofileData.user);
                                  }),
                            ),
                          )
                        : SizedBox(height: 1),
                    SizedBox(height: 20),
                    providerListener.pavilionsList.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 0),
                            child: Text(
                              "Highlights",
                              style: GoogleFonts.poppins(
                                color: Color(0xff5A5A5A),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : SizedBox(height: 1),
                    providerListener.pavilionsList.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20, top: 0),
                            child: buildCategoryList(context),
                          )
                        : SizedBox(height: 1),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )*/
                Container(
              padding: EdgeInsets.symmetric(horizontal: 200),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CustomBackButton(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 414,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 225,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    image: DecorationImage(
                                        image: NetworkImage(providerListener
                                                .eventDetails
                                                .image_path_medium ??
                                            ""),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  getTranslated(context, 'organised_by'),
                                  style: GoogleFonts.poppins(
                                    color: Color(0xff5A5A5A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 50,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/KISAN.png",
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        child: Image.network(providerListener
                                                .eventDetails
                                                .image_path_small ??
                                            ""),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 47,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Text(
                                      getTranslated(context, 'about_event'),
                                      style: GoogleFonts.poppins(
                                        color: Color(0xff5A5A5A),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: getProportionateScreenHeight(21)),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Text(
                                      parseHtmlString((languageCode == "en"
                                          ? utf8.decode(providerListener
                                                  .eventDetails.about
                                                  .toString()
                                                  .runes
                                                  .toList() ??
                                              "")
                                          : languageCode == "hi"
                                              ? utf8.decode(providerListener
                                                      .eventDetails.about_hindi
                                                      .toString()
                                                      .runes
                                                      .toList() ??
                                                  "")
                                              : utf8.decode(providerListener
                                                      .eventDetails
                                                      .about_marathi
                                                      .toString()
                                                      .runes
                                                      .toList() ??
                                                  ""))),
                                      style: GoogleFonts.poppins(
                                        color: Color(0xff5A5A5A),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: getProportionateScreenHeight(21)),
                                  providerListener.pavilionsList.length > 0
                                      ? Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 13),
                                          decoration: BoxDecoration(
                                              color: Color(0xFFF0F8F3),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Explore products and companies",
                                                style: GoogleFonts.poppins(
                                                  color: Color(0xff5A5A5A),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              providerListener.pavilionsList
                                                          .length >
                                                      0
                                                  ? Container(
                                                      height: 200,
                                                      child: buildCategoryList(
                                                          context),
                                                    )
                                                  : SizedBox(height: 1),
                                            ],
                                          ),
                                        )
                                      : SizedBox(height: 1),
                                  SizedBox(height: 10),
                                  providerListener.webinarList.length > 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            getTranslated(context, 'webinar'),
                                            style: GoogleFonts.poppins(
                                              color: Color(0xff5A5A5A),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      : SizedBox(height: 1),
                                  providerListener.webinarList.length > 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Container(
                                            height: 250.0,
                                            child: ListView.builder(
                                                itemCount: providerListener
                                                    .webinarList.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return WebinarTile(
                                                      context,
                                                      providerListener
                                                          .webinarList[index],
                                                      providerListener
                                                          .userprofileData
                                                          .user);
                                                }),
                                          ),
                                        )
                                      : SizedBox(height: 1),
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

    return ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        shrinkWrap: true,
        itemCount: providerListener.pavilionsList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              List<int> ids = [];
              ids.add(providerListener.pavilionsList[index].id);
              /*push(
                context,
                productsFound(
                    providerListener.pavilionsList[index].name, ids, ""),
              );*/
            },
            child: Container(
              width: 174,
              height: 174,
              margin: EdgeInsets.only(top: 20,right: 20,bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200], blurRadius: 10, spreadRadius: 3)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    padding: EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Image.network(
                      providerListener.pavilionsList[index].image_url,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        providerListener.pavilionsList[index].name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Color(0xff2DB571),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
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

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: getProportionateScreenHeight(65)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: Color(0xFF298658),
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTranslated(context, 'subscribe'),
                style: GoogleFonts.poppins(
                    letterSpacing: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}

class EnterEventButton extends StatelessWidget {
  const EnterEventButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: getProportionateScreenHeight(65)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFFC7E67),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTranslated(context, 'eventoisLive'),
                style: GoogleFonts.poppins(
                    letterSpacing: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}

class DaysToGOButton extends StatelessWidget {
  const DaysToGOButton({
    Key key,
    this.onPressed,
    this.start_date,
  }) : super(key: key);

  final Function onPressed;
  final String start_date;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: getProportionateScreenHeight(65)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: Colors.grey.shade800,
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateTime.parse(start_date).difference(DateTime.now()).inDays > 0
                    ? (DateTime.parse(start_date)
                            .difference(DateTime.now())
                            .inDays
                            .toString() +
                        " " +
                        getTranslated(context, 'days_to_go'))
                    : DateTime.parse(start_date)
                                .difference(DateTime.now())
                                .inDays >
                            0
                        ? (DateTime.parse(start_date)
                                .difference(DateTime.now())
                                .inHours
                                .toString() +
                            " " +
                            getTranslated(context, 'hours_to_go'))
                        : (DateTime.parse(start_date)
                                .difference(DateTime.now())
                                .inMinutes
                                .toString() +
                            " " +
                            getTranslated(context, 'minutes_to_go')),
                style: GoogleFonts.poppins(
                    letterSpacing: 1,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}

/*
class AddToCalendar extends StatelessWidget {
  const AddToCalendar({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: getProportionateScreenHeight(65)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: Colors.yellow.shade300,
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/companies.svg",
                color: Colors.black,
                width: getProportionateScreenWidth(25),
              ),
              SizedBox(
                width: getProportionateScreenWidth(20),
              ),
              Text(
                "Add to calendar",
                style: GoogleFonts.poppins(
                    letterSpacing: 1,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
            ],
          )),
    );
  }
}*/

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
          //pop(context);
        },
        child: Icon(
          Icons.share,
          color: Colors.black,
        ),
      ),
    );
  }
}

Widget WebinarTile(
    BuildContext context, WebinarListParser webinarListParser, int user_id) {
  return GestureDetector(
    onTap: () {
      //push(context, WebinarMainScreen(webinarListParser.id));
    },
    child: Container(
      width: 364,
      margin: EdgeInsets.only(
        top: 20,
        bottom: 20,
        right: 20,
      ),
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
                        image: NetworkImage(
                            webinarListParser.image_path_medium ?? ""),
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
                  height: 97,
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
              /*Positioned(
                    bottom: 10,
                    left: 10,
                    child: CompanyName(
                      smallthumb_url: webinarListParser.image_path_small,
                      organisation_name: webinarListParser.o,
                    ),
                  )*/
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
                        webinarListParser.scheduled_date.substring(
                            webinarListParser.scheduled_date.length - 2),
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.MMM()
                            .format(DateTime.parse(
                                webinarListParser.scheduled_date))
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
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: 193,
                        child: Text(
                          utf8.decode(
                              (webinarListParser.title ?? "").runes.toList()),
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
                                  webinarListParser.scheduled_date))
                              .toString() +
                          ", " +
                          (DateFormat.jm().format(DateFormat("hh:mm:ss")
                                  .parse(webinarListParser.scheduled_time)))
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
}
