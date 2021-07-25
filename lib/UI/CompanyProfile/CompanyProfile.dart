import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Models/RepresentativeListParser.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/CompanyProfile/Tabs/AboutTab.dart';
import 'package:kisanweb/UI/CompanyProfile/Tabs/ProductsTab.dart';
import 'package:kisanweb/UI/CompanyProfile/Tabs/VideoTab.dart';
import 'package:kisanweb/UI/CompanyProfile/Widgets/CompanyTabs.dart';
import 'package:kisanweb/UI/DetailedScreens/VideoScreen.dart';
import 'package:kisanweb/UI/Subscribe/SubscribeToMembership.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

int indexSaveContact = -1;
SharedPreferences prefs;

String languageCode = 'en';
int company_id;

class CompanyDetails extends StatefulWidget {
  int id;

  CompanyDetails(this.id);

  @override
  _CompanyDetailsState createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  PanelController _pc1 = new PanelController();
  bool _visible1 = true;

  PanelController _pc2 = new PanelController();
  bool _visible2 = false;

  PanelController _pc3 = new PanelController();
  bool _visible3 = false;

  PanelController _pc4 = new PanelController();
  bool _visible4 = false;

  bool _innerVisible = false;

  PageController _controller;
  int _selectedTab = 0;

  bool _isChecked = false;
  bool _isloaded = false;

