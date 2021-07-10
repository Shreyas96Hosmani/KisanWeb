import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
//import 'package:kisanweb/UI/Subscribe/SubscribeToMembership.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubTile extends StatefulWidget {
  const SubTile({
    Key key,
  }) : super(key: key);

  @override
  _SubTileState createState() => _SubTileState();
}

class _SubTileState extends State<SubTile> {
  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: getProportionateScreenHeight(80),
      decoration: BoxDecoration(
          color: Color(0xFFFC730F), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/Subscribe.png",
            width: getProportionateScreenWidth(30),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getTranslated(context, 'subscribe_to_kisan_365'),
                /*  "Subscribe to "+ providerListener.membershipplansList[0].name*/
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: getProportionateScreenHeight(16)),
              ),
              Container(
                width: getProportionateScreenWidth(223),
                child: Text(
                  getTranslated(context, 'unlock_all_features_for_1_year'),
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: getProportionateScreenHeight(12),
                      letterSpacing: 0.5),
                ),
              )
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    height: getProportionateScreenHeight(25)),
                child: ElevatedButton(
                    onPressed: () {
                      //push(context, SubscribeToMembership());
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Color(0xFFFC730F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(12))),
                    child: Text(
                      getTranslated(context, 'subscribe'),
                    )),
              ),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              Text(
                getTranslated(context, 'from_100'),
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: getProportionateScreenHeight(11)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

SharedPreferences prefs;

class SubTileGreen extends StatefulWidget {
  const SubTileGreen({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  _SubTileGreenState createState() => _SubTileGreenState();
}

class _SubTileGreenState extends State<SubTileGreen> {
  bool _isloaded = false;

  Future<void> initTask() async {
    prefs = await SharedPreferences.getInstance();

    if ((prefs.getBool('showwelcome') ?? true) == true) {
      setState(() {
        _isloaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initTask();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return _isloaded == true
        ? Container(
            //padding: EdgeInsets.symmetric(vertical: 9,horizontal: 12),
            width: MediaQuery.of(context).size.width,//getProportionateScreenWidth(378),
            height: getProportionateScreenHeight(70),
            decoration: BoxDecoration(
                color: Color(0xFF00A651),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated(context, 'welcome_kisan365'),
                        /*  "Subscribe to "+ providerListener.membershipplansList[0].name*/
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                      Text(
                        getTranslated(context, 'you_have_full_access'),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 0.5),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        prefs.setBool('showwelcome', false);
                        _isloaded = false;
                      });
                    },
                    child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 10),
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 25,
                        )),
                  )
                ],
              ),
            ),
          )
        : SizedBox(height: 1);
  }
}
