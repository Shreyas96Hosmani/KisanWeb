import 'package:firebase_auth/firebase_auth.dart';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;
import 'package:kisanweb/Helpers/images.dart' as images;
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/HomeScreen/HomeScreen.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';
import '../../Helpers/helper.dart';
import 'LoginWithOTP.dart';

import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  //clientId: '379951119240-15s4lmkvm0qn5kfc16cknhtamgkrlumc.apps.googleusercontent.com',

  //Dev:
  //clientId: '379951119240-tkmkpj996t81g2kqn9qbvdblbht3c8n9.apps.googleusercontent.com',
  // test
  clientId:
      '799381838308-a3u082djeh350q0fqh3iet78sf3al4nr.apps.googleusercontent.com',
  //prod
  //clientId: '143325684355-sjmtmsj8rpj73q1pon9qnf3gcmcu2dft.apps.googleusercontent.com',

  scopes: <String>['email'],
);

class SocialAuth extends StatefulWidget {
  @override
  _SocialAuthState createState() => _SocialAuthState();
}

class _SocialAuthState extends State<SocialAuth> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
//    try {
//      _googleSignIn.disconnect();
//    } catch (e) {}
  }

  /*
  Future<void> _handleSignIn() async {
    var fcm_id = await FirebaseMessaging.instance.getToken();

    try {
      try {
        _googleSignIn.disconnect();
      } catch (e) {}
      await _googleSignIn.signIn().then((value) {
        setState(() {
          Provider.of<CustomViewModel>(context, listen: false).setGoogleData(
              _googleSignIn.currentUser.email,
              _googleSignIn.currentUser.displayName,
              _googleSignIn.currentUser.photoUrl);

          value.authentication.then((googleKey) {
            print(_googleSignIn.clientId);
            print(googleKey.accessToken);
            print("token: " + googleKey.idToken);
            setState(() {
              _GoogleLogin(googleKey.idToken.toString(), fcm_id);
            });
          }).catchError((err) {
            print('inner error');
          });
        });
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _GoogleLogin(String google_id_token, String fcm_id) async {
    Provider.of<CustomViewModel>(context, listen: false)
        .GoogleLogin(google_id_token, fcm_id)
        .then((value) {
      setState(() {
        if (value == "error") {
          toastCommon(context, "Check internet or try after sometime");
        } else if (value == "success") {
          push(context, HomeScreen("HomeScreen", 0, 0));
        } else {
          if (value == "Account does not exists for given google email") {
            push(context, LoginWithOTP());
          } else {
            toastCommon(context, "Please try again or use different email");
          }
        }
      });
    });
  }

   */

  @override
  Widget build(BuildContext context) {
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
                      Icons.login_rounded,
                      color: Color(constants.COLOR_WHITE),
                    )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    getTranslated(context, 'sign_up_login'),
                    style: GoogleFonts.poppins(
                        fontSize: getProportionateScreenHeight(23),
                        color: Color(constants.COLOR_WHITE),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )));
    }

    buildLanguagaeWidget(BuildContext context) {
      return Container(
        height: 500,
        width: 350,
        padding:
            EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            color: Color(constants.COLOR_WHITE),
            borderRadius: BorderRadius.circular(25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/greenKisan_Logo.svg",height: getProportionateScreenHeight(65),),
            SizedBox(
              height: (20),
            ),
            Container(
              child: Text(
                getTranslated(context, 'welcome') +
                    "\n" +
                    getTranslated(context, 'lets_get_you_started'),
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: GoogleFonts.poppins(
                  fontSize: getProportionateScreenHeight(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Provider.of<CustomViewModel>(context, listen: false)
                          .setGoogleData("", "", "")
                          .then((value) {
                        push(context, LoginWithOTP());
                      });
                    },
                    child: Container(
                        height: (60),
                        width: (320),
                        decoration: BoxDecoration(
                          color: Color(constants.COLOR_BACKGROUND),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 2,
                            ),
                            Container(
                              height: (55),
                              width: (55),
                              color: Colors.white,
                              child: Center(
                                child: Icon(
                                  Icons.phone_android_rounded,
                                  color: Color(constants.COLOR_BACKGROUND),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                getTranslated(context, 'enter_using_mobile'),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1,
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: (18),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: getProportionateScreenWidth(65),
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'or'),
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: getProportionateScreenWidth(65),
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      // _handleSignIn();
                    },
                    child: Container(
                        height: (60),
                        width: (320),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 2,
                            ),
                            Container(
                              height: (55),
                              width: (55),
                              color: Colors.white,
                              child: Center(
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(images.googleLogo)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                getTranslated(context, 'sign_up_with_google'),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenHeight(18),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth / 3,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'or'),
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: screenWidth / 3,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 60,
                      width: screenWidth / 1.3,
                      decoration: BoxDecoration(
                        color: Color(constants.COLOR_BACKGROUND_OPPOSITE),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 2,
                          ),
                          Container(
                            height: 55,
                            width: 55,
                            color: Colors.white,
                            child: Center(
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                      "assets/images/apple-logo.png")),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Sign up with Apple",
                            textAlign: TextAlign.center,
                            textScaleFactor: 1,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),*/
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff08763F),
      body: Container(
          color: Color(0xFFF3FFF0),
          child: Center(
              child: Container(
                  child: buildLanguagaeWidget(context)
              )
          )
      ),
    );
  }
}