  Future<void> initTask() async {
    prefs = await SharedPreferences.getInstance();
    languageCode = prefs.getString(LAGUAGE_CODE) ?? "en";

    if ((prefs.getInt('paywall') ?? 0) == 1 &&
        (prefs.getString('membership_status') ?? "") != "active") {
      //pushReplacement(context, SubscribeToMembership());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)),
                //this right here
                child: SubscribeToMembership());
          });
    } else {
      setState(() {
        _isChecked = prefs.getBool('_isChecked') ?? false;
      });

      //TODO: remove hardcoded id, given because only it has assets, videos
      Provider.of<CustomViewModel>(context, listen: false)
          .GetDetailedOfCompany(company_id /*27604*/ /*7467*/)
          .then((value) {
        setState(() {
          if (value == "error") {
          } else if (value == "success") {
            _isloaded = true;
          } else {}
        });
      });

      Getrepresentative();
    }
  }

  Future<void> Getrepresentative() {
    //TODO: representative id hardcoded
    Provider.of<CustomViewModel>(context, listen: false)
        .Getrepresentative(company_id /*27634*/)
        .then((value) => VisitProduct());
  }

  Future<void> VisitProduct() {
    //TODO: representative id hardcoded
    Provider.of<CustomViewModel>(context, listen: false)
        .visitCompany(company_id);
  }

  Future<void> connectCompanyCall(
      int user, int user_id, int id, String mobile) {
    universalLoader.style(
        message: 'Calling...',
        backgroundColor: Colors.white,
        progressWidget: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(
            Icons.call,
            color: Colors.green,
            size: 17,
          ),
          radius: 15,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOutSine,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    universalLoader.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .connectCompanyCall(user, user_id, id)
        .then((value) {
      setState(() {
        universalLoader.hide();
        if (value == "error") {
          toastCommon(context, getTranslated(context, 'no_data_tv'));
        } else if (value == "success") {
          UrlLauncher.launch("tel://" + mobile);
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  Future<void> connectCompanyWhatsApp(
      int user, int user_id, int id, String mobile, int add_contact) {
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

    universalLoader.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .connectCompanyWhatsApp(user, user_id, id, add_contact)
        .then((value) {
      setState(() {
        universalLoader.hide();
        if (value == "error") {
          toastCommon(
              context,
              getTranslated(
                      context, 'No_Internet_Connection_Please_try_again') ??
                  "");
        } else if (value == "success") {
          if (add_contact == 1) {
            _pc1.close();
            _visible1 = false;
            setState(() {
              _pc3.open();
              _visible3 = true;
            });
          } else {
            UrlLauncher.launch("https://wa.me/?phone=" +
                mobile.replaceAll(" ", "").replaceAll("+", ""));
          }
          Getrepresentative();
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  Future<void> connectCompanyWhatsAppWithSaveButton(
      int user, int user_id, int id, String mobile, int add_contact) {
    universalLoader.style(
        message: 'Saving...',
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

    universalLoader.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .connectCompanyWhatsApp(user, user_id, id, add_contact)
        .then((value) {
      setState(() {
        universalLoader.hide();
        if (value == "error") {
          toastCommon(
              context,
              getTranslated(
                      context, 'No_Internet_Connection_Please_try_again') ??
                  "");
        } else if (value == "success") {
          if (add_contact == 1) {
            _pc3.close();
            _visible3 = false;
            setState(() {
              _pc4.open();
              _visible4 = true;
            });
          } else {
            UrlLauncher.launch("https://wa.me/?phone=" +
                mobile.replaceAll(" ", "").replaceAll("+", ""));
          }
          Getrepresentative();
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  @override
  void initState() {
    print(widget.id);
    _controller = PageController();
    super.initState();
    setState(() {
      company_id = widget.id;
    });
    initTask();
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      toastCommon(context, getTranslated(context, 'permission_not_granted'));
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      //  toastCommon(context, "Contact data not available on device");
      toastCommon(context, getTranslated(context, 'permission_not_granted'));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    universalLoader = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    final providerListener = Provider.of<CustomViewModel>(context);
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    SizeConfig().init(context);

    return _isloaded == true
        ? Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            body: ResponsiveWidget.isSmallScreen(context) ? Stack(children: [
              Container(
                width: double.infinity,
                child: SingleChildScrollView(
                    child: providerListener.companyDetails != null
                        ? Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            /*  BrandBannerbigthumb_url = null;
                                  BrandBannermedia_type = null;
                                  BrandBannermedia_url = null;
                                  */
                            (providerListener.BrandBannermedia_type ??
                                "") ==
                                "youtubevideo"
                                ? push(
                                context,
                                SamplePlayer(
                                    null,
                                    providerListener
                                        .BrandBannermedia_url ??
                                        ""))
                                : print("imageviewr should be called");
                          },
                          child: Container(
                            height: SizeConfig.screenHeight / 3,
                            color: Colors.green,
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  decoration: BoxDecoration(
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
                                    color: Colors.green[700],
                                    image: DecorationImage(
                                        image: providerListener
                                            .BrandBannermedia_url !=
                                            null
                                            ? NetworkImage(providerListener
                                            .BrandBannermedia_url ??
                                            "")
                                            : AssetImage(
                                            "assets/images/product_placeholder.png"),
                                        /* image: NetworkImage(
                                                  providerListener
                                                      .companyDetailsAssets[0]
                                                      .bigthumb_url ??
                                                      ""),*/

                                        fit: BoxFit.fill),
                                  ),
                                ),
                                (providerListener.BrandBannermedia_type ??
                                    "") ==
                                    "youtubevideo"
                                    ? Center(
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                )
                                    : SizedBox(
                                  height: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Color(/*0xFF0051BC*/ int.parse(
                              providerListener
                                  .companyDetails.image_max_color
                                  .replaceAll("#", "0xFF"))),
                          padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      /*image: DecorationImage(
                                                  image: NetworkImage(
                                                      providerListener
                                                              .companyDetails
                                                              .image_bigthumb_url ??
                                                          ""),
                                                  fit: BoxFit.contain),*/
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 10)
                                        ]),
                                    child: Image.network(
                                      providerListener.companyDetails
                                          .image_bigthumb_url ??
                                          "",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                        providerListener.companyDetails
                                            .organisation_name ??
                                            "",
                                        /*languageCode=="en"?providerListener.companyDetails.organisation_name??"":languageCode=="hi"?providerListener.companyDetails
                                                  .brandname_hindi??"":providerListener.companyDetails
                                                  .brandname_marathi??"",*/
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CompanyTabs(
                                selectedTab: _selectedTab,
                                tabPressed: (num) {
                                  _controller.animateToPage(num,
                                      duration:
                                      Duration(milliseconds: 400),
                                      curve: Curves.easeOutCubic);
                                },
                              ),
                            ],
                          ),
                        ),
                        ExpandablePageView(
                          controller: _controller,
                          onPageChanged: (num) {
                            setState(() {
                              _selectedTab = num;
                            });
                          },
                          children: [
                            AboutTab(),
                            ProductsTab(),
                            VideosTab()
                          ],
                        ),
                        //Slide Up Panel Starts from here
                      ],
                    )
                        : SizedBox(
                      height: 1,
                    )),
              ),
              //Slide Up Panel Starts from here
              providerListener.companyDetails != null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: _visible1,
                    maintainState: true,
                    maintainAnimation: true,
                    child: SlidingUpPanel(
                      controller: _pc1,
                      minHeight: 105,
                      maxHeight: 550,
                      borderRadius: radius,
                      onPanelOpened: () {
                        setState(() {
                          _innerVisible = true;
                        });
                      },
                      onPanelClosed: () {
                        setState(() {
                          _innerVisible = false;
                        });
                      },
                      panel: Visibility(
                        visible: _innerVisible,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 33, vertical: 10),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 76,
                                        height: 8,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            borderRadius:
                                            BorderRadius.circular(
                                                20)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    providerListener.companyDetails
                                        .organisation_name ??
                                        "",
                                    style:
                                    GoogleFonts.poppins(fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    height: 44,
                                    child: Text(
                                      getTranslated(context,
                                          'contactPopUpInfo') +
                                          " " +
                                          (providerListener.companyDetails
                                              .organisation_name ??
                                              ""),
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  providerListener
                                      .representativeList.length >
                                      0
                                      ? Container(
                                    height: 300,
                                    child: MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child: ListView.builder(
                                          itemCount: providerListener
                                              .representativeList
                                              .length,
                                          itemBuilder:
                                              (context, index) {
                                            return RepInformation(
                                              onCallPressed: () {
                                                if ((prefs.getInt(
                                                    'paywall') ??
                                                    0) ==
                                                    2 &&
                                                    (prefs.getString(
                                                        'membership_status') ??
                                                        "") !=
                                                        "active") {
                                                  push(context,
                                                      SubscribeToMembership());
                                                } else {
                                                  connectCompanyCall(
                                                      providerListener
                                                          .userprofileData
                                                          .user,
                                                      providerListener
                                                          .representativeList[
                                                      index]
                                                          .user_id,
                                                      company_id,
                                                      providerListener
                                                          .representativeList[
                                                      index]
                                                          .mobile ??
                                                          "");
                                                }
                                              },
                                              onWhatAppPressed:
                                                  () async {
                                                setState(() {
                                                  indexSaveContact =
                                                      index;
                                                });
                                                if ((prefs.getInt(
                                                    'paywall') ??
                                                    0) ==
                                                    2 &&
                                                    (prefs.getString(
                                                        'membership_status') ??
                                                        "") !=
                                                        "active") {
                                                  push(context,
                                                      SubscribeToMembership());
                                                } else {
                                                  if (providerListener
                                                      .representativeList[
                                                  index]
                                                      .status ==
                                                      "accepted") {
                                                    connectCompanyWhatsApp(
                                                        providerListener
                                                            .userprofileData
                                                            .user,
                                                        providerListener
                                                            .representativeList[
                                                        index]
                                                            .user_id,
                                                        company_id,
                                                        providerListener
                                                            .representativeList[index]
                                                            .mobile ??
                                                            "",
                                                        0);
                                                  } else if (providerListener
                                                      .representativeList[
                                                  index]
                                                      .status ==
                                                      "not initiated") {
                                                    _pc1.close();
                                                    setState(() {
                                                      _visible3 =
                                                      true;
                                                      _visible1 =
                                                      false;
                                                      _pc3.open();
                                                    });
                                                  } else if (providerListener
                                                      .representativeList[
                                                  index]
                                                      .status ==
                                                      "initiated") {
                                                    //below condition if cotact is not saved in current and request initiated from another device
                                                    String
                                                    mobileNumber =
                                                        providerListener
                                                            .representativeList[index]
                                                            .mobile ??
                                                            "";
                                                    PermissionStatus
                                                    permissionStatus =
                                                    await _getContactPermission();
                                                    if (permissionStatus ==
                                                        PermissionStatus
                                                            .granted) {
                                                      try {
                                                        Iterable<
                                                            Contact>
                                                        asdf =
                                                        await ContactsService.getContactsForPhone(
                                                            mobileNumber);

                                                        if (asdf.length ==
                                                            0) {
                                                          _pc1.close();
                                                          _visible1 =
                                                          false;
                                                          setState(
                                                                  () {
                                                                _pc3.open();
                                                                _visible3 =
                                                                true;
                                                              });
                                                        } else {
                                                          toastCommon(
                                                              context,
                                                              getTranslated(context, 'request_ent') ??
                                                                  "");
                                                        }
                                                      } catch (e) {
                                                        toastCommon(
                                                            context,
                                                            getTranslated(
                                                                context,
                                                                'no_data_tv'));
                                                      }
                                                    } else {
                                                      _handleInvalidPermissions(
                                                          permissionStatus);
                                                    }
                                                  }
                                                }
                                              },
                                              representativeOBJ:
                                              providerListener
                                                  .representativeList[
                                              index],
                                            );
                                          }),
                                    ),
                                  )
                                      : SizedBox(
                                    height: 1,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Get a call from the company",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        CallMeButton(
                                          onPressed: () {
                                            if ((prefs.getInt(
                                                'paywall') ??
                                                0) ==
                                                2 &&
                                                (prefs.getString(
                                                    'membership_status') ??
                                                    "") !=
                                                    "active") {
                                              push(context,
                                                  SubscribeToMembership());
                                            } else {
                                              if (_isChecked == false) {
                                                _pc1.close();
                                                _visible1 = false;
                                                _visible2 = true;
                                                setState(() {
                                                  _pc2.open();
                                                });
                                              } else {
                                                Provider.of<CustomViewModel>(
                                                    context,
                                                    listen: false)
                                                    .requestCallMe(
                                                    providerListener
                                                        .userprofileData
                                                        .user,
                                                    company_id,
                                                    company_id)
                                                    .then((value) {
                                                  toastCommon(
                                                      context,
                                                      getTranslated(
                                                          context,
                                                          'request_ent') ??
                                                          "");
                                                });
                                              }
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      collapsed: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(25),
                            vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth / 5),
                              child: Text(
                                (providerListener.representativeList
                                    .length ??
                                    0)
                                    .toString() +
                                    " " +
                                    getTranslated(
                                        context, 'numberOfOnline')
                                        .toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                FavButton(
                                  providerListener: providerListener,
                                  onPressed: () {},
                                  favButtonChild: FavoriteButton(
                                    iconSize: 40,
                                    valueChanged: (_isFavorite) {
                                      print('Is Favorite $_isFavorite)');
                                      Provider.of<CustomViewModel>(
                                          context,
                                          listen: false)
                                          .LikeDislikeCompany(
                                          providerListener
                                              .userprofileData.user,
                                          company_id);
                                    },
                                    isFavorite: (providerListener
                                        .companyDetails.liked ??
                                        false),
                                  ),
                                ),
                                Spacer(),
                                ContactButton(
                                  colorText: int.parse(providerListener
                                      .companyDetails.image_max_color
                                      .replaceAll("#", "0xFF")),
                                  onPressed: () {
                                    _pc1.open();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  providerListener.companyDetails != null
                      ? Visibility(
                    maintainState: true,
                    maintainAnimation: true,
                    visible: _visible2,
                    child: CallMeSlide(
                      radius: radius,
                      panelController: _pc2,
                      closePressed: () {
                        _pc2.close();
                        _visible2 = false;
                        _visible1 = true;
                        setState(() {
                          _pc1.open();
                        });
                      },
                      isChecked: _isChecked,
                      checkBoxChanged: (value) {
                        setState(() {
                          _isChecked = !_isChecked;
                          prefs.setBool('_isChecked', value);
                        });
                      },
                    ),
                  )
                      : SizedBox(
                    height: 1,
                  ),
                  providerListener.companyDetails != null &&
                      providerListener.representativeList.length >
                          0 &&
                      indexSaveContact != -1
                      ? Visibility(
                    maintainState: true,
                    maintainAnimation: true,
                    visible: _visible3,
                    child: SaveContact(
                      name: (providerListener
                          .representativeList[
                      indexSaveContact]
                          .first_name ??
                          "") +
                          " " +
                          (providerListener
                              .representativeList[
                          indexSaveContact]
                              .last_name ??
                              ""),
                      org_name: (providerListener
                          .companyDetails.organisation_name ??
                          ""),
                      image_url: (providerListener
                          .representativeList[indexSaveContact]
                          .image_url ??
                          ""),
                      radius: radius,
                      panelController: _pc3,
                      closePressed: () {
                        _pc3.close();
                        _visible3 = false;
                        _visible1 = true;
                        setState(() {
                          _pc1.open();
                        });
                      },
                      saveContactPressed: () async {
                        PermissionStatus permissionStatus =
                        await _getContactPermission();
                        if (permissionStatus ==
                            PermissionStatus.granted) {
                          String mobileNumber = providerListener
                              .representativeList[
                          indexSaveContact]
                              .mobile ??
                              "";

                          Iterable<Contact> asdf =
                          await ContactsService
                              .getContactsForPhone(
                              mobileNumber);

                          if (asdf.length == 0) {
                            try {
                              Contact contact = Contact();
                              contact.givenName = providerListener
                                  .representativeList[
                              indexSaveContact]
                                  .first_name +
                                  " " +
                                  providerListener
                                      .representativeList[
                                  indexSaveContact]
                                      .last_name;
                              contact.displayName = providerListener
                                  .representativeList[
                              indexSaveContact]
                                  .first_name +
                                  " " +
                                  providerListener
                                      .representativeList[
                                  indexSaveContact]
                                      .last_name;
                              contact.phones = [
                                Item(
                                    label: "mobile",
                                    value: mobileNumber)
                              ];
                              contact.company = providerListener
                                  .companyDetails.organisation_name;
                              await ContactsService.addContact(
                                  contact);

                              Iterable<Contact> temp =
                              await ContactsService
                                  .getContactsForPhone(
                                  mobileNumber);

                              if (temp.length > 0) {
                                print("******************added");
                                //we have save log on server if saved
                                connectCompanyWhatsAppWithSaveButton(
                                    providerListener
                                        .userprofileData.user,
                                    providerListener
                                        .representativeList[
                                    indexSaveContact]
                                        .user_id,
                                    company_id,
                                    providerListener
                                        .representativeList[
                                    indexSaveContact]
                                        .mobile ??
                                        "",
                                    1);
                              } else {}
                            } catch (e) {
                              print(e);
                            }
                          } else {
                            /*we have save log on server even if present in device as user may use other account in same device*/
                            print("******************present");
                            connectCompanyWhatsAppWithSaveButton(
                                providerListener
                                    .userprofileData.user,
                                providerListener
                                    .representativeList[
                                indexSaveContact]
                                    .user_id,
                                company_id,
                                providerListener
                                    .representativeList[
                                indexSaveContact]
                                    .mobile ??
                                    "",
                                1);
                          }
                        } else {
                          _handleInvalidPermissions(
                              permissionStatus);
                        }
                      },
                    ),
                  )
                      : SizedBox(
                    height: 1,
                  ),
                  providerListener.companyDetails != null &&
                      providerListener.representativeList.length >
                          0 &&
                      indexSaveContact != -1
                      ? Visibility(
                    maintainState: true,
                    maintainAnimation: true,
                    visible: _visible4,
                    child: WhatsAppReqSent(
                      radius: radius,
                      panelController: _pc4,
                      closePressed: () {
                        _pc4.close();
                        _visible4 = false;
                        _visible1 = true;
                        setState(() {
                          _pc1.open();
                        });
                      },
                      whatsAppPressed: () {
                        _pc4.close();
                        _visible4 = false;
                        _visible1 = true;
                        setState(() {
                          _pc1.open();
                        });
                      },
                    ),
                  )
                      : SizedBox(
                    height: 7,
                  ),
                ],
              )
                  : SizedBox(height: 1),
            ]) : Stack(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 150),
                child: SingleChildScrollView(
                    child: providerListener.companyDetails != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomBackButton(
                                text: "Back",
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 53),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          /*  BrandBannerbigthumb_url = null;
                                          BrandBannermedia_type = null;
                                          BrandBannermedia_url = null;
                                          */
                                          /*(providerListener.BrandBannermedia_type ??
                                                      "") ==
                                                  "youtubevideo"
                                              ? push(
                                                  context,
                                                  SamplePlayer(
                                                      null,
                                                      providerListener
                                                              .BrandBannermedia_url ??
                                                          ""))
                                              : print("imageviewr should be called");*/
                                        },
                                        child: Container(
                                          height: SizeConfig.screenHeight / 3,
                                          color: Colors.green,
                                          child: Stack(
                                            children: [
                                              Container(
                                                width:
                                                    getProportionateScreenWidth(
                                                        378),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 0, vertical: 0),
                                                decoration: BoxDecoration(
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
                                                  color: Colors.green[700],
                                                  image: DecorationImage(
                                                      image: providerListener
                                                                  .BrandBannermedia_url !=
                                                              null
                                                          ? NetworkImage(
                                                              providerListener
                                                                      .BrandBannermedia_url ??
                                                                  "")
                                                          : AssetImage(
                                                              "assets/images/product_placeholder.png"),
                                                      /* image: NetworkImage(
                                                          providerListener
                                                              .companyDetailsAssets[0]
                                                              .bigthumb_url ??
                                                              ""),*/

                                                      fit: BoxFit.fill),
                                                ),
                                              ),
                                              (providerListener
                                                              .BrandBannermedia_type ??
                                                          "") ==
                                                      "youtubevideo"
                                                  ? Center(
                                                      child: Opacity(
                                                        opacity: 0.7,
                                                        child: Icon(
                                                          Icons
                                                              .play_circle_fill,
                                                          color: Colors.white,
                                                          size: 50,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height: 1,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Color(/*0xFF0051BC*/ int.parse(
                                            providerListener
                                                .companyDetails.image_max_color
                                                .replaceAll("#", "0xFF"))),
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 110,
                                                  height: 110,
                                                  padding: EdgeInsets.all(7),
                                                  decoration: BoxDecoration(
                                                      /*image: DecorationImage(
                                                          image: NetworkImage(
                                                              providerListener
                                                                      .companyDetails
                                                                      .image_bigthumb_url ??
                                                                  ""),
                                                          fit: BoxFit.contain),*/
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            spreadRadius: 2,
                                                            blurRadius: 10)
                                                      ]),
                                                  child: Image.network(
                                                    providerListener
                                                            .companyDetails
                                                            .image_bigthumb_url ??
                                                        "",
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 18,
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    child: Text(
                                                      providerListener
                                                              .companyDetails
                                                              .organisation_name ??
                                                          "",
                                                      /*languageCode=="en"?providerListener.companyDetails.organisation_name??"":languageCode=="hi"?providerListener.companyDetails
                                                          .brandname_hindi??"":providerListener.companyDetails
                                                          .brandname_marathi??"",*/
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            CompanyTabs(
                                              selectedTab: _selectedTab,
                                              tabPressed: (num) {
                                                _controller.animateToPage(num,
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.easeOutCubic);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      ExpandablePageView(
                                        controller: _controller,
                                        onPageChanged: (num) {
                                          setState(() {
                                            _selectedTab = num;
                                          });
                                        },
                                        children: [
                                          AboutTab(),
                                          ProductsTab(),
                                          VideosTab()
                                        ],
                                      ),
                                      //Slide Up Panel Starts from here
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 1,
                          )),
              ),
              //Slide Up Panel Starts from here
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 4)
                      ]),
                  height: getProportionateScreenHeight(106),
                  margin: EdgeInsets.only(
                      left: getProportionateScreenWidth(842),
                      right: getProportionateScreenWidth(200)),
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(25), vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FavButton(
                        providerListener: providerListener,
                        onPressed: () {},
                        favButtonChild: FavoriteButton(
                          iconSize: 40,
                          valueChanged: (_isFavorite) {
                            print('Is Favorite $_isFavorite)');
                            Provider.of<CustomViewModel>(context, listen: false)
                                .LikeDislikeCompany(
                                    providerListener.userprofileData.user,
                                    company_id);
                          },
                          isFavorite:
                              (providerListener.companyDetails.liked ?? false),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(25),
                      ),
                      ContactButton(
                        colorText: int.parse(providerListener
                            .companyDetails.image_max_color
                            .replaceAll("#", "0xFF")),
                        onPressed: () {
                          _pc1.open();
                        },
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(25),
                      ),
                      Container(
                        width: 300,
                        child: Text(
                          (providerListener.representativeList.length ?? 0)
                                  .toString() +
                              " " +
                              getTranslated(context, 'numberOfOnline')
                                  .toString(),
                          style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              providerListener.companyDetails != null
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: _visible1,
                            maintainState: true,
                            maintainAnimation: true,
                            child: SlidingUpPanel(
                              controller: _pc1,
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(1197),
                                  right: getProportionateScreenWidth(309)),
                              minHeight: 0,
                              maxHeight: getProportionateScreenHeight(710),
                              borderRadius: radius,
                              onPanelOpened: () {
                                setState(() {
                                  _innerVisible = true;
                                });
                              },
                              onPanelClosed: () {
                                setState(() {
                                  _innerVisible = false;
                                });
                              },
                              panel: Visibility(
                                visible: _innerVisible,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 33, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        providerListener.companyDetails
                                                .organisation_name ??
                                            "",
                                        style:
                                            GoogleFonts.poppins(fontSize: 13),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        height: 44,
                                        child: Text(
                                          getTranslated(
                                                  context, 'contactPopUpInfo') +
                                              " " +
                                              (providerListener.companyDetails
                                                      .organisation_name ??
                                                  ""),
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      providerListener
                                                  .representativeList.length >
                                              0
                                          ? Container(
                                              height:
                                                  getProportionateScreenHeight(
                                                      370),
                                              child: MediaQuery.removePadding(
                                                removeTop: true,
                                                context: context,
                                                child: ListView.builder(
                                                    itemCount: providerListener
                                                        .representativeList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return RepInformation(
                                                        onCallPressed: () {
                                                          if ((prefs.getInt(
                                                                          'paywall') ??
                                                                      0) ==
                                                                  2 &&
                                                              (prefs.getString(
                                                                          'membership_status') ??
                                                                      "") !=
                                                                  "active") {
                                                            /*push(context,SubscribeToMembership());*/
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              35)),
                                                                      //this right here
                                                                      child:
                                                                          SubscribeToMembership());
                                                                });
                                                          } else {
                                                            connectCompanyCall(
                                                                providerListener
                                                                    .userprofileData
                                                                    .user,
                                                                providerListener
                                                                    .representativeList[
                                                                        index]
                                                                    .user_id,
                                                                company_id,
                                                                providerListener
                                                                        .representativeList[
                                                                            index]
                                                                        .mobile ??
                                                                    "");
                                                          }
                                                        },
                                                        onWhatAppPressed:
                                                            () async {
                                                          setState(() {
                                                            indexSaveContact =
                                                                index;
                                                          });
                                                          if ((prefs.getInt(
                                                                          'paywall') ??
                                                                      0) ==
                                                                  2 &&
                                                              (prefs.getString(
                                                                          'membership_status') ??
                                                                      "") !=
                                                                  "active") {
                                                            /*push(context, SubscribeToMembership());*/
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              35)),
                                                                      //this right here
                                                                      child:
                                                                          SubscribeToMembership());
                                                                });
                                                          } else {
                                                            if (providerListener
                                                                    .representativeList[
                                                                        index]
                                                                    .status ==
                                                                "accepted") {
                                                              connectCompanyWhatsApp(
                                                                  providerListener
                                                                      .userprofileData
                                                                      .user,
                                                                  providerListener
                                                                      .representativeList[
                                                                          index]
                                                                      .user_id,
                                                                  company_id,
                                                                  providerListener
                                                                          .representativeList[
                                                                              index]
                                                                          .mobile ??
                                                                      "",
                                                                  0);
                                                            } else if (providerListener
                                                                    .representativeList[
                                                                        index]
                                                                    .status ==
                                                                "not initiated") {
                                                              _pc1.close();
                                                              setState(() {
                                                                _visible3 =
                                                                    true;
                                                                _visible1 =
                                                                    false;
                                                                _pc3.open();
                                                              });
                                                            } else if (providerListener
                                                                    .representativeList[
                                                                        index]
                                                                    .status ==
                                                                "initiated") {
                                                              //below condition if cotact is not saved in current and request initiated from another device
                                                              String
                                                                  mobileNumber =
                                                                  providerListener
                                                                          .representativeList[
                                                                              index]
                                                                          .mobile ??
                                                                      "";
                                                              PermissionStatus
                                                                  permissionStatus =
                                                                  await _getContactPermission();
                                                              if (permissionStatus ==
                                                                  PermissionStatus
                                                                      .granted) {
                                                                try {
                                                                  Iterable<
                                                                          Contact>
                                                                      asdf =
                                                                      await ContactsService
                                                                          .getContactsForPhone(
                                                                              mobileNumber);

                                                                  if (asdf.length ==
                                                                      0) {
                                                                    _pc1.close();
                                                                    _visible1 =
                                                                        false;
                                                                    setState(
                                                                        () {
                                                                      _pc3.open();
                                                                      _visible3 =
                                                                          true;
                                                                    });
                                                                  } else {
                                                                    toastCommon(
                                                                        context,
                                                                        getTranslated(context,
                                                                                'request_ent') ??
                                                                            "");
                                                                  }
                                                                } catch (e) {
                                                                  toastCommon(
                                                                      context,
                                                                      getTranslated(
                                                                          context,
                                                                          'no_data_tv'));
                                                                }
                                                              } else {
                                                                _handleInvalidPermissions(
                                                                    permissionStatus);
                                                              }
                                                            }
                                                          }
                                                        },
                                                        representativeOBJ:
                                                            providerListener
                                                                    .representativeList[
                                                                index],
                                                      );
                                                    }),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 1,
                                            ),
                                      Spacer(),
                                      Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Get a call from the company",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            CallMeButton(
                                              onPressed: () {
                                                if ((prefs.getInt('paywall') ??
                                                            0) ==
                                                        2 &&
                                                    (prefs.getString(
                                                                'membership_status') ??
                                                            "") !=
                                                        "active") {
                                                  /*push(context,
                                                    SubscribeToMembership());*/
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            35)),
                                                            //this right here
                                                            child:
                                                                SubscribeToMembership());
                                                      });
                                                } else {
                                                  if (_isChecked == false) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              35)),
                                                              //this right here
                                                              child:
                                                                  CallMeDialog(
                                                                radius: radius,
                                                                closePressed:
                                                                    () {
                                                                  pop(context);
                                                                },
                                                                isChecked:
                                                                    _isChecked,
                                                                checkBoxChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _isChecked =
                                                                        !_isChecked;
                                                                    prefs.setBool(
                                                                        '_isChecked',
                                                                        value);
                                                                    print(
                                                                        "_isChecked $_isChecked");
                                                                  });
                                                                },
                                                              ));
                                                        });
                                                  } else {
                                                    Provider.of<CustomViewModel>(
                                                            context,
                                                            listen: false)
                                                        .requestCallMe(
                                                            providerListener
                                                                .userprofileData
                                                                .user,
                                                            company_id,
                                                            company_id)
                                                        .then((value) {
                                                      toastCommon(
                                                          context,
                                                          getTranslated(context,
                                                                  'request_ent') ??
                                                              "");
                                                    });
                                                  }
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              collapsed: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                              ),
                            ),
                          ),
                          /*providerListener.companyDetails != null
                              ? Visibility(
                                  maintainState: true,
                                  maintainAnimation: true,
                                  visible: _visible2,
                                  child: CallMeSlide(
                                    radius: radius,
                                    panelController: _pc2,
                                    closePressed: () {
                                      _pc2.close();
                                      _visible2 = false;
                                      _visible1 = true;
                                      setState(() {
                                        _pc1.open();
                                      });
                                    },
                                    isChecked: _isChecked,
                                    checkBoxChanged: (value) {
                                      setState(() {
                                        _isChecked = !_isChecked;
                                        prefs.setBool('_isChecked', value);
                                      });
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),*/
                          /*providerListener.companyDetails != null &&
                                  providerListener.representativeList.length >
                                      0 &&
                                  indexSaveContact != -1
                              ? Visibility(
                                  maintainState: true,
                                  maintainAnimation: true,
                                  visible: _visible3,
                                  child: SaveContact(
                                    name: (providerListener
                                                .representativeList[
                                                    indexSaveContact]
                                                .first_name ??
                                            "") +
                                        " " +
                                        (providerListener
                                                .representativeList[
                                                    indexSaveContact]
                                                .last_name ??
                                            ""),
                                    org_name: (providerListener
                                            .companyDetails.organisation_name ??
                                        ""),
                                    image_url: (providerListener
                                            .representativeList[
                                                indexSaveContact]
                                            .image_url ??
                                        ""),
                                    radius: radius,
                                    panelController: _pc3,
                                    closePressed: () {
                                      _pc3.close();
                                      _visible3 = false;
                                      _visible1 = true;
                                      setState(() {
                                        _pc1.open();
                                      });
                                    },
                                    saveContactPressed: () async {
                                      PermissionStatus permissionStatus =
                                          await _getContactPermission();
                                      if (permissionStatus ==
                                          PermissionStatus.granted) {
                                        String mobileNumber = providerListener
                                                .representativeList[
                                                    indexSaveContact]
                                                .mobile ??
                                            "";

                                        Iterable<Contact> asdf =
                                            await ContactsService
                                                .getContactsForPhone(
                                                    mobileNumber);

                                        if (asdf.length == 0) {
                                          try {
                                            Contact contact = Contact();
                                            contact.givenName = providerListener
                                                    .representativeList[
                                                        indexSaveContact]
                                                    .first_name +
                                                " " +
                                                providerListener
                                                    .representativeList[
                                                        indexSaveContact]
                                                    .last_name;
                                            contact.displayName =
                                                providerListener
                                                        .representativeList[
                                                            indexSaveContact]
                                                        .first_name +
                                                    " " +
                                                    providerListener
                                                        .representativeList[
                                                            indexSaveContact]
                                                        .last_name;
                                            contact.phones = [
                                              Item(
                                                  label: "mobile",
                                                  value: mobileNumber)
                                            ];
                                            contact.company = providerListener
                                                .companyDetails
                                                .organisation_name;
                                            await ContactsService.addContact(
                                                contact);

                                            Iterable<Contact> temp =
                                                await ContactsService
                                                    .getContactsForPhone(
                                                        mobileNumber);

                                            if (temp.length > 0) {
                                              print("******************added");
                                              //we have save log on server if saved
                                              connectCompanyWhatsAppWithSaveButton(
                                                  providerListener
                                                      .userprofileData.user,
                                                  providerListener
                                                      .representativeList[
                                                          indexSaveContact]
                                                      .user_id,
                                                  company_id,
                                                  providerListener
                                                          .representativeList[
                                                              indexSaveContact]
                                                          .mobile ??
                                                      "",
                                                  1);
                                            } else {}
                                          } catch (e) {
                                            print(e);
                                          }
                                        } else {
                                          //we have save log on server even if present in device as user may use other account in same device
                                          print("******************present");
                                          connectCompanyWhatsAppWithSaveButton(
                                              providerListener
                                                  .userprofileData.user,
                                              providerListener
                                                  .representativeList[
                                                      indexSaveContact]
                                                  .user_id,
                                              company_id,
                                              providerListener
                                                      .representativeList[
                                                          indexSaveContact]
                                                      .mobile ??
                                                  "",
                                              1);
                                        }
                                      } else {
                                        _handleInvalidPermissions(
                                            permissionStatus);
                                      }
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),*/
                          /*providerListener.companyDetails != null &&
                                  providerListener.representativeList.length >
                                      0 &&
                                  indexSaveContact != -1
                              ? Visibility(
                                  maintainState: true,
                                  maintainAnimation: true,
                                  visible: _visible4,
                                  child: WhatsAppReqSent(
                                    radius: radius,
                                    panelController: _pc4,
                                    closePressed: () {
                                      _pc4.close();
                                      _visible4 = false;
                                      _visible1 = true;
                                      setState(() {
                                        _pc1.open();
                                      });
                                    },
                                    whatsAppPressed: () {
                                      _pc4.close();
                                      _visible4 = false;
                                      _visible1 = true;
                                      setState(() {
                                        _pc1.open();
                                      });
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height: 7,
                                ),*/
                        ],
                      ),
                    )
                  : SizedBox(height: 1),
            ]),
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

