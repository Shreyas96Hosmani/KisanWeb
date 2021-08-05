import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;
import 'package:kisanweb/UI/Auth/LoginWithOTP.dart';
import 'package:kisanweb/UI/Auth/SuccessOTP.dart';
import 'package:kisanweb/UI/HomeScreen/HomeScreen.dart';
import 'package:kisanweb/UI/Profile/BasicProfile.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import '../../Helpers/helper.dart';

class ExistingAccount extends StatefulWidget {
  @override
  _ExistingAccountState createState() => _ExistingAccountState();
}

class _ExistingAccountState extends State<ExistingAccount> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

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
                    getTranslated(context, 'accountexist'),
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
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 20),
                    child: Text(
                      (getTranslated(context, 'we_already_have_an_account_with') ?? ""),
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          letterSpacing: 1,
                          fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: getProportionateScreenWidth(350),
                        height: getProportionateScreenHeight(80)),
                    child: ElevatedButton(
                      onPressed: () {
                        pop(context);
                        pop(context);
                        pushReplacement(
                            context, HomeScreen("HomeScreen", 0, 0));
                        /*Provider.of<CustomViewModel>(context, listen: false)
                            .UpdateProfileDataAfterGoogleAuth(
                                providerListener.googleFName,
                                providerListener.googleLName,
                                "otp",
                                providerListener.googleEmail,
                                "google",
                                true,
                                providerListener.googleImageUrl)
                            .then((value) {
                          setState(() {
                            if (value == "error") {
                              //for unexpected error
                              toastCommon(context, getTranslated(context, 'tryAgain'));
                            } else if (value == "success") {
                              pop(context);
                              pop(context);
                              pushReplacement(context, HomeScreen("HomeScreen", 0, 0));
                            } else {
                              toastCommon(context, getTranslated(context, 'tryAgain'));
                            }
                          });
                        });*/
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff08763F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              child: ClipOval(
                                child: Image.network(
                                    providerListener.tempProfileLink??""),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated(context, 'LoginAs') +
                                      providerListener.tempFName +
                                      " " +
                                      providerListener.tempLName,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  (getTranslated(context, 'email') ?? "") +
                                      " - " +
                                      providerListener.tempEmail,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth / 5,
                        height: 1,
                        color: Color(0xff08763F),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'or'),
                        style: GoogleFonts.poppins(color: Color(0xff08763F)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: screenWidth / 5,
                        height: 1,
                        color: Color(0xff08763F),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: getProportionateScreenWidth(350),
                        height: getProportionateScreenHeight(80)),
                    child: ElevatedButton(
                        onPressed: () {
                          push(context, LoginWithOTP());
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFFE44E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black,
                                backgroundImage:
                                AssetImage('assets/images/defaultProfile.png'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (getTranslated(
                                        context, 'createanewaccount') ??
                                        ""),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    (getTranslated(context,
                                        'by_entering_new_mobile_number') ??
                                        ""),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
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
