import 'dart:convert';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Models/WebinarDetails.dart';
import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/DetailedScreens/VideoScreen.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

SharedPreferences prefs;

class WebinarMainScreen extends StatefulWidget {
  final id;

  WebinarMainScreen(this.id);

  @override
  _WebinarMainScreenState createState() => _WebinarMainScreenState();
}

class _WebinarMainScreenState extends State<WebinarMainScreen> {
  Razorpay _razorpay;
  bool _isloaded = false;
  String order_id_webinar;
  int user_id;
  WebinarDetails webinarDetails;

  Future<void> initTask() async {
    setState(() {
      _isloaded = false;
    });
    prefs = await SharedPreferences.getInstance();
    if ((prefs.getInt('paywall') ?? 0) == 1 &&
        (prefs.getString('membership_status') ?? "") != "active") {
      //pushReplacement(context, SubscribeToMembership());
    } else {
      Provider.of<CustomViewModel>(context, listen: false)
          .GetWebinarDetail(widget.id)
          .then((value) {
        setState(() {
          if (value == "error") {
          } else if (value == "success") {
            _isloaded = true;
          } else {}
        });
      });
    }
  }

  // (providerListener.webinarDetails.title??"")
  Future<void> _EventRegister(int user_id) async {
    universalLoader.show();

    Provider.of<CustomViewModel>(context, listen: false)
        .EventRegister(widget.id, user_id)
        .then((value) {
      setState(() {
        universalLoader.hide();
        if (value == "error") {
          toastCommon(context, getTranslated(context, 'no_data_tv'));
        } else if (value == "success") {
          Provider.of<CustomViewModel>(context, listen: false)
              .GetWebinarDetail(widget.id)
              .then((value) {
            //push(context, WebinarSuccess(webinarDetails));
          });
        } else {
          toastCommon(context, "You have already register for the events");
        }
      });
    });
  }

