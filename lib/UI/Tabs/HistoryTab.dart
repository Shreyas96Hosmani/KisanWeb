import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

TextEditingController searchTextController = new TextEditingController();
FocusNode focusSearch = FocusNode();

class CallHistory extends StatefulWidget {
  @override
  _CallHistoryState createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  int pageCountW = 1;
  bool isLoadingW = false;

  bool _isloaded = false;

  Future<void> initTask() async {
    setState(() {
      pageCountW = 1;
      isLoadingW = false;
      _isloaded = false;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .GetCallHistory(searchTextController.text ?? "")
        .then((value) {
      setState(() {
        _isloaded = true;
      });
    });
    _isloaded = true;
  }

  @override
  void initState() {
    super.initState();
    initTask();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

    buildList(BuildContext context) {
      return _isloaded == true
          ? ResponsiveWidget.isSmallScreen(context)
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: providerListener.callHistoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                          vertical: getProportionateMobileScreenHeight(15),
                          horizontal: getProportionateMobileScreenWidth(10)),
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[200],
                              blurRadius: 1,
                              spreadRadius: 1)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(providerListener
                                .callHistoryUserObj[index]
                                .image_bigthumb_url ??
                                ""),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          (providerListener
                                              .callHistoryUserObj[index]
                                              .first_name +
                                              " " +
                                              providerListener
                                                  .callHistoryUserObj[index]
                                                  .last_name) +
                                              (providerListener.productCallObj[
                                              index] ==
                                                  null
                                                  ? ""
                                                  : (providerListener
                                                  .productCallObj[
                                              index]
                                                  .titleEnglish ==
                                                  null
                                                  ? ""
                                                  : ", " +
                                                  providerListener
                                                      .productCallObj[
                                                  index]
                                                      .titleEnglish)),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          providerListener
                                              .callHistoryList[index]
                                              .field1 ==
                                              "whatsapp"
                                              ? InkWell(
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              margin: EdgeInsets.only(
                                                  left: 5),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                //border: Border.all(color: Color(0xffB5B5B5)),
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        50)),
                                                color: Color(0xffE5F3EB),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  padding: EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2),
                                                  child: Image.asset(
                                                    "assets/images/whatsapp.png",
                                                    height: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              UrlLauncher.launch(
                                                  "https://wa.me/?phone=" +
                                                      providerListener
                                                          .callHistoryUserObj[
                                                      index]
                                                          .mobile
                                                          .replaceAll(
                                                          " ", "")
                                                          .replaceAll(
                                                          "+", ""));
                                            },
                                          )
                                              : SizedBox(
                                            width: 0,
                                          ),
                                          SizedBox(
                                            width:
                                            getProportionateScreenWidth(10),
                                          ),
                                          InkWell(
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                //border: Border.all(color: Color(0xffB5B5B5)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                                color: Color(0xffE5F3EB),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.call,
                                                  size: 18,
                                                  color: Color(0xff58C12A),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              UrlLauncher.launch("tel://" +
                                                  providerListener
                                                      .callHistoryUserObj[index]
                                                      .mobile);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      providerListener.callHistoryList[index]
                                          .field1 !=
                                          "whatsapp"
                                          ? Icon(
                                        providerListener
                                            .callHistoryList[
                                        index]
                                            .field1 ==
                                            "call"
                                            ? Icons.call
                                            : providerListener
                                            .callHistoryList[
                                        index]
                                            .field1 ==
                                            "request call"
                                            ? Icons.call_missed
                                            : Icons.call,
                                        color: providerListener
                                            .callHistoryList[
                                        index]
                                            .field1 !=
                                            "request call"
                                            ? Color(0xff58C12A)
                                            : Color(0xffF87676),
                                        size: 15,
                                      )
                                          : Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Image.asset(
                                          "assets/images/whatsapp.png",
                                          height: 13,
                                        ),
                                      ),
                                      Text(
                                        /*"Today, 11:00 AM",*/
                                        DateFormat.MMMMEEEEd().format(
                                          DateTime.parse(providerListener
                                              .callHistoryList[index]
                                              .activity_datetime),
                                        ) +
                                            ", " +
                                            DateFormat.jm().format(
                                              DateTime.parse(providerListener
                                                  .callHistoryList[index]
                                                  .activity_datetime),
                                            ),
                                        style: GoogleFonts.poppins(
                                          color: providerListener
                                              .callHistoryList[index]
                                              .field1 !=
                                              "request call"
                                              ? Color(0xff58C12A)
                                              : Color(0xffF87676),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        width: getProportionateMobileScreenWidth(120),
                                        child: Text(
                                          providerListener
                                              .callHistoryList[index]
                                              .field1 ==
                                              "call"
                                              ? (getTranslated(context,
                                              'you_requested_na_call_for') ??
                                              "")
                                              : "You connected on whatsapp",
                                          style: GoogleFonts.poppins(
                                            color: providerListener
                                                .callHistoryList[index]
                                                .field1 !=
                                                "request call"
                                                ? Color(0xff58C12A)
                                                : Color(0xffB5B5B5),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getProportionateMobileScreenWidth(10),
                                      ),
                                      providerListener.callHistoryList[index]
                                          .activity_code ==
                                          "connect_product"
                                          ? Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                  image: providerListener
                                                      .productCallObj[
                                                  index]
                                                      .bigthumbUrl
                                                      .toString() ==
                                                      "null" ||
                                                      providerListener
                                                          .productCallObj[
                                                      index]
                                                          .bigthumbUrl
                                                          .toString() ==
                                                          "" ||
                                                      providerListener
                                                          .productCallObj[
                                                      index]
                                                          .bigthumbUrl ==
                                                          null
                                                      ? AssetImage(
                                                      "assets/images/product_placeholder.png")
                                                      : NetworkImage(
                                                      providerListener
                                                          .productCallObj[
                                                      index]
                                                          .bigthumbUrl ??
                                                          ""),
                                                  fit: BoxFit.fill),
                                              //border: Border.all(color: Color(0xffB5B5B5)),
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: providerListener
                                                .productCallObj[
                                            index]
                                                .titleEnglish ==
                                                null ||
                                                providerListener
                                                    .productCallObj[
                                                index]
                                                    .titleEnglish
                                                    .toString() ==
                                                    "null"
                                                ? 0
                                                : getProportionateMobileScreenWidth(
                                                70),
                                            child: Text(
                                              parseHtmlString(
                                                  providerListener
                                                      .productCallObj[
                                                  index]
                                                      .titleEnglish ??
                                                      ""),
                                              overflow:
                                              TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                color: Color(0xff696969),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons
                                                .arrow_forward_ios_rounded,
                                            color: Colors.grey,
                                          )
                                        ],
                                      )
                                          : providerListener
                                          .callHistoryList[index]
                                          .activity_code ==
                                          "connect_profile"
                                          ? Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: providerListener
                                                        .productCallObj[
                                                    index]
                                                        .bigthumbUrl
                                                        .toString() ==
                                                        "null" ||
                                                        providerListener
                                                            .productCallObj[
                                                        index]
                                                            .bigthumbUrl
                                                            .toString() ==
                                                            "" ||
                                                        providerListener
                                                            .productCallObj[
                                                        index]
                                                            .bigthumbUrl ==
                                                            null
                                                        ? AssetImage(
                                                        "assets/images/product_placeholder.png")
                                                        : NetworkImage(providerListener
                                                        .productCallObj[
                                                    index]
                                                        .bigthumbUrl ??
                                                        ""),
                                                    fit: BoxFit.fill),
                                                //border: Border.all(color: Color(0xffB5B5B5)),
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius
                                                        .circular(
                                                        5)),
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: providerListener
                                                .productCallObj[
                                            index]
                                                .titleEnglish ==
                                                null ||
                                                providerListener
                                                    .productCallObj[
                                                index]
                                                    .titleEnglish
                                                    .toString() ==
                                                    "null"
                                                ? 0
                                                : getProportionateScreenWidth(
                                                70),
                                            child: Text(
                                              parseHtmlString(providerListener
                                                  .productCallObj[
                                              index]
                                                  .titleEnglish ??
                                                  ""),
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              maxLines: 2,
                                              style:
                                              GoogleFonts.poppins(
                                                color:
                                                Color(0xff696969),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons
                                                .arrow_forward_ios_rounded,
                                            color: Colors.grey,
                                          )
                                        ],
                                      )
                                          : SizedBox(
                                        width:
                                        getProportionateScreenWidth(
                                            1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
              : GridView.builder(
                  scrollDirection: Axis.vertical,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      childAspectRatio: 461 / 170,
                      mainAxisSpacing: 10),
                  shrinkWrap: true,
                  itemCount: providerListener.callHistoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: getProportionateScreenHeight(170),
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenWidth(15),
                          horizontal: getProportionateScreenWidth(10)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[200],
                              blurRadius: 1,
                              spreadRadius: 1)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(providerListener
                                .callHistoryUserObj[index]
                                .image_bigthumb_url ??
                                ""),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          (providerListener
                                              .callHistoryUserObj[index]
                                              .first_name +
                                              " " +
                                              providerListener
                                                  .callHistoryUserObj[index]
                                                  .last_name) +
                                              (providerListener.productCallObj[
                                              index] ==
                                                  null
                                                  ? ""
                                                  : (providerListener
                                                  .productCallObj[
                                              index]
                                                  .titleEnglish ==
                                                  null
                                                  ? ""
                                                  : ", " +
                                                  providerListener
                                                      .productCallObj[
                                                  index]
                                                      .titleEnglish)),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          providerListener
                                              .callHistoryList[index]
                                              .field1 ==
                                              "whatsapp"
                                              ? InkWell(
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              margin: EdgeInsets.only(
                                                  left: 5),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                //border: Border.all(color: Color(0xffB5B5B5)),
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        50)),
                                                color: Color(0xffE5F3EB),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  padding: EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2),
                                                  child: Image.asset(
                                                    "assets/images/whatsapp.png",
                                                    height: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              UrlLauncher.launch(
                                                  "https://wa.me/?phone=" +
                                                      providerListener
                                                          .callHistoryUserObj[
                                                      index]
                                                          .mobile
                                                          .replaceAll(
                                                          " ", "")
                                                          .replaceAll(
                                                          "+", ""));
                                            },
                                          )
                                              : SizedBox(
                                            width: 0,
                                          ),
                                          SizedBox(
                                            width:
                                            getProportionateScreenWidth(10),
                                          ),
                                          InkWell(
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                //border: Border.all(color: Color(0xffB5B5B5)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                                color: Color(0xffE5F3EB),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.call,
                                                  size: 18,
                                                  color: Color(0xff58C12A),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              UrlLauncher.launch("tel://" +
                                                  providerListener
                                                      .callHistoryUserObj[index]
                                                      .mobile);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      providerListener.callHistoryList[index]
                                          .field1 !=
                                          "whatsapp"
                                          ? Icon(
                                        providerListener
                                            .callHistoryList[
                                        index]
                                            .field1 ==
                                            "call"
                                            ? Icons.call
                                            : providerListener
                                            .callHistoryList[
                                        index]
                                            .field1 ==
                                            "request call"
                                            ? Icons.call_missed
                                            : Icons.call,
                                        color: providerListener
                                            .callHistoryList[
                                        index]
                                            .field1 !=
                                            "request call"
                                            ? Color(0xff58C12A)
                                            : Color(0xffF87676),
                                        size: 15,
                                      )
                                          : Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Image.asset(
                                          "assets/images/whatsapp.png",
                                          height: 13,
                                        ),
                                      ),
                                      Text(
                                        /*"Today, 11:00 AM",*/
                                        DateFormat.MMMMEEEEd().format(
                                          DateTime.parse(providerListener
                                              .callHistoryList[index]
                                              .activity_datetime),
                                        ) +
                                            ", " +
                                            DateFormat.jm().format(
                                              DateTime.parse(providerListener
                                                  .callHistoryList[index]
                                                  .activity_datetime),
                                            ),
                                        style: GoogleFonts.poppins(
                                          color: providerListener
                                              .callHistoryList[index]
                                              .field1 !=
                                              "request call"
                                              ? Color(0xff58C12A)
                                              : Color(0xffF87676),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        width: getProportionateScreenWidth(120),
                                        child: Text(
                                          providerListener
                                              .callHistoryList[index]
                                              .field1 ==
                                              "call"
                                              ? (getTranslated(context,
                                              'you_requested_na_call_for') ??
                                              "")
                                              : "You connected on whatsapp",
                                          style: GoogleFonts.poppins(
                                            color: providerListener
                                                .callHistoryList[index]
                                                .field1 !=
                                                "request call"
                                                ? Color(0xff58C12A)
                                                : Color(0xffB5B5B5),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(10),
                                      ),
                                      providerListener.callHistoryList[index]
                                          .activity_code ==
                                          "connect_product"
                                          ? Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                  image: providerListener
                                                      .productCallObj[
                                                  index]
                                                      .bigthumbUrl
                                                      .toString() ==
                                                      "null" ||
                                                      providerListener
                                                          .productCallObj[
                                                      index]
                                                          .bigthumbUrl
                                                          .toString() ==
                                                          "" ||
                                                      providerListener
                                                          .productCallObj[
                                                      index]
                                                          .bigthumbUrl ==
                                                          null
                                                      ? AssetImage(
                                                      "assets/images/product_placeholder.png")
                                                      : NetworkImage(
                                                      providerListener
                                                          .productCallObj[
                                                      index]
                                                          .bigthumbUrl ??
                                                          ""),
                                                  fit: BoxFit.fill),
                                              //border: Border.all(color: Color(0xffB5B5B5)),
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: providerListener
                                                .productCallObj[
                                            index]
                                                .titleEnglish ==
                                                null ||
                                                providerListener
                                                    .productCallObj[
                                                index]
                                                    .titleEnglish
                                                    .toString() ==
                                                    "null"
                                                ? 0
                                                : getProportionateScreenWidth(
                                                70),
                                            child: Text(
                                              parseHtmlString(
                                                  providerListener
                                                      .productCallObj[
                                                  index]
                                                      .titleEnglish ??
                                                      ""),
                                              overflow:
                                              TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                color: Color(0xff696969),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons
                                                .arrow_forward_ios_rounded,
                                            color: Colors.grey,
                                          )
                                        ],
                                      )
                                          : providerListener
                                          .callHistoryList[index]
                                          .activity_code ==
                                          "connect_profile"
                                          ? Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: providerListener
                                                        .productCallObj[
                                                    index]
                                                        .bigthumbUrl
                                                        .toString() ==
                                                        "null" ||
                                                        providerListener
                                                            .productCallObj[
                                                        index]
                                                            .bigthumbUrl
                                                            .toString() ==
                                                            "" ||
                                                        providerListener
                                                            .productCallObj[
                                                        index]
                                                            .bigthumbUrl ==
                                                            null
                                                        ? AssetImage(
                                                        "assets/images/product_placeholder.png")
                                                        : NetworkImage(providerListener
                                                        .productCallObj[
                                                    index]
                                                        .bigthumbUrl ??
                                                        ""),
                                                    fit: BoxFit.fill),
                                                //border: Border.all(color: Color(0xffB5B5B5)),
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius
                                                        .circular(
                                                        5)),
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: providerListener
                                                .productCallObj[
                                            index]
                                                .titleEnglish ==
                                                null ||
                                                providerListener
                                                    .productCallObj[
                                                index]
                                                    .titleEnglish
                                                    .toString() ==
                                                    "null"
                                                ? 0
                                                : getProportionateScreenWidth(
                                                70),
                                            child: Text(
                                              parseHtmlString(providerListener
                                                  .productCallObj[
                                              index]
                                                  .titleEnglish ??
                                                  ""),
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              maxLines: 2,
                                              style:
                                              GoogleFonts.poppins(
                                                color:
                                                Color(0xff696969),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons
                                                .arrow_forward_ios_rounded,
                                            color: Colors.grey,
                                          )
                                        ],
                                      )
                                          : SizedBox(
                                        width:
                                        getProportionateScreenWidth(
                                            1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
          : Container(
              height: SizeConfig.screenHeight / 2,
              color: Colors.white,
              child: Center(
                child: new CircularProgressIndicator(
                  strokeWidth: 1,
                  backgroundColor: Color(COLOR_PRIMARY),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
                ),
              ),
            );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: ResponsiveWidget.isSmallScreen(context)
              ? EdgeInsets.symmetric(horizontal: 20)
              : EdgeInsets.symmetric(horizontal: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //CustomBackButton(text: "",),
                  Container(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textAlignVertical: TextAlignVertical.bottom,
                  focusNode: focusSearch,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Search a person, product, company",
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    fillColor: Colors.grey.shade100,
                    suffixIconConstraints: BoxConstraints.tightFor(height: 40),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          searchTextController.clear();
                        });
                        initTask();
                      },
                      child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 20),
                          child: Icon(
                            Icons.clear,
                            size: 30,
                          )),
                    ),
                  ),
                  /*onChanged: (value) {

                                },*/
                  onEditingComplete: () {
                    initTask();
                    focusSearch.unfocus();
                  },
                  controller: searchTextController,
                ),
              ),
                  SizedBox(
                    height: 20,
                  ),

                ],
              ),*/
              Container(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textAlignVertical: TextAlignVertical.bottom,
                  focusNode: focusSearch,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Search a person, product, company",
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    fillColor: Colors.grey.shade100,
                    suffixIconConstraints: BoxConstraints.tightFor(height: 40),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          searchTextController.clear();
                        });
                        initTask();
                      },
                      child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 20),
                          child: Icon(
                            Icons.clear,
                            size: 30,
                          )),
                    ),
                  ),
                  /*onChanged: (value) {

                                },*/
                  onEditingComplete: () {
                    initTask();
                    focusSearch.unfocus();
                  },
                  controller: searchTextController,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildList(context),
              ResponsiveWidget.isSmallScreen(context)
                  ? SizedBox(
                      height: 50,
                    )
                  : SizedBox(height: 0,),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key key,
    this.onPressed,
    this.textEditingController,
  }) : super(key: key);

  final Function onPressed;
  final TextEditingController textEditingController;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode focusSearch = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: TextField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        focusNode: focusSearch,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
        decoration: InputDecoration(
          hintText: "Your activity",
          hintStyle: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 18,
              letterSpacing: 1,
              fontWeight: FontWeight.w600),
          //filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          //fillColor: Colors.grey.shade100,
          suffixIconConstraints: BoxConstraints.tightFor(height: 50),
          suffixIcon: GestureDetector(
            onTap: widget.onPressed,
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: 10),
              child: SvgPicture.asset(
                "assets/icons/searchIcon.svg",
                color: Colors.grey,
              ),
            ),
          ),
        ),
        onEditingComplete: () {},
        controller: widget.textEditingController,
      ),
    );
  }
}
