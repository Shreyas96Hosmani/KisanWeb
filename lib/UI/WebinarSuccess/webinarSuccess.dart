import 'dart:convert';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Models/WebinarDetails.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class WebinarSuccess extends StatefulWidget {

  final WebinarDetails webinarDetailsTemp;

  WebinarSuccess(this.webinarDetailsTemp);

  @override
  _WebinarSuccessState createState() => _WebinarSuccessState();
}

class _WebinarSuccessState extends State<WebinarSuccess> {
  ConfettiController _controllerCenter;

  jumpScreen() {
    Future.delayed(const Duration(seconds: 3), () {

      final Event event = Event(
        title: utf8.decode(widget.webinarDetailsTemp.title.runes.toList()),
        description: widget.webinarDetailsTemp.about,
        location: widget.webinarDetailsTemp.share_link,
        startDate: DateTime.parse(widget.webinarDetailsTemp.scheduled_date),
        //DateTime.now().add(Duration(minutes: 6)),
        endDate: DateTime.parse(widget.webinarDetailsTemp.scheduled_date)
            .add(Duration(minutes: 60)),
        //DateTime.now().add(Duration(minutes: 10)),
        allDay: false,
        iosParams: IOSParams(
          reminder: Duration(minutes: 60),
        ),
      );
      Add2Calendar.addEvent2Cal(event);

    });
  }


  bool issetWhatsAppRemindeer = false;

  @override
  void initState() {
    _controllerCenter = ConfettiController(
      duration: Duration(milliseconds: 3000),
    );
    _controllerCenter.play();
    super.initState();
    jumpScreen();
  }

  @override
  Widget build(BuildContext context) {

    final providerListener = Provider.of<CustomViewModel>(context);

    return Scaffold(
      body: Stack(
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
                  "Congratulations "+(providerListener.userData.first_name??""),
                  style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF008940)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  getTranslated(context, 'registrtion_successful') ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF393939)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Container(
                  height: getProportionateScreenHeight(240),
                  margin: EdgeInsets.symmetric(
                      horizontal: 0, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    image: DecorationImage(
                        image: NetworkImage(providerListener
                            .webinarDetails
                            .image_path_medium ??
                            ""),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  getTranslated(context, 'registrtion_successful2') ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF393939)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                issetWhatsAppRemindeer == false
                    ? WebinarButtons(
                        text: "Remind me on WhatsApp.",
                        imgPath: "assets/images/whatsapp.png",
                        onpressed: () {
                          universalLoader.show();
                          Provider.of<CustomViewModel>(context, listen: false)
                              .OptInOut("OPT_IN")
                              .then((value) {
                            setState(() {
                              universalLoader.hide();
                              if (value == "error") {
                                toastCommon(context,
                                    getTranslated(context, 'no_data_tv'));
                              } else if (value == "success") {
                                setState(() {
                                  issetWhatsAppRemindeer = true;
                                });
                              } else {
                                toastCommon(context, value);
                              }
                            });
                          });
                        },
                      )
                    : RemiderOPTIN(onpressed: () {
                        print("aaaaaaaaa");
                        universalLoader.show();
                        Provider.of<CustomViewModel>(context, listen: false)
                            .OptInOut("OPT_OUT")
                            .then((value) {
                          setState(() {
                            universalLoader.hide();
                            if (value == "error") {
                              toastCommon(context,
                                  getTranslated(context, 'no_data_tv'));
                            } else if (value == "success") {
                              setState(() {
                                issetWhatsAppRemindeer = false;
                              });
                            } else {
                              toastCommon(context, value);
                            }
                          });
                        });
                      }),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                WebinarButtons(
                  text: "Invite friends to webinar.",
                  imgPath: "assets/images/profileIcon.png",
                  onpressed: () async {

                    final RenderBox box = context.findRenderObject();
                    if (Platform.isAndroid) {
                      var response = await http.get(
                          Uri.parse((providerListener.webinarDetails.image_path_medium ?? "")));
                      final documentDirectory =
                      (await getExternalStorageDirectory()).path;
                    File imgFile = new File('$documentDirectory/' +
                        providerListener.webinarDetails.organisation_name +
                    ".png");
                    imgFile.writeAsBytesSync(response.bodyBytes);

                    Share.shareFiles([
                    "${documentDirectory}/" +
                        providerListener.webinarDetails.organisation_name +
                    ".png"
                    ],
                    text:
                    'Hi,I found this intresting Webinar on KISAN app. Check it out ' +
                    (providerListener.webinarDetails.organisation_name ??
                    "") +
                    ' on kisan app\n'+(providerListener.webinarDetails.share_link??""));
                    } else {
                    Share.share(
                    'Hi,I found this intresting Webinar on KISAN app. Check it out ' +
                    (providerListener.webinarDetails.organisation_name ?? "") +
                    ' on kisan app\n'+(providerListener.webinarDetails.share_link??""),
                    subject: (providerListener.webinarDetails.image_path_medium ?? ""),
                    sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                    }
                  },
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.black,
                      ),
                      Text(
                        "My WEBINARS",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WebinarButtons extends StatelessWidget {
  const WebinarButtons({Key key, this.text, this.imgPath, this.onpressed})
      : super(key: key);

  final String text, imgPath;
  final Function onpressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          height: getProportionateScreenHeight(65), width: double.infinity),
      child: ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          side: BorderSide(
            width: 3,
            color: Color(0xFF008940),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgPath,
              height: getProportionateScreenHeight(32),
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF008940),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class RemiderOPTIN extends StatelessWidget {
  const RemiderOPTIN({Key key, this.onpressed}) : super(key: key);

  final Function onpressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          height: getProportionateScreenHeight(65), width: double.infinity),
      child: ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF008940),
          side: BorderSide(
            width: 3,
            color: Color(0xFF008940),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(
              "Remind me on WhatsApp",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