  void openCheckout(String mobile, String email, String amount) async {
    var options;

    options = {
      //TODO: prefill razorpay data
      'key': 'rzp_test_FbmkEFJfTj8RJu', //'rzp_test_P0zF0ER0RTTAan',
      'amount': amount.toString() + "00",
      'name': 'KISAN',
      'theme.color': '#008940',
      'description': 'Webinar register',
      'currency': 'INR',
      'order_id': order_id_webinar,
      'prefill': {'contact': mobile, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    universalLoader.show();

    Provider.of<CustomViewModel>(context, listen: false)
        .VerifyOrder(response.paymentId, order_id_webinar, response.signature,
            widget.id.toString())
        .then((value) {
      setState(() {
        universalLoader.hide();
        if (value == "error") {
          toastCommon(context, getTranslated(context, 'no_data_tv'));
        } else if (value == "success") {
          Provider.of<CustomViewModel>(context, listen: false)
              .GetWebinarDetail(widget.id)
              .then((value) {
            //push(context, WebinarSuccess(webinarDetails));
          });
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Map valueMap = json.decode(response.message);

    toastCommon(context, valueMap['error']['description'].toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    toastCommon(
        context,
        /* "EXTERNAL_WALLET: " + response.walletName*/
        "Error while making payment");
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    initTask();
  }

  /*PanelController _pc1 = new PanelController();
  bool _visible1 = true;*/

  /*PanelController _pc2 = new PanelController();
  bool _visible2 = false;
  bool _isChecked = false;*/

  /*bool _innerVisible = false;*/

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );

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

    return _isloaded == true
        ? Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            /*bottomNavigationBar: Container(
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
                children: [
                  CallButton(
                    onPressed: () {
                      UrlLauncher.launch(
                          "tel://" + providerListener.webinarDetails.mobile ??
                              "");
                    },
                  ),
                  Spacer(),
                  (providerListener.webinarDetails.in_event ?? "0") == "1"
                      ? providerListener.webinarDetails.status == "live"
                          ? JoinMeetingButton(onPressed: () {})
                          : DaysToGOButton(
                              start_date: providerListener
                                  .webinarDetails.scheduled_date,
                            )
                      : RegisterButton(
                          flag: providerListener.webinarDetails.price == null ||
                                  providerListener.webinarDetails.price.isEmpty
                              ? false
                              : true,
                          price: providerListener.webinarDetails.price ?? "0",
                          onPressed: () {
                            setState(() {
                              user_id = providerListener.userprofileData.user;
                              webinarDetails = providerListener.webinarDetails;
                            });

                            print(user_id.toString() +
                                " " +
                                widget.id.toString());

                            if (providerListener
                                    .webinarDetails.allowed_audience ==
                                "allmembers") {
                              if ((prefs.getString('membership_status') ??
                                      "") ==
                                  "active") {
                                if (providerListener.webinarDetails.price ==
                                        null ||
                                    providerListener
                                        .webinarDetails.price.isEmpty) {
                                  _EventRegister(
                                      providerListener.userprofileData.user);
                                } else {
                                  //createorder

                                  universalLoader.show();

                                  Provider.of<CustomViewModel>(context,
                                          listen: false)
                                      .CreateOrder(widget.id.toString())
                                      .then((value) {
                                    setState(() {
                                      universalLoader.hide();
                                      if (value == "error") {
                                        toastCommon(
                                            context,
                                            getTranslated(
                                                context, 'no_data_tv'));
                                      } else if (value == "success") {
                                        setState(() {
                                          order_id_webinar = (providerListener
                                                  .order_id_webinar ??
                                              "");
                                        });
                                        openCheckout(
                                          (providerListener
                                                  .userprofileData.mobile1 ??
                                              ""),
                                          (providerListener
                                                  .userprofileData.email ??
                                              ""),
                                          providerListener
                                                  .webinarDetails.price ??
                                              "0",
                                        );
                                      } else {
                                        toastCommon(context, value);
                                      }
                                    });
                                  });
                                }
                              } else {
                                //push(context, SubscribeToMembership());
                              }
                            } else {
                              if (providerListener.webinarDetails.price ==
                                      null ||
                                  providerListener
                                      .webinarDetails.price.isEmpty) {
                                _EventRegister(
                                    providerListener.userprofileData.user);
                              } else {
                                //createorder

                                universalLoader.show();

                                Provider.of<CustomViewModel>(context,
                                        listen: false)
                                    .CreateOrder(widget.id.toString())
                                    .then((value) {
                                  setState(() {
                                    universalLoader.hide();
                                    if (value == "error") {
                                      toastCommon(context,
                                          getTranslated(context, 'no_data_tv'));
                                    } else if (value == "success") {
                                      setState(() {
                                        order_id_webinar = (providerListener
                                                .order_id_webinar ??
                                            "");
                                      });
                                      openCheckout(
                                        (providerListener
                                                .userprofileData.mobile1 ??
                                            ""),
                                        (providerListener
                                                .userprofileData.email ??
                                            ""),
                                        providerListener.webinarDetails.price ??
                                            "0",
                                      );
                                    } else {
                                      toastCommon(context, value);
                                    }
                                  });
                                });
                              }
                            }
                          },
                        )
                ],
              ),
            ),*/
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
                        providerListener.webinarDetails.media_type ==
                                "youtubevideo"
                            ? push(
                                context,
                                SamplePlayer(
                                    null,
                                    providerListener
                                        .webinarDetails.media_url))
                            : print("imageviewr should be called");
                      },
                      child: Container(
                          child: Stack(
                        children: [
                          Container(
                            height: 249,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              image: DecorationImage(
                                  image: NetworkImage(providerListener
                                          .webinarDetails
                                          .image_path_medium ??
                                      ""),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          providerListener.webinarDetails.media_type ==
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
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              parseHtmlString(utf8.decode(providerListener
                                      .webinarDetails.title.runes
                                      .toList()) ??
                                  ""),
                              style: GoogleFonts.poppins(
                                color: Color(0xff5C5C5C),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color(0xff08763F),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    (providerListener.webinarDetails
                                                    .language ??
                                                "") ==
                                            "English"
                                        ? "A"
                                        : (providerListener.webinarDetails
                                                        .language ??
                                                    "") ==
                                                "Marathi"
                                            ? "म"
                                            : "अ",
                                    style: GoogleFonts.sourceSansPro(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    (providerListener.webinarDetails
                                                    .language ??
                                                "") ==
                                            "English"
                                        ? "ENGLISH"
                                        : (providerListener.webinarDetails
                                                        .language ??
                                                    "") ==
                                                "Marathi"
                                            ? "मराठी"
                                            : "हिंदी",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color(0xffB7B7B7),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              DateFormat.MMMMEEEEd()
                                      .format(DateTime.parse(
                                          providerListener.webinarDetails
                                                  .scheduled_date ??
                                              ""))
                                      .toString() +
                                  " " +
                                  DateTime.parse(providerListener
                                              .webinarDetails
                                              .scheduled_date ??
                                          "")
                                      .year
                                      .toString() +
                                  "\n" +
                                  (DateFormat.jm().format(
                                          DateFormat("hh:mm:ss").parse(
                                              providerListener
                                                      .webinarDetails
                                                      .scheduled_time ??
                                                  "")))
                                      .toString(),
                              style: GoogleFonts.poppins(
                                color: Color(0xffB7B7B7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20),
                      child: Text(
                        getTranslated(context, 'about_the_event'),
                        style: GoogleFonts.poppins(
                          color: Color(0xff5C5C5C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        parseHtmlString(utf8.decode(providerListener
                            .webinarDetails.about.runes
                            .toList())),
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Container(
                        color: Colors.white,
                        child: CompanyLink(
                          title: providerListener
                              .webinarDetails.organisation_name,
                          imagePath: providerListener
                              .webinarDetails.image_path_small,
                          onPressed: () {
                            push(
                                context,
                                CompanyDetails(providerListener
                                    .webinarDetails.user_id));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            )*/
                Container(
              padding: EdgeInsets.symmetric(horizontal: 200),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CustomBackButton(
                    text: "Back",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 414,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                /*providerListener.webinarDetails.media_type ==
                                    "youtubevideo"
                                    ? push(
                                    context,
                                    SamplePlayer(
                                        null,
                                        providerListener
                                            .webinarDetails.media_url))
                                    : print("imageviewr should be called");*/
                              },
                              child: Container(
                                  height: 232,
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.green[700],
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  providerListener
                                                          .webinarDetails
                                                          .image_path_medium ??
                                                      ""),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      providerListener
                                                  .webinarDetails.media_type ==
                                              "youtubevideo"
                                          ? Container(
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
                                  )),
                            ),
                            SizedBox(height: 15,),
                            Container(
                              color: Colors.white,
                              child: CompanyLink(
                                title: providerListener
                                    .webinarDetails.organisation_name,
                                imagePath: providerListener
                                    .webinarDetails.image_bigthumb_url,
                                onPressed: () {
                                  push(
                                      context,
                                      CompanyDetails(providerListener
                                          .webinarDetails.user_id));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              parseHtmlString(utf8.decode(providerListener
                                      .webinarDetails.title.runes
                                      .toList()) ??
                                  ""),
                              style: GoogleFonts.poppins(
                                color: Color(0xff5C5C5C),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              parseHtmlString(utf8.decode(providerListener
                                  .webinarDetails.about.runes
                                  .toList())),
                              style: GoogleFonts.poppins(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 65,
                              child: Row(
                                children: [
                                  CallButton(
                                    onPressed: () {
                                      UrlLauncher.launch("tel://" +
                                              providerListener
                                                  .webinarDetails.mobile ??
                                          "");
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  (providerListener.webinarDetails.in_event ??
                                              "0") ==
                                          "1"
                                      ? providerListener.webinarDetails.status ==
                                              "live"
                                          ? JoinMeetingButton(onPressed: () {})
                                          : DaysToGOButton(
                                              start_date: providerListener
                                                  .webinarDetails.scheduled_date,
                                            )
                                      : RegisterButton(
                                          flag: providerListener
                                                          .webinarDetails.price ==
                                                      null ||
                                                  providerListener.webinarDetails
                                                      .price.isEmpty
                                              ? false
                                              : true,
                                          price: providerListener
                                                  .webinarDetails.price ??
                                              "0",
                                          onPressed: () {
                                            setState(() {
                                              user_id = providerListener
                                                  .userprofileData.user;
                                              webinarDetails =
                                                  providerListener.webinarDetails;
                                            });

                                            print(user_id.toString() +
                                                " " +
                                                widget.id.toString());

                                            if (providerListener.webinarDetails
                                                    .allowed_audience ==
                                                "allmembers") {
                                              if ((prefs.getString(
                                                          'membership_status') ??
                                                      "") ==
                                                  "active") {
                                                if (providerListener
                                                            .webinarDetails
                                                            .price ==
                                                        null ||
                                                    providerListener
                                                        .webinarDetails
                                                        .price
                                                        .isEmpty) {
                                                  _EventRegister(providerListener
                                                      .userprofileData.user);
                                                } else {
                                                  //createorder

                                                  universalLoader.show();

                                                  Provider.of<CustomViewModel>(
                                                          context,
                                                          listen: false)
                                                      .CreateOrder(
                                                          widget.id.toString())
                                                      .then((value) {
                                                    setState(() {
                                                      universalLoader.hide();
                                                      if (value == "error") {
                                                        toastCommon(
                                                            context,
                                                            getTranslated(context,
                                                                'no_data_tv'));
                                                      } else if (value ==
                                                          "success") {
                                                        setState(() {
                                                          order_id_webinar =
                                                              (providerListener
                                                                      .order_id_webinar ??
                                                                  "");
                                                        });
                                                        openCheckout(
                                                          (providerListener
                                                                  .userprofileData
                                                                  .mobile1 ??
                                                              ""),
                                                          (providerListener
                                                                  .userprofileData
                                                                  .email ??
                                                              ""),
                                                          providerListener
                                                                  .webinarDetails
                                                                  .price ??
                                                              "0",
                                                        );
                                                      } else {
                                                        toastCommon(
                                                            context, value);
                                                      }
                                                    });
                                                  });
                                                }
                                              } else {
                                                //push(context, SubscribeToMembership());
                                              }
                                            } else {
                                              if (providerListener
                                                          .webinarDetails.price ==
                                                      null ||
                                                  providerListener.webinarDetails
                                                      .price.isEmpty) {
                                                _EventRegister(providerListener
                                                    .userprofileData.user);
                                              } else {
                                                //createorder

                                                universalLoader.show();

                                                Provider.of<CustomViewModel>(
                                                        context,
                                                        listen: false)
                                                    .CreateOrder(
                                                        widget.id.toString())
                                                    .then((value) {
                                                  setState(() {
                                                    universalLoader.hide();
                                                    if (value == "error") {
                                                      toastCommon(
                                                          context,
                                                          getTranslated(context,
                                                              'no_data_tv'));
                                                    } else if (value ==
                                                        "success") {
                                                      setState(() {
                                                        order_id_webinar =
                                                            (providerListener
                                                                    .order_id_webinar ??
                                                                "");
                                                      });
                                                      openCheckout(
                                                        (providerListener
                                                                .userprofileData
                                                                .mobile1 ??
                                                            ""),
                                                        (providerListener
                                                                .userprofileData
                                                                .email ??
                                                            ""),
                                                        providerListener
                                                                .webinarDetails
                                                                .price ??
                                                            "0",
                                                      );
                                                    } else {
                                                      toastCommon(context, value);
                                                    }
                                                  });
                                                });
                                              }
                                            }
                                          },
                                        ),
                                  SizedBox(width: 20,),
                                  providerListener
                                      .webinarDetails.price ==
                                      null ||
                                      providerListener.webinarDetails
                                          .price.isEmpty ?
                                  Text("This is a free Webinar",style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Color(0xFF707070),
                                    fontWeight: FontWeight.normal
                                  ),)
                                      : SizedBox(height: 0,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                    ],
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
}
/*Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: _visible1,
                maintainState: true,
                maintainAnimation: true,
                child: SlidingUpPanel(
                  controller: _pc1,
                  isDraggable: true,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  maxHeight: SizeConfig.screenHeight * 0.93,
                  onPanelClosed: () {
                    setState(() {
                      _innerVisible = false;
                    });
                  },
                  onPanelOpened: () {
                    setState(() {
                      _innerVisible = true;
                    });
                  },
                  panel: Visibility(
                    visible: _innerVisible,
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenHeight(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 76,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text:
                                    "Your mobile number and profile details may be shared with",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: " " + "NAME",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))
                                ]),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 31,
                                // backgroundImage:
                                // NetworkImage(providerListener.userprofileData.image_url),
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              FaIcon(
                                FontAwesomeIcons.share,
                                color: Colors.green,
                                size: 17,
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              CircleAvatar(
                                radius: 31,
                                // backgroundImage: NetworkImage(
                                //     providerListener.productsDetails.smallthumb_url),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          Divider(
                            color: Color(0xFFBEBEBE),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          Text(
                            "Please answer the following\nQuestions to register for this webinar.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Color(0xff008940),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "1 - Do you have a Tractor ?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(50)),
                                        border: Border.all(color: Colors.grey)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Yes",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(50)),
                                        border: Border.all(color: Colors.grey)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "No",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "2 - What machine do you use for spraying?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(50)),
                                        border: Border.all(color: Colors.grey)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Knapsack Sprayer.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(50)),
                                        border: Border.all(color: Colors.grey)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Portable Power Sprayer.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "FREE",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width: getProportionateScreenWidth(260),
                                    height: getProportionateScreenHeight(65)),
                                child: ElevatedButton(
                                    onPressed: () {
                                      push(context, WebinarSuccess());
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF08763F),
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Submit to Register",
                                          style: GoogleFonts.poppins(
                                              letterSpacing: 1,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  collapsed: Container(
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
                      children: [
                        CallButton(
                          onPressed: () {
                            */
/*_pc1.close();
                            _visible1 = false;
                            _visible2 = true;
                            setState(() {
                              _pc2.open();
                            });*/
/*
                          },
                        ),
                        Spacer(),
                        RegisterButton(
                          onPressed: () {
                           */
/* _pc1.open();
                            setState(() {
                              _visible1 = true;
                            });*/
/*
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              */
/*Visibility(
                maintainAnimation: true,
                maintainState: true,
                visible: _visible2,
                child: CallMeSlide(
                  radius: radius,
                  panelController: _pc2,
                  closePressed: () {
                    _pc2.close();
                    _visible2 = false;
                    _visible1 = true;
                    setState(() {
                      _pc1.close();
                    });
                  },
                  isChecked: _isChecked,

                ),
              ),*/
/*
            ],
          ),*/

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

class CallButton extends StatelessWidget {
  const CallButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 65, height: 65),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.yellow[300],
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: onPressed,
            child: Icon(
              Icons.call,
              color: Colors.black,
            )));
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({Key key, this.onPressed, this.flag, this.price})
      : super(key: key);

  final Function onPressed;
  final bool flag;
  final String price;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: 65),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: Color(0xFF08763F),
              elevation: 1,
              padding: EdgeInsets.symmetric(
                  horizontal: flag == false ? 50 : 80),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                flag == false
                    ? getTranslated(context, 'register_for_free_text')
                    : (currencySymbl +
                        " " +
                        price +
                        " " +
                        getTranslated(context, 'payrup')),
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

class JoinMeetingButton extends StatelessWidget {
  const JoinMeetingButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: 65),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: Color(0xFFFC7E67),
              elevation: 1,
              padding: EdgeInsets.symmetric(
                  horizontal: 80),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTranslated(context, 'join_now'),
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
      constraints: BoxConstraints.tightFor(height: 65),
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