class FavButton extends StatelessWidget {
  const FavButton({
    Key key,
    @required this.providerListener,
    this.onPressed,
    this.favButtonChild,
  }) : super(key: key);

  final CustomViewModel providerListener;
  final Function onPressed;
  final FavoriteButton favButtonChild;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints:
            BoxConstraints.tightFor(height: getProportionateScreenHeight(65)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: onPressed,
          child: Row(
            children: [
              favButtonChild,
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              Text(
                "#Add to Wishlist",
                style: GoogleFonts.poppins(
                  color: Color(0xFF9B9B9B),
                ),
              )
            ],
          ),
        ));
  }
}

class CallMeDialog extends StatelessWidget {
  const CallMeDialog({
    Key key,
    @required this.radius,
    this.closePressed,
    this.saveContactPressed,
    this.checkBoxChanged,
    this.isChecked,
  }) : super(key: key);

  final BorderRadiusGeometry radius;
  final Function closePressed, saveContactPressed, checkBoxChanged;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    return Container(
      padding: EdgeInsets.all(20),
      width: getProportionateScreenWidth(639),
      height: getProportionateScreenHeight(560),
      child: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  providerListener.companyDetails.organisation_name,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(16),
                ),
                Container(
                  height: getProportionateScreenHeight(44),
                  child: Text(
                    getTranslated(context, 'contactPopUpInfo') + " ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  providerListener.companyDetails.organisation_name,
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E3E3E)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  getTranslated(context, 'you_should_receive_a_call_from_them'),
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8E8E8E)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(19),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: getProportionateScreenWidth(45),
                      backgroundImage: NetworkImage(
                          providerListener.userprofileData.image_url ?? ""),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    FaIcon(
                      FontAwesomeIcons.share,
                      color: Colors.green,
                      size: 22,
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    CircleAvatar(
                      radius: getProportionateScreenWidth(45),
                      backgroundImage: NetworkImage(
                          providerListener.companyDetails.image_url ?? ""),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        activeColor: Color(COLOR_BACKGROUND),
                        checkColor: Colors.white,
                        value: isChecked,
                        onChanged: checkBoxChanged),
                    SizedBox(
                      width: getProportionateScreenWidth(5),
                    ),
                    Text(
                      getTranslated(context, 'do_not_show_this_message_again'),
                      style: GoogleFonts.poppins(
                        color: Color(0xFF8E8E8E),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          height: getProportionateScreenHeight(65),
                        ),
                        child: ElevatedButton(
                            onPressed: closePressed,
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                onPrimary: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Text(
                              getTranslated(context, 'no'),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300, fontSize: 20),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenHeight(10),
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: getProportionateScreenHeight(65)),
                        child: ElevatedButton(
                            onPressed: () {
                              print("findingid");
                              print(company_id);
                              Provider.of<CustomViewModel>(context,
                                      listen: false)
                                  .requestCallMe(
                                      providerListener.userprofileData.user,
                                      company_id,
                                      company_id)
                                  .then((value) {
                                toastCommon(context,
                                    getTranslated(context, 'callback_string'));
                                closePressed();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(35)),
                                          //this right here
                                          child: RequestSentDialog(
                                          ));
                                    });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF008940),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Text(
                              getTranslated(context, 'okay'),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: closePressed,
              icon: Icon(Icons.close),
              iconSize: getProportionateScreenHeight(40),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class RequestSentDialog extends StatelessWidget {
  const RequestSentDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(522),
      width: getProportionateScreenWidth(639),
      child: Stack(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Call back request sent successfully.",
                  style: GoogleFonts.poppins(
                      fontSize: getProportionateScreenHeight(29),
                      color: Color(0xFF008940)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(28),
                ),
                Icon(
                  Icons.check_circle_outline,
                  size: getProportionateScreenWidth(176),
                  color: Color(0xff008940),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                pop(context);
              },
              icon: Icon(Icons.close),
              iconSize: getProportionateScreenHeight(40),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class RepInformation extends StatelessWidget {
  const RepInformation({
    Key key,
    this.onWhatAppPressed,
    this.onCallPressed,
    this.representativeOBJ,
  }) : super(key: key);

  final Function onWhatAppPressed, onCallPressed;
  final RepresentativeListParser representativeOBJ;

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Container(
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: getProportionateScreenHeight(25),
                backgroundColor: Colors.white,
                backgroundImage: representativeOBJ.image_url != null
                    ? NetworkImage(representativeOBJ.image_url)
                    : AssetImage('assets/images/google.jpg'),
              ),
              SizedBox(
                width: getProportionateScreenWidth(15),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: getProportionateScreenWidth(200),
                    child: Text(
                      representativeOBJ.first_name +
                          " " +
                          representativeOBJ.last_name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      representativeOBJ.languages.split(",").length > 0
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFFF9FFCC),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: Text(
                                  representativeOBJ.languages.split(",")[0],
                                  style: TextStyle(
                                    fontSize: 9,
                                  )),
                            )
                          : SizedBox(
                              width: 1,
                            ),
                      SizedBox(
                        width: 9,
                      ),
                      representativeOBJ.languages.split(",").length > 1
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFFF9FFCC),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: Text(
                                  representativeOBJ.languages.split(",")[1],
                                  style: TextStyle(
                                    fontSize: 9,
                                  )),
                            )
                          : SizedBox(
                              width: 1,
                            ),
                      representativeOBJ.languages.split(",").length > 2
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFFF9FFCC),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: Text(
                                  representativeOBJ.languages.split(",")[2],
                                  style: TextStyle(
                                    fontSize: 9,
                                  )),
                            )
                          : SizedBox(
                              width: 1,
                            ),
                    ],
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              representativeOBJ.contact_phone == true
                  ? InkWell(
                      onTap: onCallPressed,
                      child: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Icon(
                          Icons.call,
                          color: Colors.green,
                          size: getProportionateScreenWidth(17),
                        ),
                        radius: getProportionateScreenWidth(15),
                      ),
                    )
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              representativeOBJ.contact_whatsapp == true
                  ? InkWell(
                      onTap: onWhatAppPressed,
                      child: CircleAvatar(
                        backgroundColor: representativeOBJ.status == "accepted"
                            ? Colors.green.shade100
                            : representativeOBJ.status == "not initiated"
                                ? Colors.grey.shade300
                                : representativeOBJ.status == "initiated"
                                    ? Colors.yellow.shade100
                                    : Colors.grey.shade300,
                        //have to change this to SVG as there are 3 colors assigned to this :
                        //"not Added" :grey , "Requested" : yellow , "Added" : "green"
                        child: representativeOBJ.status == "accepted"
                            ? Image.asset(
                                "assets/images/whatsapp.png",
                                height: getProportionateScreenWidth(15),
                              )
                            : representativeOBJ.status == "not initiated"
                                ? Image.asset(
                                    "assets/images/whatsappGrey.png",
                                    height: getProportionateScreenWidth(15),
                                  )
                                : representativeOBJ.status == "initiated"
                                    ? Image.asset(
                                        "assets/images/whatsappYellow.png",
                                        height: getProportionateScreenWidth(15),
                                      )
                                    : Image.asset(
                                        "assets/images/whatsappGrey.png",
                                        height: getProportionateScreenWidth(15),
                                      ),
                        radius: getProportionateScreenWidth(15),
                      ),
                    )
                  : SizedBox(
                      width: 1,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class CallMeButton extends StatelessWidget {
  const CallMeButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 365, height: 65),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Color(0xFFFFE867),
            onPrimary: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            textStyle:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.call),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(getTranslated(context, 'call_back_request'))
          ],
        ),
      ),
    );
  }
}

