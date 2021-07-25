import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Models/NotificationsListParser.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/BannerEvents/event_page.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/NotficationScreen/CutomNotificationDetails.dart';
import 'package:kisanweb/UI/Webinars/webinar_main_screen.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isloaded = false;

  Future<void> initTask() async {
    setState(() {
      _isloaded = false;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .GetNotifications()
        .then((value) {
      setState(() {
        if (value == "error") {
        } else if (value == "success") {
          _isloaded = true;
        } else {}
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print("setUnReadNotCount");
    initTask();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return _isloaded == true
        ? Scaffold(
            backgroundColor: Color(0xFFF2F2F2),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  leading: BackButton(),
                  title: Text(
                    getTranslated(context, 'noti'),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: ResponsiveWidget.isSmallScreen(context)
                      ? 20
                      : getProportionateScreenWidth(717), top: 20, right:  ResponsiveWidget.isSmallScreen(context) ? 20 : getProportionateScreenWidth(717)),
              child: ListView.builder(
                  itemCount: providerListener.notificationsList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return NotificationTile(
                        context, providerListener.notificationsList[index]);
                  }),
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
}

Widget NotificationTile(
    BuildContext context, NotificationsListParser notificationOBJ) {
  return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 10.0,
            spreadRadius: 2.0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateTime.now()
                            .difference(
                                DateTime.parse(notificationOBJ.sent_datetime))
                            .inDays >
                        0
                    ? (DateTime.now()
                            .difference(
                                DateTime.parse(notificationOBJ.sent_datetime))
                            .inDays
                            .toString() +
                        " days ago")
                    : DateTime.now()
                                .difference(DateTime.parse(
                                    notificationOBJ.sent_datetime))
                                .inHours >
                            0
                        ? (DateTime.now()
                                .difference(DateTime.parse(
                                    notificationOBJ.sent_datetime))
                                .inHours
                                .toString() +
                            " hours ago")
                        : (DateTime.now()
                                .difference(DateTime.parse(
                                    notificationOBJ.sent_datetime))
                                .inMinutes
                                .toString() +
                            " minutes ago"),
                style: GoogleFonts.roboto(
                  fontSize: 12,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.green,
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                child: notificationOBJ.field9 != null
                    ? Image.network(notificationOBJ.field9)
                    : Image.asset("assets/images/sample_featured_brands.png"),
                width: 50,
                height: 50,
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: notificationOBJ.action == "org_product_promotion"
                    ? RichText(
                        text: TextSpan(
                            text: notificationOBJ.field8,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: [
                              TextSpan(
                                text: " " +
                                    getTranslated(context, 'has_invited_you') +
                                    " ",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey[700]),
                              ),
                              TextSpan(
                                  text: notificationOBJ.field1,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ]),
                      )
                    : notificationOBJ.action == "org_event_promotion"
                        ? RichText(
                            text: TextSpan(
                                text: getTranslated(context,
                                        'event_that_may_interest_you') +
                                    "\n",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: notificationOBJ.field1,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ]),
                          )
                        : RichText(
                            text: TextSpan(
                                text: getTranslated(context, 'webinar') +
                                    " " +
                                    getTranslated(
                                        context, 'is_about_to_start') +
                                    "\n",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: notificationOBJ.field1,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ]),
                          ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          notificationOBJ.field3 != null
              ? Container(
                  height: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: DecorationImage(
                          image: NetworkImage(notificationOBJ.field3 ?? ""),
                          fit: BoxFit.fill),
                    ),
                  ))
              : Container(
                  height: 250,
                  child: Image.asset(
                    "assets/images/tractor2.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      notificationOBJ.action == "org_product_promotion"
                          ? push(
                              context,
                              DetailedProducts(
                                  int.parse(notificationOBJ.field4.toString()),
                                  int.parse(notificationOBJ.field7.toString())))
                          : notificationOBJ.action == "org_event_promotion"
                              ? push(
                                  context,
                                  BannerEventPage(int.parse(
                                      notificationOBJ.field4.toString())))
                              : notificationOBJ.action == "custom" ||
                                      notificationOBJ.action ==
                                          "org_custom_promotion"
                                  ? push(
                                      context,
                                      CutomNotificationDetails(
                                          prodName: notificationOBJ.field1,
                                          prodDesc: notificationOBJ.field2,
                                          prodPhoto: notificationOBJ.field3))
                                  : notificationOBJ.action ==
                                          "event_starts_soon"
                                      ? push(
                                          context,
                                          WebinarMainScreen(int.parse(
                                              notificationOBJ.field4
                                                  .toString())))
                                      : print("nothing");
                    },
                    child: Text(
                      notificationOBJ.action == "org_product_promotion" ||
                              notificationOBJ.action == "custom" ||
                              notificationOBJ.action == "org_custom_promotion"
                          ? "SEE DETAILS"
                          : notificationOBJ.action == "org_event_promotion"
                              ? "REGISTER"
                              : notificationOBJ.action == "event_starts_soon"
                                  ? "JOIN"
                                  : "",
                      style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 30),
                  InkWell(
                    onTap: () {
                      notificationOBJ.action == "org_event_promotion"
                          ? push(
                              context,
                              BannerEventPage(
                                  int.parse(notificationOBJ.field4.toString())))
                          : notificationOBJ.action == "event_starts_soon"
                              ? push(
                                  context,
                                  WebinarMainScreen(int.parse(
                                      notificationOBJ.field4.toString())))
                              : print("nothing");
                    },
                    child: Text(
                      notificationOBJ.action == "org_event_promotion"
                          ? "SEE DETAILS"
                          : notificationOBJ.action == "event_starts_soon"
                              ? "SEE DETAILS"
                              : "",
                      style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ));
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: 55,
          height: 55,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20),
              side: BorderSide(width: 1, color: Color(0xFF008940)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF008940),
          ),
        ),
      ),
    );
  }
}
