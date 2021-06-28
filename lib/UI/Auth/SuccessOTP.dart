import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;
import 'package:kisanweb/UI/Profile/BasicProfile.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import '../../Helpers/helper.dart';

String first_name = "", last_name = "", email = "", image_url = "";

class SuccessOTP extends StatefulWidget {
  @override
  _SuccessOTPState createState() => _SuccessOTPState();
}

class _SuccessOTPState extends State<SuccessOTP> {
  jumpScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      pushReplacement(context,
          BasicProfile(first_name, last_name, email, image_url, null, null));
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

    final providerListener = Provider.of<CustomViewModel>(context);

    setState(() {
      first_name = providerListener.googleFName;
      last_name = providerListener.googleLName;
      email = providerListener.googleEmail;
      image_url = providerListener.googleImageUrl;
    });

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    buildTopWidget(BuildContext context) {
      return Container(
          height: screenHeight / 6,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Color(0xff08763F),
          ),
          child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: screenWidth / 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Color(0xff1F8F4E),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.phone_android_rounded,
                      color: Color(constants.COLOR_WHITE),
                    )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    getTranslated(context, 'verify'),
                    style: GoogleFonts.poppins(
                        fontSize: 22, color: Color(constants.COLOR_WHITE)),
                  ),
                ],
              )));
    }

    return Scaffold(
      backgroundColor: Color(0xff08763F),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: buildTopWidget(context),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight / 6),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35),
                      topLeft: Radius.circular(35)),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Mobile number verified",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff008940),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.check_circle_outline,
                    size: 200,
                    color: Color(0xff008940),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  JumpingDotsProgressIndicator(
                    fontSize: 50.0,
                    color: Color(0xff008940),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Please wait...",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff008940),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