class ContactButton extends StatelessWidget {
  const ContactButton({
    Key key,
    this.onPressed,
    this.colorText,
  }) : super(key: key);

  final Function onPressed;
  final int colorText;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: getProportionateScreenHeight(65)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: Color(colorText),
              elevation: 1,
              padding: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.call),
              SizedBox(
                width: 10,
              ),
              Text(
                getTranslated(context, 'contact'),
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
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
    final providerListener = Provider.of<CustomViewModel>(context);

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
        onPressed: () async {
          final RenderBox box = context.findRenderObject();
          if (Platform.isAndroid) {
            var response = await http.get(
                Uri.parse((providerListener.companyDetails.image_url ?? "")));
            final documentDirectory =
                (await getExternalStorageDirectory()).path;
            File imgFile = new File('$documentDirectory/' +
                providerListener.companyDetails.organisation_name +
                ".png");
            imgFile.writeAsBytesSync(response.bodyBytes);

            Share.shareFiles([
              "${documentDirectory}/" +
                  providerListener.companyDetails.organisation_name +
                  ".png"
            ],
                text:
                    'Hi, found this intresting company on KISAN app. Check it out ' +
                        (providerListener.companyDetails.organisation_name ??
                            "") +
                        ' on kisan app');
          } else {
            Share.share(
                'Hi, found this intresting company on KISAN app. Check it out ' +
                    (providerListener.companyDetails.organisation_name ?? "") +
                    ' on kisan app',
                subject: (providerListener.companyDetails.image_url ?? ""),
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
          }
        },
        child: Icon(
          Icons.share,
          color: Colors.black,
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            //width: 55,
            height: 55,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20),
                side: BorderSide(color: Color(0xFFBFE5D1)),
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
        ),
        SizedBox(
          width: 10,
        ),
        Text(text ?? "",
            style: GoogleFonts.poppins(color: Color(0xFF4A4A4A), fontSize: 16))
      ],
    );
  }
}

