import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/images.dart' as images;
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
//import 'package:kisanweb/UI/BannerEvents/event_page.dart';
//import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/HomeScreen/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helpers/helper.dart';
import 'LanguageScreen.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;

class InitialScreen extends StatefulWidget {
  String where;
  int id1, id2;

  InitialScreen(this.where, this.id1, this.id2);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  jumpScreen() {
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString('token') ?? "";

      if (token != "") {
        pushReplacement(
            context, HomeScreen(widget.where, widget.id1, widget.id2));
      } else {
        pushReplacement(context, LanguageScreen(1));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    jumpScreen();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(constants.COLOR_BACKGROUND),
      body: ResponsiveWidget.isSmallScreen(context) ? Center(
        child: SvgPicture.asset(
          "assets/icons/white_kisan_logo.svg",
          height: getProportionateScreenHeight(92),
          width: getProportionateScreenWidth(214),
        ),
      ) : Center(
        child: Container(
          child: SvgPicture.asset(
            "assets/icons/white_kisan_logo.svg",
            height: getProportionateScreenHeight(92),
            width: getProportionateScreenWidth(214),
          ),
        ),
      ),
    );
  }
}
