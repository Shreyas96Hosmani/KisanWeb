import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class CutomNotificationDetails extends StatelessWidget {
  const CutomNotificationDetails({
    Key key,
    this.prodName,
    this.prodDesc,
    this.onPressed,
    this.prodPhoto,
    this.webiste,
  }) : super(key: key);

  final String prodName, prodDesc, prodPhoto, webiste;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    BackButton(),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            getTranslated(context, 'noti'),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                height: getProportionateScreenHeight(250),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(prodPhoto), fit: BoxFit.fill),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prodName,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "About",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      parseHtmlString(prodDesc),
                      maxLines: 8,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    InkWell(
                      onTap: (){
                        UrlLauncher.launch(webiste??"https://kisan.net");
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: getProportionateScreenHeight(65),
                            width: double.infinity),
                        child: ElevatedButton(
                          onPressed: onPressed,
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.white,
                            primary: Color(0xFF008940),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            textStyle: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: Text("Know More"),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}


class BackButton extends StatelessWidget {
  const BackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: 55,
          height: 55,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20),
              side: BorderSide(width: 1, color: Color(0xFF008940)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF008940),
          ),
        ),
      ),
    );
  }
}
