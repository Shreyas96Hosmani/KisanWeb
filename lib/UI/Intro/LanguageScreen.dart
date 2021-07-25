import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;
import 'package:kisanweb/Helpers/images.dart' as images;
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/Auth/SocialAuth.dart';
import 'package:kisanweb/UI/HomeScreen/HomeScreen.dart';
import 'package:kisanweb/UI/Intro/splash_page_view_builder.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:kisanweb/main.dart';

import '../../Helpers/helper.dart';

class LanguageScreen extends StatefulWidget {
  final id;

  LanguageScreen(this.id);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    buildTopWidget(BuildContext context) {
      return Container(
        height: screenHeight / 3,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Color(constants.COLOR_BACKGROUND),
        ),
        child: Center(
          child: Container(
            child: SvgPicture.asset(
              "assets/icons/white_kisan_logo.svg",
              height: getProportionateScreenHeight(92),
            ),
          ),
        ),
      );
    }

    buildLanguagaeWidget(BuildContext context) {
      return Container(
        height: 500,
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Color(constants.COLOR_WHITE),
            borderRadius: BorderRadius.circular(25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                getTranslated(context, 'language_select_text'),
                textScaleFactor: 1,
                style: GoogleFonts.poppins(
                  fontSize: 21,
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(60),),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Locale _locale = await setLocale('mr');
                      MyApp.setLocale(context, _locale);

                      if (widget.id == 1) {
                        push(context, SplashPageViewBuilder());
                      } else {
                        pop(context);
                      }
                    },
                    child: Container(
                      height: 60,
                      width: screenWidth / 2,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Text(
                          "मराठी",
                          textScaleFactor: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      Locale _locale = await setLocale('hi');
                      MyApp.setLocale(context, _locale);
                      if (widget.id == 1) {
                        push(context, SocialAuth());
                      } else {
                        pop(context);
                      }
                    },
                    child: Container(
                      height: 60,
                      width: screenWidth / 2,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Text(
                          "हिन्दी",
                          textScaleFactor: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      Locale _locale = await setLocale('en');
                      MyApp.setLocale(context, _locale);

                      if (widget.id == 1) {
                        push(context, SocialAuth());
                        //push(context, SplashPageViewBuilder());
                      } else {
                        pop(context);
                      }
                    },
                    child: Container(
                      height: 60,
                      width: screenWidth / 2,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Text(
                          "English",
                          textScaleFactor: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    buildTopWidget2(BuildContext context) {
      return Container(
        height: screenHeight / 3,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Color(constants.COLOR_BACKGROUND),
        ),
        child: Center(
          child: Container(
            child: SvgPicture.asset(
              "assets/icons/white_kisan_logo.svg",
              height: getProportionateScreenHeight(92),
            ),
          ),
        ),
      );
    }

    buildLanguagaeWidget2(BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(top: screenHeight / 3),
        child: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
              color: Color(constants.COLOR_WHITE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Stack(
            children: [

              Positioned(
                top: screenHeight / 20,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    getTranslated(context, 'language_select_text'),
                    textScaleFactor: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight / 5,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          Locale _locale = await setLocale('mr');
                          MyApp.setLocale(context, _locale);

                          if (widget.id == 1) {
                            push(context, SplashPageViewBuilder());
                          } else {
                            pop(context);
                          }
                        },
                        child: Container(
                          height: 60,
                          width: screenWidth / 2,
                          decoration: BoxDecoration(
                              color: Color(0xffF4F4F4),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          child: Center(
                            child: Text(
                              "मराठी",
                              textScaleFactor: 1,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          Locale _locale = await setLocale('hi');
                          MyApp.setLocale(context, _locale);
                          if (widget.id == 1) {
                            push(context, SplashPageViewBuilder());
                          } else {
                            pop(context);
                          }
                        },
                        child: Container(
                          height: 60,
                          width: screenWidth / 2,
                          decoration: BoxDecoration(
                              color: Color(0xffF4F4F4),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          child: Center(
                            child: Text(
                              "हिन्दी",
                              textScaleFactor: 1,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          Locale _locale = await setLocale('en');
                          MyApp.setLocale(context, _locale);

                          if (widget.id == 1) {
                            push(context, SplashPageViewBuilder());
                          } else {
                            pop(context);
                          }
                        },
                        child: Container(
                          height: 60,
                          width: screenWidth / 2,
                          decoration: BoxDecoration(
                              color: Color(0xffF4F4F4),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          child: Center(
                            child: Text(
                              "English",
                              textScaleFactor: 1,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(constants.COLOR_BACKGROUND),
      body: ResponsiveWidget.isSmallScreen(context) ? Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: buildTopWidget(context),
          ),
          Center(child: buildLanguagaeWidget(context)),
        ],
      ) : Container(
          child: Center(
            child: Container(
                child: buildLanguagaeWidget(context)),
          )),
    );
  }
}