class CallMeSlide extends StatelessWidget {
  const CallMeSlide({
    Key key,
    @required this.radius,
    this.panelController,
    this.closePressed,
    this.saveContactPressed,
    this.checkBoxChanged,
    this.isChecked,
  }) : super(key: key);

  final BorderRadiusGeometry radius;
  final PanelController panelController;
  final Function closePressed, saveContactPressed, checkBoxChanged;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SlidingUpPanel(
      controller: panelController,
      maxHeight: 550,
      borderRadius: radius,
      panel: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: IconButton(
                onPressed: closePressed,
                icon: Icon(Icons.close),
                iconSize: 40,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              providerListener.companyDetails.organisation_name,
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 44,
              child: Text(
                getTranslated(context, 'contactPopUpInfo') + " ",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              providerListener.companyDetails.organisation_name ?? "",
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E3E3E)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              getTranslated(context, 'you_should_receive_a_call_from_them'),
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8E8E8E)),
            ),
            SizedBox(
              height: 19,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                      providerListener.userprofileData.image_url ?? ""),
                ),
                SizedBox(
                  width: 14,
                ),
                FaIcon(
                  FontAwesomeIcons.share,
                  color: Colors.green,
                  size: 22,
                ),
                SizedBox(
                  width: 14,
                ),
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                      providerListener.companyDetails.image_url ?? ""),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    activeColor: Color(COLOR_BACKGROUND),
                    checkColor: Colors.white,
                    value: isChecked,
                    onChanged: checkBoxChanged),
                SizedBox(
                  width: 5,
                ),
                Text(
                  getTranslated(context, 'do_not_show_this_message_again'),
                  style: GoogleFonts.poppins(
                    color: Color(0xFF8E8E8E),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: 65,
                    ),
                    child: ElevatedButton(
                        onPressed: closePressed,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onPrimary: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Text(
                          getTranslated(context, 'no'),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300, fontSize: 20),
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 65),
                    child: ElevatedButton(
                        onPressed: () {
                          print("findingid");
                          print(company_id);
                          Provider.of<CustomViewModel>(context, listen: false)
                              .requestCallMe(
                                  providerListener.userprofileData.user,
                                  company_id,
                                  company_id)
                              .then((value) {
                            toastCommon(context,
                                getTranslated(context, 'callback_string'));
                            closePressed();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF008940),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Text(
                          getTranslated(context, 'okay'),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SaveContact extends StatefulWidget {
  const SaveContact({
    Key key,
    @required this.radius,
    this.name,
    this.org_name,
    this.panelController,
    this.closePressed,
    this.saveContactPressed,
    this.image_url,
  }) : super(key: key);

  final PanelController panelController;
  final Function closePressed, saveContactPressed;
  final String name, org_name, image_url;

  final BorderRadiusGeometry radius;

  @override
  _SaveContactState createState() => _SaveContactState();
}

class _SaveContactState extends State<SaveContact> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: widget.panelController,
      minHeight: 550,
      maxHeight: 550,
      borderRadius: widget.radius,
      panel: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CloseButton(
              onPressed: widget.closePressed,
            ),
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(widget.image_url),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.name,
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E3E3E)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.org_name,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            Flexible(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                        getTranslated(context, 'save_contact_text').toString() +
                            "\n",
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.black),
                    children: [
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Image.asset(
                              "assets/images/whatsapp.png",
                              height: 18,
                            ),
                          )),
                      TextSpan(
                          text: "WhatsApp.",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF58C12A)))
                    ]),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              getTranslated(context, 'request_save_contact')
                  .replaceAll('{userNameText}', widget.name),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            Spacer(),
            ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(height: 65, width: double.infinity),
              child: ElevatedButton(
                  onPressed: widget.saveContactPressed,
                  style: ElevatedButton.styleFrom(
                      primary: Color(COLOR_BACKGROUND),
                      onPrimary: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Text(
                    getTranslated(context, 'save_contact'),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class WhatsAppReqSent extends StatelessWidget {
  const WhatsAppReqSent({
    Key key,
    @required this.radius,
    this.panelController,
    this.closePressed,
    this.whatsAppPressed,
  }) : super(key: key);

  final BorderRadiusGeometry radius;
  final PanelController panelController;
  final Function closePressed, whatsAppPressed;

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SlidingUpPanel(
      controller: panelController,
      maxHeight: 550,
      minHeight: 550,
      borderRadius: radius,
      panel: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CloseButton(
              onPressed: closePressed,
            ),
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage((providerListener
                      .representativeList[indexSaveContact].image_url ??
                  "")),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              (providerListener
                          .representativeList[indexSaveContact].first_name ??
                      "") +
                  " " +
                  (providerListener
                          .representativeList[indexSaveContact].last_name ??
                      ""),
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E3E3E)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              (providerListener.companyDetails.organisation_name ?? ""),
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            Icon(
              Icons.check,
              color: Color(0xFF47AF1A),
              size: 80,
            ),
            Text(
              getTranslated(context, 'request_save_contact').replaceAll(
                  '{userNameText}',
                  (providerListener
                          .representativeList[indexSaveContact].first_name ??
                      "")) /* +
                  ". You will be able to connect "
                      "on WhatsApp once he accepts it."*/
              ,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            Spacer(),
            ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(height: 65, width: double.infinity),
              child: ElevatedButton(
                  onPressed: whatsAppPressed,
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF1FFEB),
                      onPrimary: Color(0xFF47AF1A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: getTranslated(context, 'okay'),
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF58C12A)))
                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderTexts extends StatelessWidget {
  const HeaderTexts({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          color: Color(0xFF535050), fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}
