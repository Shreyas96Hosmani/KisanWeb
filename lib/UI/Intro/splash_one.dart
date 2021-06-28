import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/Intro/splash_page_view_builder.dart';
import 'package:kisanweb/UI/Intro/splash_two.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;
import 'package:kisanweb/localization/language_constants.dart';
import '../../Helpers/helper.dart';

class SplashOne extends StatefulWidget {
  @override
  _SplashOneState createState() => _SplashOneState();
}

class _SplashOneState extends State<SplashOne> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildCenterCard(context),
              buildInfoText(context),
            ],
          ),
        //buildSkipButton(context),
      ],
    );
  }

  Widget buildSkipButton(BuildContext context){
    return GestureDetector(
      onTap: (){
        push(context, SplashTwo());
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 50, right: 36),
          child: Text("SKIP",
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                  color: Color(0xff302b6f),
                  fontSize: getProportionateScreenHeight(20),
                  letterSpacing: 0
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCenterCard(BuildContext context){
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: getProportionateScreenWidth(380),
        width: getProportionateScreenWidth(380),
        child: Image.asset("assets/images/splashgifs/screen-1-300p.gif",fit: BoxFit.cover,),
      ),
    );
  }

  Widget buildInfoText(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: getProportionateScreenHeight(35),),
        Text(getTranslated(context, 'intro_pg1_text'),
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenHeight(25),
                fontWeight: FontWeight.bold,
                letterSpacing: 0
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(15),),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Text(getTranslated(context, 'intro_pg1_subtext'),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: getProportionateScreenHeight(18),color: Color(0xff9A9A9A)
            ),),
        ),
        SizedBox(height: getProportionateScreenHeight(25),),
        InkWell(
          onTap: (){
//            push(context, SplashTwo());
            buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
          },
          child: Container(
            height: getProportionateScreenWidth(60), width: getProportionateScreenWidth(60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(constants.COLOR_BACKGROUND),
            ),
            child: Center(
              child: Icon(Icons.arrow_forward_ios,color: Color(constants.COLOR_WHITE),size: getProportionateScreenWidth(25),),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle textStyle(){
    return GoogleFonts.nunitoSans(
      textStyle: TextStyle(
          letterSpacing: 0,
          fontSize: getProportionateScreenHeight(18)
      )
    );
  }

  Widget buildPositionWidget(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Color(0xff302b6f),
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
          ),
          SizedBox(width: 10.33,),
          buildEmptyPositionContainer(context),
          SizedBox(width: 10.33,),
          buildEmptyPositionContainer(context),
        ],
      ),
    );
  }

  Widget buildEmptyPositionContainer(BuildContext context){
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xff302b6f)),
          borderRadius: BorderRadius.all(Radius.circular(50))
      ),
    );
  }

}
