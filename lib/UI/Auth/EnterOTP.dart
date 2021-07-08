import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/Auth/ExistingAccount.dart';
import 'package:kisanweb/UI/Auth/SuccessOTP.dart';
import 'package:kisanweb/UI/HomeScreen/HomeScreen.dart';
import 'package:kisanweb/UI/Widgets/ScreenHeader.dart';
import 'package:kisanweb/UI/Widgets/countdown_timer_widget.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;

import '../../Helpers/helper.dart';

bool startTimings = false;

class EnterOTP extends StatefulWidget {
  final phoneNo;

  EnterOTP(this.phoneNo) : super();

  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  String countryCode = '+91';
  String phoneNo;
  String errorMessage = '';
  String pinCode = '';
  bool _isChecked = false;
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode focus3 = FocusNode();
  FocusNode focus4 = FocusNode();
  FocusNode focus5 = FocusNode();
  FocusNode focus6 = FocusNode();

  TextEditingController oneController = TextEditingController();
  TextEditingController twoController = TextEditingController();
  TextEditingController threeController = TextEditingController();
  TextEditingController fourController = TextEditingController();
  TextEditingController fiveController = TextEditingController();
  TextEditingController sixController = TextEditingController();

  TextEditingController pinController = TextEditingController();

  //to use previous type of Textfield just uncomment the commented part and
  //remove pincode
  Future<void> _verifyOTP() async {
    Provider.of<CustomViewModel>(context, listen: false).verifyOTP(
        /*oneController.text +
        twoController.text +
        threeController.text +
        fourController.text +
        fiveController.text +
        sixController.text*/
        pinCode).then((value) {
      universalLoader.hide();
      setState(() {
        if (value == "error") {
          //for unexpected error
          errorMessage = getTranslated(context, 'tryAgain');
        } else if (value == "This is signup.") {
          pushReplacement(context, SuccessOTP());
        } else if (value == "User authenticated successfully.") {
          pop(context);
          pushReplacement(context, HomeScreen("HomeScreen", 0, 0));
        } else {
          //for expected errors
          errorMessage = getTranslated(context, 'invalidotp');
        }
      });
    });
  }

  Future<void> _verifyOTPAfterGoogleAUth() async {
    Provider.of<CustomViewModel>(context, listen: false).verifyOTPAfterGoogleAUth(
        /*oneController.text +
            twoController.text +
            threeController.text +
            fourController.text +
            fiveController.text +
            sixController.text*/
        pinCode).then((value) {
      universalLoader.hide();
      setState(() {
        print(value);
        if (value == "error") {
          //for unexpected error
          errorMessage = getTranslated(context, 'tryAgain');
        } else if (value == "This is signup.") {
          pushReplacement(context, SuccessOTP());
        } else if (value == "User authenticated successfully.") {
          pop(context);
          pushReplacement(context, HomeScreen("HomeScreen", 0, 0));
        } else if (value == "email is present") {
          push(context, ExistingAccount());
        } else {
          //for expected errors
          errorMessage = getTranslated(context, 'invalidotp');
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isChecked = true;
      startTimings = false;
      focus1.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    universalLoader = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    SizeConfig().init(context);

    final providerListener = Provider.of<CustomViewModel>(context);
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
                      Icons.chat,
                      color: Color(constants.COLOR_WHITE),
                    )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    getTranslated(context, 'verify'),
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Color(constants.COLOR_WHITE),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )));
    }

    buildTimerWidget(BuildContext context) {
      return CountDownTimer(
        secondsRemaining: 90,
        whenTimeExpires: () {
          setState(() {
            startTimings = false;
          });
        },
        countDownTimerStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff08763F),
      body: Container(
        color: Color(0xFF3FFF0),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset("assets/icons/white_kisan_logo.svg",
                width: 190,
                height: 70,),
              SizedBox(
                height: 15,
              ),
              Container(
                width:400,
                height: 600,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
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
                        getTranslated(context, 'enter_mo_no'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Color(0xff696969),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        "+91  " +
                            widget.phoneNo.toString().substring(0, 5) +
                            "  " +
                            widget.phoneNo.toString().substring(5),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Color(0xff08763F),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffEFEFEF),
                              border: Border.all(color: Color(0xffE5E5E5)),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: oneController,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                    // for mobile
                                  ],
                                  focusNode: focus1,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      focus1.unfocus();
                                      focus2.requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffEFEFEF),
                              border: Border.all(color: Color(0xffE5E5E5)),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                  focusNode: focus2,
                                  controller: twoController,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                    // for mobile
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      focus2.unfocus();
                                      focus3.requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffEFEFEF),
                              border: Border.all(color: Color(0xffE5E5E5)),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                  focusNode: focus3,
                                  controller: threeController,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                    // for mobile
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      focus3.unfocus();
                                      focus4.requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffEFEFEF),
                              border: Border.all(color: Color(0xffE5E5E5)),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                  focusNode: focus4,
                                  controller: fourController,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                    // for mobile
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      focus4.unfocus();
                                      focus5.requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffEFEFEF),
                              border: Border.all(color: Color(0xffE5E5E5)),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                  focusNode: focus5,
                                  controller: fiveController,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                    // for mobile
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      focus5.unfocus();
                                      focus6.requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffEFEFEF),
                              border: Border.all(color: Color(0xffE5E5E5)),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                  focusNode: focus6,
                                  controller: sixController,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(1),
                                    // for mobile
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      focus6.unfocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: PinCodeTextField(
                        length: 6,
                        appContext: context,
                        animationType: AnimationType.fade,
                        pastedTextStyle:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            borderWidth: 2,
                            inactiveColor: Color(0xffdedede),
                            selectedColor: Color(0xffdedede),
                            activeColor: Colors.green),
                        controller: pinController,
                        onCompleted: (v) {
                          pinCode = pinController.text;
                          print(pinCode);
                        },
                        // onTap: () {
                        //   print("Pressed");
                        // },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            pinCode = value;
                          });
                        },
                      ),
                    ),
                    /*InkWell(
                      onTap: () {
                        setState(() {
                          startTimings = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          startTimings == true
                              ? Text(
                                  "Resend code",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[300],
                                  ),
                                )
                              : Text(
                                  "I didn't get the code",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Color(0xff838383),
                                  ),
                                ),
                          startTimings == true
                              ? SizedBox(
                                  width: 10,
                                )
                              : Container(),
                          startTimings == true
                              ? buildTimerWidget(context)
                              : Container(),
                        ],
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        "I didn’t get the code",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff696969),
                        ),
                      ),
                    ),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.red[300],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: 288,
                          height: 60),
                      child: ElevatedButton(
                        onPressed: () {
                          if (pinCode.isEmpty ||
                              pinCode == null ||
                              pinCode == '') {
                            Fluttertoast.showToast(
                              msg: getTranslated(context, 'enter_otp'),
                              backgroundColor: Colors.white,
                              textColor: Colors.red[800],
                            );
                          } else {
                            universalLoader.show();
                            if (providerListener.googleEmail != "") {
                              _verifyOTPAfterGoogleAUth();
                            } else {
                              _verifyOTP();
                            }
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
