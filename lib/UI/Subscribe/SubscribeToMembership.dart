import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/SubscriptionSuccess/SubscriptionSuccess.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Helpers/helper.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;

class SubscribeToMembership extends StatefulWidget {
  @override
  _SubscribeToMembershipState createState() => _SubscribeToMembershipState();
}

class _SubscribeToMembershipState extends State<SubscribeToMembership> {
  Razorpay _razorpay;
  String razorpay_subscription_id;
  String order_id;
  int user_id;
  String USE_RAZORPAY_SUBSCRIPTIONS = "0";

  void openCheckout(String mobile, String email, String amount) async {
    print("********");
    print(amount);
    var options;

    if (USE_RAZORPAY_SUBSCRIPTIONS == "1") {
      options = {
        //TODO: prefill razorpay data
        'key': 'rzp_test_FbmkEFJfTj8RJu', //'rzp_test_P0zF0ER0RTTAan',
        'amount': amount.toString() + "00",
        'name': 'KISAN',
        'theme.color': '#008940',
        'description': 'Kisan membership subscription',
        'currency': 'INR',
        'recurring': true,
        'subscription_id': razorpay_subscription_id,
        'prefill': {'contact': mobile, 'email': email},
        'external': {
          'wallets': ['paytm']
        }
      };
    }
    else {
      options = {
        //TODO: prefill razorpay data
        'key': 'rzp_test_FbmkEFJfTj8RJu', //'rzp_test_P0zF0ER0RTTAan',
        'amount': amount.toString() + "00",
        'name': 'KISAN',
        'theme.color': '#008940',
        'description': 'Kisan Green Pass',
        'currency': 'INR',
        'order_id': order_id,
        'prefill': {'contact': mobile, 'email': email},
        'external': {
          'wallets': ['paytm']
        }
      };
    }

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (USE_RAZORPAY_SUBSCRIPTIONS == "1") {
      universalLoader.show();
      Provider.of<CustomViewModel>(context, listen: false)
          .VerifySubscription(
              response.paymentId, razorpay_subscription_id, response.signature)
          .then((value) {
        setState(() {
          universalLoader.hide();
          if (value == "error") {
            toastCommon(context, getTranslated(context, 'no_data_tv'));
          } else if (value == "success") {
            //pushReplacement(context, SubscriptionSuccess());
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(35)),
                      //this right here
                      child: SubscriptionSuccess()
                  );
                });
          } else {
            toastCommon(context, value);
          }
        });
      });
    } else {
      universalLoader.show();
      Provider.of<CustomViewModel>(context, listen: false)
          .VerifyGreepass(
              response.paymentId, order_id, response.signature, user_id)
          .then((value) {
        setState(() {
          universalLoader.hide();
          if (value == "error") {
            toastCommon(context, getTranslated(context, 'no_data_tv'));
          } else if (value == "success") {
            pushReplacement(context, SubscriptionSuccess());
          } else {
            toastCommon(context, value);
          }
        });
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Map valueMap = json.decode(response.message);

    toastCommon(context, valueMap['error']['description'].toString());

    if (USE_RAZORPAY_SUBSCRIPTIONS == "1") {
      universalLoader.show();
      Provider.of<CustomViewModel>(context, listen: false)
          .FailureSubscription(razorpay_subscription_id, valueMap['error'])
          .then((value) {
        setState(() {
          universalLoader.hide();
        });
      });
    } else {
      universalLoader.show();
      Provider.of<CustomViewModel>(context, listen: false)
          .FailureGreepass(order_id, user_id, valueMap['error']['code'],
              valueMap['error']['description'])
          .then((value) {
        setState(() {
          universalLoader.hide();
        });
      });
    }
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
  }

  @override
  Widget build(BuildContext context) {
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

    final providerListener = Provider.of<CustomViewModel>(context);

    //SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.all(20),
      width: 414,height: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: (20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //SvgPicture.asset("assets/icons/LockGreenBlack.svg",width: 25,),
              GestureDetector(
                onTap: () {
                  pop(context);
                },
                child: Icon(Icons.close_rounded,
                    color: Colors.grey[600], size: 40),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            parseHtmlString(getTranslated(context,
                "select_a_membership_plan_to_unlock_the_information").replaceAll("\\n", "\n")),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            getTranslated(context, 'annual_subscription'),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 18),
          ),
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Color(0xFF298658),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFB2F8D2), width: 4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          getTranslated(context, 'app_name').toString() +
                              " " +
                              getTranslated(context, 'greenpass'),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            height: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: (25),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: (16),
                    ),
                    Text(
                      getTranslated(context, 'greenpassDescription'),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: (16),
                    ),
                    Text(

                      getTranslated(context, 'entrytext') +
                          "\n" +
                          getTranslated(context, 'explore') +
                          "\n" +
                          getTranslated(context, 'connect') +
                          "\n" +
                          getTranslated(context, 'get_offers_amp_discounts') +
                          "\n" +
                          getTranslated(context, 'watch_product_demonstrations') +
                          "\n" +
                          getTranslated(context, 'know_about_new_product_launches') +
                          "\n"+
                          getTranslated(context, 'find_nearest_authorised_dealers') +
                          "\n"+
                          getTranslated(context, 'attend_webinars') +
                          "\n"+
                          "\nAnd much more…",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "assets/images/35.png",
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: (55),
                  width: (146),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Color(0xffB2F8D2)),
                  child: Center(
                    child: Text(
                      constants.currencySymbl +
                          (providerListener.membershipplansList[0].amount ??
                              0)
                              .toString() +
                          "/-",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: (30),
                          color: Color(0xff298658)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            getTranslated(context, 'auto_renwe_a_day_before'),
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff298658)),
          ),
          SubscribeButton(
            onPressed: () {
              int price;
              setState(() {
                double amount =
                (providerListener.membershipplansList[0].amount ?? 0.0);
                price = amount.toInt();

                USE_RAZORPAY_SUBSCRIPTIONS =
                    providerListener.USE_RAZORPAY_SUBSCRIPTIONS ?? "0";
              });

              if (USE_RAZORPAY_SUBSCRIPTIONS == "1") {
                universalLoader.show();
                Provider.of<CustomViewModel>(context, listen: false)
                    .InitiateSubscription(providerListener
                    .membershipplansList[0].razorpay_plan_id ??
                    "")
                    .then((value) {
                      setState(() {
                    universalLoader.hide();
                    if (value == "error") {
                      toastCommon(
                          context, getTranslated(context, 'no_data_tv'));
                    }else if (value == "success") {
                      setState(() {
                        razorpay_subscription_id = (providerListener
                            .subscriptionInitialInfo
                            .razorpay_subscription_id ??
                            "");
                      });
                      print("*******************1");
                      print(price);
                      openCheckout(
                        (providerListener.userprofileData.mobile1 ?? ""),
                        (providerListener.userprofileData.email ?? ""),
                        price.toString(),
                      );
                    } else {
                      toastCommon(context, value);
                    }
                  });
                });
              }
              else {
                universalLoader.show();
                Provider.of<CustomViewModel>(context, listen: false)
                    .InitiateGreenPass(
                    providerListener.userprofileData.mobile1 ?? "",
                    providerListener.userData.first_name ?? "",
                    providerListener.userData.last_name ?? "")
                    .then((value) {
                  setState(() {
                    universalLoader.hide();
                    if (value == "error") {
                      toastCommon(
                          context, getTranslated(context, 'no_data_tv'));
                    } else if (value == "success") {
                      setState(() {
                        order_id = (providerListener.order_id ?? "");
                        user_id = providerListener.userprofileData.user;
                      });
                      print("*******************2");
                      print(price);
                      openCheckout(
                        (providerListener.userprofileData.mobile1 ?? ""),
                        (providerListener.userprofileData.email ?? ""),
                        price.toString(),
                      );
                    } else {
                      toastCommon(context, value);
                    }
                  });
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: (65)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: Color(0xFF298658),
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTranslated(context, 'subscribe'),
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
