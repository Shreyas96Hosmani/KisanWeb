import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/images.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/Auth/EnterOTP.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;

import '../../Helpers/helper.dart';
import '../../Helpers/size_config.dart';

bool _isChecked = false;

class LoginWithOTP extends StatefulWidget {
  @override
  _LoginWithOTPState createState() => _LoginWithOTPState();
}

class _LoginWithOTPState extends State<LoginWithOTP> {
  String countryCode = '+91';
  String errorMessage = '';

  TextEditingController phoneController = TextEditingController();

  void _onCountryChange(CountryCode countryCode) {
    print("New Country selected: " + countryCode.toString());
    setState(() {
      this.countryCode = countryCode.toString();
    });
  }

  Future<void> _sendOTP() async {
    Provider.of<CustomViewModel>(context, listen: false)
        .sendOTP(this.countryCode + phoneController.text.toString(),
            _isChecked ? "OTP_IN" : "OTP_OUT")
        .then((value) {
      universalLoader.hide();
      setState(() {
        if (value == "error") {
          //for unexpected error
          errorMessage = "Check internet or try after sometime";
        } else if (value == "Verification code sent") {
          push(context, EnterOTP(phoneController.text.toString()));
        } else {
          errorMessage = value;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isChecked = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    universalLoader = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    SizeConfig().init(context);

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
                    getTranslated(context, 'enter_mobile'),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Color(constants.COLOR_WHITE)),
                  ),
                ],
              )));
    }

    return Scaffold(
      backgroundColor: Color(0xff08763F),
      body: Container(
        color: Color(0xFF3FFF0),
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/icons/white_kisan_logo.svg",
                  width: 190,
                  height: 70,),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 400,
                  height: 600,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60,),
                        child: Text(
                          parseHtmlString(getTranslated(context,
                              'please_enter_your_mobile_number_n_we_will_send_'
                                  'a_6_digit_code_non_this_number_for_verification')),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Color(0xff696969),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (32),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 1,
                            child: Container(
                              height: 40,
                              child: CountryCodePicker(
                                onChanged: _onCountryChange,
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'IN',
                                favorite: ['+91', 'IN'],
                                enabled: false,
                                textStyle: GoogleFonts.poppins(
                                    fontSize: 14, color: Color(COLOR_TEXT_BLACK)),
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
                              ),
                            ),
                          ),
                          Container(
                            width: 210,
                            height: 40,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              controller: phoneController,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              decoration: new InputDecoration(
                                  filled: true,
                                  counterText: "",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                  hintText: getTranslated(context, 'mobile_number'),
                                  fillColor: Color(COLOR_WHITE)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   errorMessage,
                      //   textAlign: TextAlign.center,
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 14,
                      //     color: Colors.red[300],
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                           setState(() {
                            _isChecked = !_isChecked;
                          });
                           if (_isChecked==false) {
                             showDialog(
                                 context: context,
                                 builder: (BuildContext context) {
                                   return Dialog(
                                     shape: RoundedRectangleBorder(
                                         borderRadius:
                                         BorderRadius.circular(7)),
                                     //this right here
                                     child: WAPopupConfirmation(
                                       onCancelPressed: (){
                                         setState(() {
                                           _isChecked = true;
                                         });
                                         pop(context);
                                       },
                                     ),
                                   );
                                 });
                           }
                        },
                        child: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                activeColor: Color(constants.COLOR_BACKGROUND),
                                checkColor: Colors.white,
                                value: _isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked = !_isChecked;
                                  });
                                  if (!_isChecked) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            //this right here
                                            child: WAPopupConfirmation(
                                              onCancelPressed: (){
                                                setState(() {
                                                  _isChecked = true;
                                                });
                                                pop(context);
                                              },
                                            ),
                                          );
                                        });
                                  }
                                }),
                            Flexible(
                              child: Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                    text: getTranslated(
                                        context, 'receive_otp_amp_updates_on'),
                                  ),
                                  WidgetSpan(
                                      child: SizedBox(
                                    width: (10),
                                  )),
                                  WidgetSpan(
                                    child: Image.asset(
                                      "assets/images/whatsapp.png",
                                      width: 20,
                                    ),
                                  ),
                                  WidgetSpan(
                                      child: SizedBox(
                                    width: (10),
                                  )),
                                  TextSpan(
                                    text: getTranslated(context, 'whatsapp'),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700),
                                  ),
                                ]),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        )),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: 320,
                            height: 60),
                        child: ElevatedButton(
                          onPressed: () {
                            if (phoneController.text.toString() == "") {
                              Fluttertoast.showToast(
                                msg: getTranslated(context,
                                    'please_enter_the_valid_mobile_number'),
                                backgroundColor: Colors.white,
                                textColor: Colors.red[800],
                              );
                            } else if (phoneController.text.length > 10 ||
                                phoneController.text.length < 10) {
                              Fluttertoast.showToast(
                                msg: getTranslated(
                                    context, 'mobile_number_should_have_10digits'),
                                backgroundColor: Colors.white,
                                textColor: Colors.red[800],
                              );
                            } else {
                              universalLoader.show();
                              _sendOTP();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFFE44E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            getTranslated(context, 'continue_new'),
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                        TextSpan(
                          text: getTranslated(context,
                                  'by_clicking_on_this_button_you_agree_with_the') +
                              " ",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xffCECECE)),
                          children: <TextSpan>[
                            TextSpan(
                                text: getTranslated(context, 'terms_conditions'),
                                style: GoogleFonts.poppins(
                                  decoration: TextDecoration.underline,
                                )),
                            TextSpan(
                                text: '\n' + getTranslated(context, 'and') + ' ',
                                style: GoogleFonts.poppins()),
                            TextSpan(
                                text:
                                    getTranslated(context, 'privacy_policy') + " ",
                                style: GoogleFonts.poppins(
                                  decoration: TextDecoration.underline,
                                )),
                            TextSpan(
                              text: getTranslated(context, 'of_kisan'),
                            ),
                            // can add more TextSpans here...
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 65,
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
                            width: 65,
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
                            height: 60,
                            width: 320,
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
                                  height: 55,
                                  width: 55,
                                  color: Colors.white,
                                  child: Center(
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        child: Image.asset(googleLogo)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    getTranslated(context, 'sign_up_with_google'),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WAPopupConfirmation extends StatefulWidget {
  const WAPopupConfirmation({Key key, this.onPressed, this.onCancelPressed})
      : super(key: key);

  final Function onPressed, onCancelPressed;

  @override
  _WAPopupConfirmationState createState() => _WAPopupConfirmationState();
}

class _WAPopupConfirmationState extends State<WAPopupConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 418,
      width: 331,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: (45),
                vertical: (18)),
            child: Column(
              children: [
                Text(
                  getTranslated(context, 'are_you_sure'),
                  style: GoogleFonts.poppins(
                      fontSize: (22),
                      color: Color(0xFF08763F),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: (24),
                ),
                Text(
                  getTranslated(context, 'opt_out_message'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: (18),
                      color: Color(0xFF676767),
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: (24),
                ),
                Text(
                  getTranslated(context, 'do_you_really_want_to'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: (18),
                      color: Color(0xFF676767),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: (13),
                ),
                Container(
                  height: (76),
                  width: (240),
                  padding: EdgeInsets.symmetric(
                      horizontal: (42),
                      vertical: (15)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFFF7F7F7)),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: getTranslated(context, 'you_can_opt_in_again'),
                      style: GoogleFonts.poppins(
                          color: Color(0xFF676767),
                          fontWeight: FontWeight.normal,
                          fontSize: (15)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                  child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    height: (66)),
                child: ElevatedButton(
                  onPressed: widget.onCancelPressed,
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Color(0xFF676767),
                      elevation: 0,
                      textStyle: GoogleFonts.poppins(
                        fontSize: (18),
                      )),
                  child: Text(getTranslated(context, 'CANCEL') ?? "Cancel"),
                ),
              )),
              Expanded(
                  child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    height: (66)),
                child: ElevatedButton(
                  onPressed: () {
                    pop(context);
                    widget.onPressed;
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Color(0xFFFD6060),
                      elevation: 0,
                      textStyle: GoogleFonts.poppins(
                        fontSize: (18),
                      )),
                  child: Text(getTranslated(context, 'yes_confirm')),
                ),
              )),
            ],
          )
        ],
      ),
    );
  }
}
