import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';

class SubscriptionSuccess extends StatefulWidget {
  @override
  _SubscriptionSuccessState createState() => _SubscriptionSuccessState();
}

class _SubscriptionSuccessState extends State<SubscriptionSuccess> {
  ConfettiController _controllerCenter;

  @override
  void initState() {
    _controllerCenter = ConfettiController(
      duration: Duration(milliseconds: 3000),
    );
    _controllerCenter.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(621),
      height: getProportionateScreenWidth(810),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: true,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // define a custom shape/path.
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  getTranslated(context, 'congratulations'),
                  style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF393939)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  getTranslated(context, 'CongratulationsDescription'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF393939)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: getProportionateScreenHeight(458),
                        width: getProportionateScreenWidth(380),
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeight(30),
                            left: 20,
                            right: 20),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/subSuccess.png"))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 110,
                            ),
                            SvgPicture.asset(
                              "assets/icons/iosLeaf.svg",
                              color: Colors.white,
                              height: getProportionateScreenHeight(40),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            Text(
                              parseHtmlString(
                                  getTranslated(context, 'kisanMember')),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ProfilePhoto(),
                    ),
                  ],
                ),
                Spacer(),
                GrtThanksButton(
                  onPressed: () {},
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    Key key,
    this.profileImg,
  }) : super(key: key);
  final String profileImg;

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Container(
      width: getProportionateScreenHeight(140),
      height: getProportionateScreenHeight(140),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFB2F8D2),
          width: 7,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 4)
        ],
        image: providerListener.userprofileData.image_bigthumb_url != null
            ? DecorationImage(
                image: NetworkImage(
                    providerListener.userprofileData.image_bigthumb_url),
                fit: BoxFit.fill,
              )
            : null,
      ),
    );
  }
}

class GrtThanksButton extends StatelessWidget {
  const GrtThanksButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          height: getProportionateScreenHeight(65), width: double.infinity),
      child: ElevatedButton(
        onPressed: () {
          pop(context);
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF298658),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textStyle: GoogleFonts.poppins(
              fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        child: Text(getTranslated(context, 'thanks_button_text')),
      ),
    );
  }
}
