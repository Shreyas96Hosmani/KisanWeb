import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Models/DetailedBrouchersParser.dart';
import 'package:kisanweb/Models/RepresentativeListParser.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/Categories/productsFound.dart';
import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
import 'package:kisanweb/UI/CompanyProfile/ViewPhotoScreen.dart';
import 'package:kisanweb/UI/DetailedScreens/VideoScreen.dart';
import 'package:kisanweb/UI/DetailedScreens/pdfViewer.dart';
import 'package:kisanweb/UI/Subscribe/SubscribeToMembership.dart';
import 'package:kisanweb/UI/Tabs/HomeTab.dart';
import 'package:kisanweb/UI/Widgets/readmore.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

//import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:open_file/open_file.dart';
import '../../Helpers/constants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

int indexSaveContact = -1;
SharedPreferences prefs;
String languageCode = 'en';

class DetailedProducts extends StatefulWidget {
  final id, company_id;

  DetailedProducts(this.id, this.company_id);

  @override
  _DetailedProductsState createState() => _DetailedProductsState();
}

class _DetailedProductsState extends State<DetailedProducts> {
  final Dio _dio = Dio();

  String download_link;

  String _progress = "-";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  PanelController _pc1 = new PanelController();
  bool _visible1 = true;

  PanelController _pc2 = new PanelController();
  bool _visible2 = false;

  PanelController _pc3 = new PanelController();
  bool _visible3 = false;

  PanelController _pc4 = new PanelController();
  bool _visible4 = false;

  bool _innerVisible = false;
  bool _isChecked = false;

  bool _isloaded = false;

  Future<void> initTask() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      languageCode = prefs.getString(LAGUAGE_CODE) ?? "en";
    });

    if ((prefs.getInt('paywall') ?? 0) == 1 &&
        (prefs.getString('membership_status') ?? "") != "active") {
      /* pushReplacement(context, SubscribeToMembership());*/
    } else {
      setState(() {
        _isChecked = prefs.getBool('_isChecked') ?? false;
      });

      //TODO: remove hardcoded id, given because only it has assets
      Provider.of<CustomViewModel>(context, listen: false)
          .GetDetailedOfProduct(widget.id /*139*/)
          .then((value) {
        setState(() {
          if (value == "error") {
          } else if (value == "success") {
            _isloaded = true;
          } else {}
        });
      });
      Provider.of<CustomViewModel>(context, listen: false)
          .GetProductsFromSameCompany(widget.company_id, widget.id
              /*27604,
            139*/
              );
      Getrepresentative();
    }
  }

  Future<void> Getrepresentative() {
    //TODO: representative id hardcoded
    Provider.of<CustomViewModel>(context, listen: false)
        .Getrepresentative(widget.company_id /*27634*/)
        .then((value) => VisitProduct());
  }

  Future<void> VisitProduct() {
    //TODO: representative id hardcoded
    Provider.of<CustomViewModel>(context, listen: false)
        .visitProduct(widget.company_id, widget.id);
  }

  Future<void> connectProductCall(
      int user, int user_id, int id, String mobile) {
    universalLoader.style(
        message: 'Calling...',
        backgroundColor: Colors.white,
        progressWidget: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(
            Icons.call,
            color: Colors.green,
            size: 17,
          ),
          radius: 15,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOutSine,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    universalLoader.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .connectProductCall(user, user_id, id)
        .then((value) {
      setState(() {
        universalLoader.hide();
        if (value == "error") {
          toastCommon(context, getTranslated(context, 'no_data_tv'));
        } else if (value == "success") {
          UrlLauncher.launch("tel://" + mobile);
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  Future<void> connectProductWhatsApp(
      int user, int user_id, int id, String mobile, int add_contact) {
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

    universalLoader.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .connectProductWhatsApp(user, user_id, id, add_contact)
        .then((value) {
      setState(() {
        universalLoader.hide();

        if (value == "error") {
          toastCommon(context, getTranslated(context, 'no_data_tv'));
        } else if (value == "success") {
          if (add_contact == 1) {
            _pc1.close();
            _visible1 = false;
            setState(() {
              _pc3.open();
              _visible3 = true;
            });
          } else {
            UrlLauncher.launch("https://wa.me/?phone=" +
                mobile.replaceAll(" ", "").replaceAll("+", ""));
          }
          Getrepresentative();
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  Future<void> connectProductWhatsAppWithSaveButton(
      int user, int user_id, int id, String mobile, int add_contact) {
    universalLoader.style(
        message: 'Saving...',
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

    universalLoader.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .connectProductWhatsApp(user, user_id, id, add_contact)
        .then((value) {
      setState(() {
        universalLoader.hide();
        if (value == "error") {
          toastCommon(context, getTranslated(context, 'no_data_tv'));
        } else if (value == "success") {
          if (add_contact == 1) {
            _pc3.close();
            _visible3 = false;
            setState(() {
              _pc4.open();
              _visible4 = true;
            });
          } else {
            UrlLauncher.launch("https://wa.me/?phone=" +
                mobile.replaceAll(" ", "").replaceAll("+", ""));
          }
          Getrepresentative();
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    /*flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);*/
    initTask();
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      toastCommon(context, getTranslated(context, 'permission_not_granted'));
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      //  toastCommon(context, "Contact data not available on device");
      toastCommon(context, getTranslated(context, 'permission_not_granted'));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (_progress != "-") {
      if (obj['isSuccess']) {
        OpenFile.open(obj['filePath']);
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('${obj['error']}'),
          ),
        );
      }
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? ' File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future<Directory> _getDownloadDirectory() async {
    /*if (Platform.isAndroid) {
      return await getTemporaryDirectory();
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();*/
    return await getExternalStorageDirectory();
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      print("total $received $total");
      if (received == total && total > 0) {
        /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Download Completed",
          style: TextStyle(color: Colors.white),
        )));*/
        toastCommon(context, "Download " + getTranslated(context, 'done'));
      }

      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  Future<void> _startDownload(String savePath) async {
    universalLoader.show();
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(download_link, savePath,
          onReceiveProgress: _onReceiveProgress);
      await universalLoader.hide();
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      await universalLoader.hide();
      result['error'] = ex.toString();
    } finally {
      await universalLoader.hide();
      await _showNotification(result);
    }
  }

  Future<void> _download() async {
    print("_download");
    final dir = await _getDownloadDirectory();

    var status = await Permission.storage.status;
    if (await Permission.speech.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    } else {
      if (!status.isGranted) {
        await Permission.storage.request();
      } else {
        File file2 = new File(download_link);
        String fileName = file2.path.split('/').last;

        final savePath = path.join(dir.path, fileName);
        await _startDownload(savePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    universalLoader = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    final providerListener = Provider.of<CustomViewModel>(context);
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return _isloaded == true
        ? Scaffold(
            extendBodyBehindAppBar: true,
            body: ResponsiveWidget.isSmallScreen(context) ? Stack(
              children: [
                SingleChildScrollView(
                    child: providerListener.productsDetails != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        providerListener.productsDetailsAssetsUrl.length >
                            0
                            ? Stack(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                  onPageChanged: (index, onTap) {
                                    setState(() {
                                      currentS = index;
                                    });
                                    print(currentS.toString());
                                  },
                                  autoPlay: true,
                                  height: SizeConfig.screenWidth,
                                  viewportFraction: 1,
                                  autoPlayAnimationDuration:
                                  Duration(milliseconds: 2000)),
                              items: providerListener
                                  .productsDetailsAssetsUrl
                                  .map((url) {
                                int index = providerListener
                                    .productsDetailsAssetsUrl
                                    .indexOf(url);
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {
                                        providerListener
                                            .productsDetailsAssets[
                                        index]
                                            .media_type ==
                                            "youtubevideo"
                                            ? push(
                                            context,
                                            SamplePlayer(
                                                null,
                                                providerListener
                                                    .productsDetailsAssets[
                                                index]
                                                    .media_url))
                                            : push(
                                            context,
                                            ViewPhotos(
                                              url: providerListener
                                                  .productsDetailsAssets[
                                              index]
                                                  .media_url ??
                                                  "",
                                            ));
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: SizeConfig
                                                .screenWidth -
                                                10,
                                            margin: EdgeInsets
                                                .symmetric(
                                                horizontal: 0,
                                                vertical: 0),
                                            decoration:
                                            BoxDecoration(
                                              color:
                                              Colors.green[700],
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      providerListener
                                                          .productsDetailsAssets[
                                                      index]
                                                          .bigthumb_url ??
                                                          ""),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          providerListener
                                              .productsDetailsAssets[
                                          index]
                                              .media_type ==
                                              "youtubevideo"
                                              ? Center(
                                            child: Opacity(
                                              opacity: 0.7,
                                              child: Icon(
                                                Icons
                                                    .play_circle_fill,
                                                color: Colors
                                                    .white,
                                                size: 50,
                                              ),
                                            ),
                                          )
                                              : SizedBox(
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Positioned(
                              top: SizeConfig.screenWidth / 1.1,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: providerListener
                                    .productsDetailsAssetsUrl
                                    .map((url) {
                                  int index = providerListener
                                      .productsDetailsAssetsUrl
                                      .indexOf(url);
                                  return Container(
                                    width: 30.0,
                                    height: 5.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: currentS == index
                                          ? Colors.white
                                          : Colors.black
                                          .withOpacity(0.3),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 35,
                              child: ConstrainedBox(
                                constraints:
                                BoxConstraints.tightFor(
                                  width: 55,
                                  height: 55,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white
                                          .withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              15))),
                                  onPressed: () async {
                                    final RenderBox box =
                                    context.findRenderObject();
                                    if (Platform.isAndroid) {
                                      var response = await http.get(
                                          Uri.parse((providerListener
                                              .productsDetails
                                              .bigthumb_url ??
                                              "")));
                                      final documentDirectory =
                                          (await getExternalStorageDirectory())
                                              .path;
                                      File imgFile = new File(
                                          '$documentDirectory/' +
                                              providerListener
                                                  .productsDetails
                                                  .title_english +
                                              ".png");
                                      imgFile.writeAsBytesSync(
                                          response.bodyBytes);

                                      Share.shareFiles([
                                        "${documentDirectory}/" +
                                            providerListener
                                                .productsDetails
                                                .title_english +
                                            ".png"
                                      ],
                                          text: "Hi, Check out this product.\n" +
                                              (providerListener
                                                  .productsDetails
                                                  .title_english ??
                                                  "") +
                                              " on kisan App\nhttps://kisan.app/");
                                    } else {
                                      Share.share(
                                          "Hi, Check out this product.\n" +
                                              (providerListener
                                                  .productsDetails
                                                  .title_english ??
                                                  "") +
                                              " on kisan App\nhttps://kisan.app/",
                                          subject: (providerListener
                                              .productsDetails
                                              .bigthumb_url ??
                                              ""),
                                          sharePositionOrigin:
                                          box.localToGlobal(
                                              Offset.zero) &
                                          box.size);
                                    }
                                  },
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: 35,
                              child: ConstrainedBox(
                                constraints:
                                BoxConstraints.tightFor(
                                  width: 55,
                                  height: 55,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white
                                          .withOpacity(0.5),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              15))),
                                  onPressed: () {
                                    pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                            : SizedBox(
                          height: 1,
                        ),
                        SizedBox(
                          height: 27,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            languageCode == "en"
                                ? utf8.decode(providerListener
                                .productsDetails.title_english
                                .toString()
                                .runes
                                .toList() ??
                                "")
                                : languageCode == "hi"
                                ? utf8.decode(providerListener
                                .productsDetails.title_hindi
                                .toString()
                                .runes
                                .toList() ??
                                "")
                                : utf8.decode(providerListener
                                .productsDetails.title_marathi
                                .toString()
                                .runes
                                .toList() ??
                                ""),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Color(0xFF044BB0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: RichText(
                              text: TextSpan(
                                  text: currencySymbl,
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF393939),
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " " +
                                          (providerListener.productsDetails
                                              .price ??
                                              0)
                                              .toString(),
                                      style: GoogleFonts.poppins(
                                          color: Color(0xFF393939),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                        text: " onwards",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 20))
                                  ])),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 30),
                          child: ReadMoreText(
                            parseHtmlString(languageCode == "en"
                                ? utf8.decode(providerListener
                                .productsDetails.desc_english
                                .toString()
                                .runes
                                .toList() ??
                                "")
                                : languageCode == "hi"
                                ? utf8.decode(providerListener
                                .productsDetails.desc_hindi
                                .toString()
                                .runes
                                .toList() ??
                                "")
                                : utf8.decode(providerListener
                                .productsDetails.desc_marathi
                                .toString()
                                .runes
                                .toList() ??
                                "")),
                            trimLines: 6,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: 14),
                            colorClickableText: Colors.black,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Read more',
                            trimExpandedText: 'Read less',
                            lessStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                            moreStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        /*SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  'Special Offer',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF044BB0),
                                    fontSize:
                                        getProportionateScreenHeight(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                height: 220,
                                child: ListView.builder(
                                    itemCount: 3,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      //TODO: get from server
                                      return Offers(context);
                                    }),
                              ),*/
                        //PDF Button ------------
                        SizedBox(
                          height: 30,
                        ),
                        providerListener.productsDetailsBrouchers.length >
                            0
                            ? Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30),
                              child: Text(
                                getTranslated(context, 'Broucher'),
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF044BB0),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Container(
                              height: ((providerListener
                                  .productsDetailsBrouchers
                                  .length)
                                  .toDouble()) *
                                  100,
                              width: SizeConfig.screenWidth,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                removeBottom: true,
                                child: ListView.builder(
                                    itemCount: providerListener
                                        .productsDetailsBrouchers
                                        .length,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                    NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return PDFButton(
                                        onWholePressed: () {
                                          push(
                                              context,
                                              pdfviewer(
                                                  providerListener
                                                      .productsDetailsBrouchers[
                                                  index]
                                                      .title,
                                                  providerListener
                                                      .productsDetailsBrouchers[
                                                  index]
                                                      .media_url));
                                        },
                                        onDownloadPressed: () {
                                          print("Download Pdf");
                                          setState(() {
                                            download_link =
                                                providerListener
                                                    .productsDetailsBrouchers[
                                                index]
                                                    .media_url;
                                          });

                                          universalLoader.style(
                                              message:
                                              'Downloading file...',
                                              backgroundColor:
                                              Colors.white,
                                              progressWidget:
                                              CircularProgressIndicator(
                                                strokeWidth: 10,
                                                backgroundColor: Color(
                                                    COLOR_PRIMARY),
                                                valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(
                                                    Color(
                                                        COLOR_BACKGROUND)),
                                              ),
                                              elevation: 10.0,
                                              insetAnimCurve: Curves
                                                  .easeInOutSine,
                                              progress: 0.0,
                                              maxProgress: 100.0,
                                              progressTextStyle:
                                              TextStyle(
                                                  color: Colors
                                                      .black,
                                                  fontSize:
                                                  13.0,
                                                  fontWeight:
                                                  FontWeight
                                                      .w400),
                                              messageTextStyle: TextStyle(
                                                  color:
                                                  Colors.black,
                                                  fontSize: 19.0,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600));

                                          _download();
                                        },
                                        onPdfPressed: () {
                                          print("View Pdf");
                                          push(
                                              context,
                                              pdfviewer(
                                                  providerListener
                                                      .productsDetailsBrouchers[
                                                  index]
                                                      .title,
                                                  providerListener
                                                      .productsDetailsBrouchers[
                                                  index]
                                                      .media_url));
                                        },
                                        broucherOBJ: providerListener
                                            .productsDetailsBrouchers[
                                        index],
                                      );
                                    }),
                              ),
                            ),
                          ],
                        )
                            : SizedBox(
                          height: 1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: CompanyLink(
                            title: providerListener
                                .productsDetails.organisation_name ??
                                "",
                            imagePath: providerListener
                                .productsDetails.image_bigthumb_url ??
                                "",
                            onPressed: () {
                              push(
                                  context,
                                  CompanyDetails(providerListener
                                      .productsDetails.user_id));
                              print(
                                  "Company link Pressed : To Company Profile");
                            },
                          ),
                        ),
                        //-----More from the company
                        SizedBox(
                          height: 31,
                        ),
                        providerListener
                            .productsListFromSameCompany.length >
                            0
                            ? Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 300,
                                child: Text(
                                  /* getTranslated(
                                                      context, 'Simmilar') +*/
                                  "More from " +
                                      (providerListener
                                          .productsDetails
                                          .organisation_name ??
                                          ""),
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF044BB0),
                                    fontSize:
                                    getProportionateScreenHeight(
                                        20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              //Change it with different SVG
                              GestureDetector(
                                  onTap: () {
                                    //no category ids, only company id
                                    List<int> ids = [];
//                                    push(
//                                        context,
//                                        productsFound(
//                                            0,
//                                            providerListener.productsList[0].organisation_name,
//                                            ids,
//                                            widget.company_id));
                                  },
                                  child: Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                        BorderRadius.circular(
                                            50)),
                                    child: Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        )
                            : SizedBox(
                          height: 1,
                        ),
                        providerListener
                            .productsListFromSameCompany.length >
                            0
                            ? Container(
                          height: 260,
                          child: ListView.builder(
                              itemCount: providerListener
                                  .productsListFromSameCompany
                                  .length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return MoreProds(
                                  name: providerListener
                                      .productsListFromSameCompany[
                                  index]
                                      .title_english ??
                                      "",
                                  desc: parseHtmlString(providerListener
                                      .productsListFromSameCompany[
                                  index]
                                      .desc_english) ??
                                      "",
                                  imgPath: providerListener
                                      .productsListFromSameCompany[
                                  index]
                                      .bigthumb_url ??
                                      "",
                                  onPressed: () {
                                    pushReplacement(
                                        context,
                                        DetailedProducts(
                                            providerListener
                                                .productsListFromSameCompany[
                                            index]
                                                .id,
                                            providerListener
                                                .productsListFromSameCompany[
                                            index]
                                                .user_id));
                                  },
                                );
                              }),
                        )
                            : SizedBox(
                          height: 1,
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        providerListener.productsListofSimilar.length > 0
                            ? Container(
                          height: (providerListener
                              .productsListofSimilar
                              .length /
                              2)
                              .ceil()
                              .toDouble() *
                              265 +
                              100,
                          width: double.infinity,
                          color: Color(0xFFEBEBEB),
                          padding: EdgeInsets.only(
                              left: 30,
                              right: 30,
                              top: 24,
                              bottom: 0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(
                                        context, 'simmilar_prod'),
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF383838),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        //one category id
                                        List<int> ids = [];
                                        ids.add(providerListener
                                            .productsDetails
                                            .product_category_id);
//                                        push(
//                                            context,
//                                            productsFound(
//                                                0,
//                                                getTranslated(
//                                                    context,
//                                                    'simmilar_prod'),
//                                                ids,
//                                                0));
                                      },
                                      child: Container(
                                        height: 22,
                                        width: 22,
                                        decoration: BoxDecoration(
                                            color: Colors
                                                .grey.shade400,
                                            borderRadius:
                                            BorderRadius
                                                .circular(50)),
                                        child: Icon(
                                          Icons
                                              .arrow_forward_ios_sharp,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ))
                                ],
                              ),
                              Container(
                                height: (providerListener
                                    .productsListofSimilar
                                    .length /
                                    2)
                                    .ceil()
                                    .toDouble() *
                                    232,
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeBottom: true,
                                  child: GridView.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      childAspectRatio: 0.8,
                                      children: List.generate(
                                          providerListener
                                              .productsListofSimilar
                                              .length, (index) {
                                        return GridProds(
                                          name: providerListener
                                              .productsListofSimilar[
                                          index]
                                              .title_english ??
                                              "",
                                          desc: parseHtmlString(
                                              providerListener
                                                  .productsListofSimilar[
                                              index]
                                                  .desc_english) ??
                                              "",
                                          imgPath: providerListener
                                              .productsListofSimilar[
                                          index]
                                              .bigthumb_url ??
                                              "",
                                          onPressed: () {
                                            pushReplacement(
                                                context,
                                                DetailedProducts(
                                                    providerListener
                                                        .productsListofSimilar[
                                                    index]
                                                        .id,
                                                    providerListener
                                                        .productsListofSimilar[
                                                    index]
                                                        .user_id));
                                          },
                                        );
                                      })),
                                ),
                              ),
                              SizedBox(
                                height: 70,
                              )
                            ],
                          ),
                        )
                            : SizedBox(
                          height: 1,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(80),
                        )
                      ],
                    )
                        : SizedBox(
                      height: 1,
                    )),
                //Slide Up Panel Starts from here
                providerListener.productsDetails != null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: _visible1,
                      maintainState: true,
                      maintainAnimation: true,
                      child: SlidingUpPanel(
                        controller: _pc1,
                        maxHeight: 550,
                        borderRadius: radius,
                        onPanelOpened: () {
                          setState(() {
                            _innerVisible = true;
                          });
                        },
                        onPanelClosed: () {
                          setState(() {
                            _innerVisible = false;
                          });
                        },
                        panel: Visibility(
                          visible: _innerVisible,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 33, vertical: 10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 76,
                                          height: 8,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade400,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  20)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      providerListener.productsDetails
                                          .title_english ??
                                          "",
                                      style: GoogleFonts.poppins(
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      height: 44,
                                      child: Text(
                                        getTranslated(context,
                                            'contactPopUpInfo') +
                                            " " +
                                            providerListener
                                                .productsDetails
                                                .organisation_name ??
                                            "",
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    providerListener.representativeList
                                        .length >
                                        0
                                        ? Container(
                                      height: 300,
                                      child: ListView.builder(
                                          itemCount: providerListener
                                              .representativeList
                                              .length,
                                          itemBuilder:
                                              (context, index) {
                                            return RepInformation(
                                              onCallPressed: () {
                                                if ((prefs.getInt(
                                                    'paywall') ??
                                                    0) ==
                                                    2 &&
                                                    (prefs.getString(
                                                        'membership_status') ??
                                                        "") !=
                                                        "active") {
                                                  push(context,
                                                      SubscribeToMembership());
                                                } else {
                                                  connectProductCall(
                                                      providerListener
                                                          .userprofileData
                                                          .user,
                                                      providerListener
                                                          .representativeList[
                                                      index]
                                                          .user_id,
                                                      providerListener
                                                          .productsDetails
                                                          .id,
                                                      providerListener
                                                          .representativeList[
                                                      index]
                                                          .mobile ??
                                                          "");
                                                }
                                              },
                                              onWhatAppPressed:
                                                  () async {
                                                setState(() {
                                                  indexSaveContact =
                                                      index;
                                                });
                                                if ((prefs.getInt(
                                                    'paywall') ??
                                                    0) ==
                                                    2 &&
                                                    (prefs.getString(
                                                        'membership_status') ??
                                                        "") !=
                                                        "active") {
                                                  push(context,
                                                      SubscribeToMembership());
                                                } else {
                                                  print(providerListener
                                                      .representativeList[
                                                  index]
                                                      .status);
                                                  if (providerListener
                                                      .representativeList[
                                                  index]
                                                      .status ==
                                                      "accepted") {
                                                    connectProductWhatsApp(
                                                        providerListener
                                                            .userprofileData
                                                            .user,
                                                        providerListener
                                                            .representativeList[
                                                        index]
                                                            .user_id,
                                                        providerListener
                                                            .productsDetails
                                                            .id,
                                                        providerListener
                                                            .representativeList[index]
                                                            .mobile ??
                                                            "",
                                                        0);
                                                  } else if (providerListener
                                                      .representativeList[
                                                  index]
                                                      .status ==
                                                      "not initiated") {
                                                    _pc1.close();
                                                    setState(() {
                                                      _visible3 =
                                                      true;
                                                      _visible1 =
                                                      false;
                                                      _pc3.open();
                                                    });
                                                  } else if (providerListener
                                                      .representativeList[
                                                  index]
                                                      .status ==
                                                      "initiated") {
                                                    //below condition if contact is not saved in current and request initiated from another device
                                                    String
                                                    mobileNumber =
                                                        providerListener
                                                            .representativeList[index]
                                                            .mobile ??
                                                            "";
                                                    PermissionStatus
                                                    permissionStatus =
                                                    await _getContactPermission();
                                                    if (permissionStatus ==
                                                        PermissionStatus
                                                            .granted) {
                                                      try {
                                                        Iterable<
                                                            Contact>
                                                        asdf =
                                                        await ContactsService.getContactsForPhone(
                                                            mobileNumber);

                                                        if (asdf.length ==
                                                            0) {
                                                          _pc1.close();
                                                          _visible1 =
                                                          false;
                                                          setState(
                                                                  () {
                                                                _pc3.open();
                                                                _visible3 =
                                                                true;
                                                              });
                                                        } else {
                                                          toastCommon(
                                                              context,
                                                              getTranslated(context, 'request_ent') ??
                                                                  "");
                                                        }
                                                      } catch (e) {
                                                        toastCommon(
                                                            context,
                                                            getTranslated(
                                                                context,
                                                                'no_data_tv'));
                                                      }
                                                    } else {
                                                      _handleInvalidPermissions(
                                                          permissionStatus);
                                                    }
                                                  }
                                                }
                                              },
                                              representativeOBJ:
                                              providerListener
                                                  .representativeList[
                                              index],
                                            );
                                          }),
                                    )
                                        : SizedBox(
                                      height: 1,
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Get a call from the company",
                                            style: GoogleFonts.poppins(
                                                fontSize: 13),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          CallMeButton(
                                            onPressed: () {
                                              if ((prefs.getInt(
                                                  'paywall') ??
                                                  0) ==
                                                  2 &&
                                                  (prefs.getString(
                                                      'membership_status') ??
                                                      "") !=
                                                      "active") {
                                                push(context,
                                                    SubscribeToMembership());
                                              } else {
                                                if (_isChecked == false) {
                                                  _pc1.close();
                                                  _visible1 = false;
                                                  _visible2 = true;
                                                  setState(() {
                                                    _pc2.open();
                                                  });
                                                } else {
                                                  Provider.of<CustomViewModel>(
                                                      context,
                                                      listen: false)
                                                      .requestCallMe(
                                                      providerListener
                                                          .userprofileData
                                                          .user,
                                                      providerListener
                                                          .productsDetails
                                                          .user_id,
                                                      providerListener
                                                          .productsDetails
                                                          .id)
                                                      .then((value) {
                                                    toastCommon(
                                                        context,
                                                        getTranslated(
                                                            context,
                                                            'request_ent') ??
                                                            "");
                                                  });
                                                }
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        collapsed: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(25),
                              vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: SizeConfig.screenWidth / 5),
                                child: Text(
                                  (providerListener.representativeList
                                      .length ??
                                      0)
                                      .toString() +
                                      " " +
                                      getTranslated(
                                          context, 'numberOfOnline')
                                          .toString(),
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  FavButton(
                                    providerListener: providerListener,
                                    onPressed: () {},
                                    favButtonChild: FavoriteButton(
                                      iconSize: 40,
                                      valueChanged: (_isFavorite) {
                                        print(
                                            'Is Favorite $_isFavorite)');
                                        Provider.of<
                                            CustomViewModel>(
                                            context,
                                            listen: false)
                                            .LikeDislikeProduct(
                                            providerListener
                                                .userprofileData.user,
                                            providerListener
                                                .productsDetails
                                                .user_id,
                                            providerListener
                                                .productsDetails.id);
                                      },
                                      isFavorite: (providerListener
                                          .productsDetails.liked ??
                                          false),
                                    ),
                                  ),
                                  Spacer(),
                                  ContactButton(
                                    onPressed: () {
                                      _pc1.open();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    providerListener.productsDetails != null
                        ? Visibility(
                      maintainState: true,
                      maintainAnimation: true,
                      visible: _visible2,
                      child: CallMeSlide(
                        radius: radius,
                        panelController: _pc2,
                        closePressed: () {
                          _pc2.close();
                          _visible2 = false;
                          _visible1 = true;
                          setState(() {
                            _pc1.open();
                          });
                        },
                        isChecked: _isChecked,
                        checkBoxChanged: (value) {
                          setState(() {
                            _isChecked = !_isChecked;
                            prefs.setBool('_isChecked', value);
                          });
                        },
                      ),
                    )
                        : SizedBox(
                      height: 1,
                    ),
                    providerListener.productsDetails != null &&
                        providerListener.representativeList.length >
                            0 &&
                        indexSaveContact != -1
                        ? Visibility(
                      maintainState: true,
                      maintainAnimation: true,
                      visible: _visible3,
                      child: SaveContact(
                        name: (providerListener
                            .representativeList[
                        indexSaveContact]
                            .first_name ??
                            "") +
                            " " +
                            (providerListener
                                .representativeList[
                            indexSaveContact]
                                .last_name ??
                                ""),
                        org_name: (providerListener.productsDetails
                            .organisation_name ??
                            ""),
                        image_url: (providerListener
                            .representativeList[
                        indexSaveContact]
                            .image_url ??
                            ""),
                        radius: radius,
                        panelController: _pc3,
                        closePressed: () {
                          _pc3.close();
                          _pc1.open();
                          setState(() {
                            _visible3 = false;
                            _visible1 = true;
                          });
                        },
                        saveContactPressed: () async {
                          PermissionStatus permissionStatus =
                          await _getContactPermission();
                          if (permissionStatus ==
                              PermissionStatus.granted) {
                            String mobileNumber = providerListener
                                .representativeList[
                            indexSaveContact]
                                .mobile ??
                                "";

                            Iterable<Contact> asdf =
                            await ContactsService
                                .getContactsForPhone(
                                mobileNumber);

                            if (asdf.length == 0) {
                              try {
                                Contact contact = Contact();
                                contact.givenName = providerListener
                                    .representativeList[
                                indexSaveContact]
                                    .first_name +
                                    " " +
                                    providerListener
                                        .representativeList[
                                    indexSaveContact]
                                        .last_name;
                                contact.displayName =
                                    providerListener
                                        .representativeList[
                                    indexSaveContact]
                                        .first_name +
                                        " " +
                                        providerListener
                                            .representativeList[
                                        indexSaveContact]
                                            .last_name;
                                contact.phones = [
                                  Item(
                                      label: "mobile",
                                      value: mobileNumber)
                                ];
                                contact.company = providerListener
                                    .productsDetails
                                    .organisation_name;
                                await ContactsService.addContact(
                                    contact);

                                Iterable<Contact> temp =
                                await ContactsService
                                    .getContactsForPhone(
                                    mobileNumber);

                                if (temp.length > 0) {
                                  print("******************added");
                                  //we have save log on server if saved
                                  connectProductWhatsAppWithSaveButton(
                                      providerListener
                                          .userprofileData.user,
                                      providerListener
                                          .representativeList[
                                      indexSaveContact]
                                          .user_id,
                                      providerListener
                                          .productsDetails.id,
                                      providerListener
                                          .representativeList[
                                      indexSaveContact]
                                          .mobile ??
                                          "",
                                      1);
                                } else {}
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              /*we have save log on server even if present in device as user may use other account in same device*/
                              print("******************present");
                              connectProductWhatsAppWithSaveButton(
                                  providerListener
                                      .userprofileData.user,
                                  providerListener
                                      .representativeList[
                                  indexSaveContact]
                                      .user_id,
                                  providerListener
                                      .productsDetails.id,
                                  providerListener
                                      .representativeList[
                                  indexSaveContact]
                                      .mobile ??
                                      "",
                                  1);
                            }
                          } else {
                            _handleInvalidPermissions(
                                permissionStatus);
                          }
                        },
                      ),
                    )
                        : SizedBox(
                      height: 1,
                    ),
                    providerListener.productsDetails != null &&
                        providerListener.representativeList.length >
                            0 &&
                        indexSaveContact != -1
                        ? Visibility(
                      maintainState: true,
                      maintainAnimation: true,
                      visible: _visible4,
                      child: WhatsAppReqSent(
                        radius: radius,
                        panelController: _pc4,
                        closePressed: () {
                          _pc4.close();
                          _visible4 = false;
                          _visible1 = true;
                          setState(() {
                            _pc1.open();
                          });
                        },
                        whatsAppPressed: () {
                          _pc4.close();
                          _visible4 = false;
                          _visible1 = true;
                          setState(() {
                            _pc1.open();
                          });
                        },
                      ),
                    )
                        : SizedBox(
                      height: 7,
                    ),
                  ],
                )
                    : SizedBox(height: 1),
              ],
            ) :
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(206)),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          CustomBackButton(
                            text: "Machinery & Tools >",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: getProportionateScreenWidth(85),
                                height: providerListener
                                        .productsDetailsAssetsUrl.length
                                        .toDouble() *
                                    100,
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: providerListener
                                        .productsDetailsAssetsUrl.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        width: getProportionateScreenWidth(85),
                                        height: getProportionateScreenWidth(85),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Color(0xFFCECECE)),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  providerListener
                                                          .productsDetailsAssets[
                                                              index]
                                                          .media_url ??
                                                      ""),
                                            )),
                                      );
                                    }),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: getProportionateScreenWidth(400),
                                height: getProportionateScreenWidth(400),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: Color(0xFFCECECE)),
                                    image: DecorationImage(
                                        image: NetworkImage(providerListener
                                                .productsDetailsAssets[0]
                                                .media_url ??
                                            ""),
                                        fit: BoxFit.cover)),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Text(
                                          languageCode == "en"
                                              ? utf8.decode(providerListener
                                                      .productsDetails
                                                      .title_english
                                                      .toString()
                                                      .runes
                                                      .toList() ??
                                                  "")
                                              : languageCode == "hi"
                                                  ? utf8.decode(providerListener
                                                          .productsDetails
                                                          .title_hindi
                                                          .toString()
                                                          .runes
                                                          .toList() ??
                                                      "")
                                                  : utf8.decode(providerListener
                                                          .productsDetails
                                                          .title_marathi
                                                          .toString()
                                                          .runes
                                                          .toList() ??
                                                      ""),
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: Color(0xFF044BB0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: RichText(
                                            text: TextSpan(
                                                text: currencySymbl,
                                                style: GoogleFonts.poppins(
                                                  color: Color(0xFF393939),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                children: [
                                              TextSpan(
                                                text: " " +
                                                    (providerListener
                                                                .productsDetails
                                                                .price ??
                                                            0)
                                                        .toString(),
                                                style: GoogleFonts.poppins(
                                                    color: Color(0xFF393939),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text: " onwards",
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 20))
                                            ])),
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: CompanyLink(
                                          title: providerListener
                                                  .productsDetails
                                                  .organisation_name ??
                                              "",
                                          imagePath: providerListener
                                                  .productsDetails
                                                  .image_bigthumb_url ??
                                              "",
                                          onPressed: () {
                                            push(
                                                context,
                                                CompanyDetails(providerListener
                                                    .productsDetails.user_id));
                                            print(
                                                "Company link Pressed : To Company Profile");
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Text(
                                          parseHtmlString(languageCode == "en"
                                              ? utf8.decode(providerListener
                                                      .productsDetails
                                                      .desc_english
                                                      .toString()
                                                      .runes
                                                      .toList() ??
                                                  "")
                                              : languageCode == "hi"
                                                  ? utf8.decode(providerListener
                                                          .productsDetails
                                                          .desc_hindi
                                                          .toString()
                                                          .runes
                                                          .toList() ??
                                                      "")
                                                  : utf8.decode(providerListener
                                                          .productsDetails
                                                          .desc_marathi
                                                          .toString()
                                                          .runes
                                                          .toList() ??
                                                      "")),
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Color(0xFF393939),
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      /*SizedBox(
                                              height: 30,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 30),
                                              child: Text(
                                                'Special Offer',
                                                style: GoogleFonts.poppins(
                                                  color: Color(0xFF044BB0),
                                                  fontSize:
                                                      getProportionateScreenHeight(20),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 220,
                                              child: ListView.builder(
                                                  itemCount: 3,
                                                  scrollDirection: Axis.horizontal,
                                                  itemBuilder: (context, index) {
                                                    //TODO: get from server
                                                    return Offers(context);
                                                  }),
                                            ),*/
                                      //PDF Button ------------
                                      SizedBox(
                                        height: 30,
                                      ),
                                      providerListener.productsDetailsBrouchers
                                                  .length >
                                              0
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 30),
                                                  child: Text(
                                                    getTranslated(
                                                        context, 'Broucher'),
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xFF044BB0),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 13,
                                                ),
                                                Container(
                                                  height: ((providerListener
                                                              .productsDetailsBrouchers
                                                              .length)
                                                          .toDouble()) *
                                                      100,
                                                  width: getProportionateScreenWidth(404),
                                                  child:
                                                      MediaQuery.removePadding(
                                                    context: context,
                                                    removeTop: true,
                                                    removeBottom: true,
                                                    child: ListView.builder(
                                                        itemCount: providerListener
                                                            .productsDetailsBrouchers
                                                            .length,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return PDFButton(
                                                            onWholePressed: () {
                                                              push(
                                                                  context,
                                                                  pdfviewer(
                                                                      providerListener
                                                                          .productsDetailsBrouchers[
                                                                              index]
                                                                          .title,
                                                                      providerListener
                                                                          .productsDetailsBrouchers[
                                                                              index]
                                                                          .media_url));
                                                            },
                                                            onDownloadPressed:
                                                                () {
                                                              print(
                                                                  "Download Pdf");
                                                              setState(() {
                                                                download_link =
                                                                    providerListener
                                                                        .productsDetailsBrouchers[
                                                                            index]
                                                                        .media_url;
                                                              });

                                                              universalLoader
                                                                  .style(
                                                                      message:
                                                                          'Downloading file...',
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      progressWidget:
                                                                          CircularProgressIndicator(
                                                                        strokeWidth:
                                                                            10,
                                                                        backgroundColor:
                                                                            Color(COLOR_PRIMARY),
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
                                                                      ),
                                                                      elevation:
                                                                          10.0,
                                                                      insetAnimCurve:
                                                                          Curves
                                                                              .easeInOutSine,
                                                                      progress:
                                                                          0.0,
                                                                      maxProgress:
                                                                          100.0,
                                                                      progressTextStyle: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              13.0,
                                                                          fontWeight: FontWeight
                                                                              .w400),
                                                                      messageTextStyle: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              19.0,
                                                                          fontWeight:
                                                                              FontWeight.w600));

                                                              _download();
                                                            },
                                                            onPdfPressed: () {
                                                              print("View Pdf");
                                                              push(
                                                                  context,
                                                                  pdfviewer(
                                                                      providerListener
                                                                          .productsDetailsBrouchers[
                                                                              index]
                                                                          .title,
                                                                      providerListener
                                                                          .productsDetailsBrouchers[
                                                                              index]
                                                                          .media_url));
                                                            },
                                                            broucherOBJ:
                                                                providerListener
                                                                        .productsDetailsBrouchers[
                                                                    index],
                                                          );
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              height: 1,
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Text(
                                          'Special Offer',
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFF044BB0),
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    20),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 220,
                                        child: ListView.builder(
                                            itemCount: 3,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              //TODO: get from server
                                              return Offers(context);
                                            }),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 31,
                          ),
                          providerListener.productsListFromSameCompany.length >
                                  0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getTranslated(context, 'Simmilar') +
                                            "More from " +
                                            (providerListener.productsDetails
                                                    .organisation_name ??
                                                ""),
                                        maxLines: 2,
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF044BB0),
                                          fontSize:
                                              getProportionateScreenHeight(20),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      //Change it with different SVG
                                      GestureDetector(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.play_circle_fill_outlined,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                          providerListener.productsListFromSameCompany.length >
                                  0
                              ? Container(
                                  height: 260,
                                  child: ListView.builder(
                                      itemCount: providerListener
                                          .productsListFromSameCompany.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return MoreProds(
                                          name: providerListener
                                                  .productsListFromSameCompany[
                                                      index]
                                                  .title_english ??
                                              "",
                                          desc: parseHtmlString(providerListener
                                                  .productsListFromSameCompany[
                                                      index]
                                                  .desc_english) ??
                                              "",
                                          imgPath: providerListener
                                                  .productsListFromSameCompany[
                                                      index]
                                                  .bigthumb_url ??
                                              "",
                                          onPressed: () {
                                            pushReplacement(
                                                context,
                                                DetailedProducts(
                                                    providerListener
                                                        .productsListFromSameCompany[
                                                            index]
                                                        .id,
                                                    providerListener
                                                        .productsListFromSameCompany[
                                                            index]
                                                        .user_id));
                                          },
                                        );
                                      }),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                          SizedBox(
                            height: 36,
                          ),
                          providerListener.productsListofSimilar.length > 0
                              ? Container(
                                  height: 500,
                                  color: Color(0xFFEBEBEB),
                                  padding: EdgeInsets.only(
                                      left: 30, right: 30, top: 24, bottom: 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getTranslated(context, 'simmilar_prod'),
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF383838),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        height: 220,
                                        child: ListView.builder(
                                            itemCount: providerListener
                                                .productsListofSimilar.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return GridProds(
                                                name: providerListener
                                                        .productsListofSimilar[
                                                            index]
                                                        .title_english ??
                                                    "",
                                                desc: parseHtmlString(
                                                        providerListener
                                                            .productsListofSimilar[
                                                                index]
                                                            .desc_english) ??
                                                    "",
                                                imgPath: providerListener
                                                        .productsListofSimilar[
                                                            index]
                                                        .bigthumb_url ??
                                                    "",
                                                onPressed: () {
                                                  pushReplacement(
                                                      context,
                                                      DetailedProducts(
                                                          providerListener
                                                              .productsListofSimilar[
                                                                  index]
                                                              .id,
                                                          providerListener
                                                              .productsListofSimilar[
                                                                  index]
                                                              .user_id));
                                                },
                                              );
                                            }),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                //Slide Up Panel Starts from here
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 4
                          )
                        ]
                    ),
                    height: getProportionateScreenHeight(106),
                    margin: EdgeInsets.only(left: getProportionateScreenWidth(842),right: getProportionateScreenWidth(200)),
                    padding: EdgeInsets.symmetric(
                        horizontal:
                        getProportionateScreenWidth(25),
                        vertical: 5),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FavButton(
                          providerListener: providerListener,
                          onPressed: () {},
                          favButtonChild: FavoriteButton(
                            iconSize: 40,
                            valueChanged: (_isFavorite) {
                              print(
                                  'Is Favorite $_isFavorite)');
                              Provider.of<CustomViewModel>(
                                  context,
                                  listen: false)
                                  .LikeDislikeProduct(
                                  providerListener
                                      .userprofileData
                                      .user,
                                  providerListener
                                      .productsDetails
                                      .user_id,
                                  providerListener
                                      .productsDetails
                                      .id);
                            },
                            isFavorite: (providerListener
                                .productsDetails.liked ??
                                false),
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(25),),
                        ContactButton(
                          onPressed: () {
                            _pc1.open();
                          },
                        ),
                        SizedBox(width: getProportionateScreenWidth(25),),
                        Container(
                          child: Text(
                            (providerListener
                                .representativeList
                                .length ??
                                0)
                                .toString() +
                                " " +
                                getTranslated(context,
                                    'numberOfOnline')
                                    .toString(),
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          width: getProportionateScreenWidth(204),
                        ),
                      ],
                    ),
                  ),
                ),
                providerListener.productsDetails != null
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: _visible1,
                              maintainState: true,
                              maintainAnimation: true,
                              child: SlidingUpPanel(
                                margin: EdgeInsets.only(
                                    left: getProportionateScreenWidth(1197),
                                    right: getProportionateScreenWidth(309)),
                                controller: _pc1,
                                maxHeight: getProportionateScreenHeight(710),
                                minHeight: getProportionateScreenHeight(0),
                                borderRadius: radius,
                                onPanelOpened: () {
                                  setState(() {
                                    _innerVisible = true;
                                  });
                                },
                                onPanelClosed: () {
                                  setState(() {
                                    _innerVisible = false;
                                  });
                                },
                                panel: Visibility(
                                  visible: _innerVisible,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 33, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            onPressed: (){
                                              _pc1.close();
                                            },
                                            icon: Icon(Icons.close),
                                            iconSize: getProportionateScreenHeight(40),
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          providerListener.productsDetails.title_english,
                                          style: GoogleFonts.poppins(fontSize: 13),
                                        ),
                                        SizedBox(height: getProportionateScreenHeight(20),),
                                        Container(
                                          height: 44,
                                          child: Text(
                                            getTranslated(context,
                                                        'contactPopUpInfo') +
                                                    " " +
                                                    providerListener
                                                        .productsDetails
                                                        .organisation_name ??
                                                "",
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight:
                                                    FontWeight.bold),
                                          ),
                                        ),
                                        providerListener.representativeList
                                                    .length >
                                                0
                                            ? Container(
                                                height: getProportionateScreenHeight(370),
                                                child: ListView.builder(
                                                    itemCount: providerListener
                                                        .representativeList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return RepInformation(
                                                        onCallPressed: () {
                                                          if ((prefs.getInt(
                                                                          'paywall') ??
                                                                      0) ==
                                                                  2 &&
                                                              (prefs.getString(
                                                                          'membership_status') ??
                                                                      "") !=
                                                                  "active") {
                                                          }
                                                          else {
                                                            /*push(context,SubscribeToMembership());*/
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(35)),
                                                                      //this right here
                                                                      child: SubscribeToMembership()
                                                                  );
                                                                });
                                                            /*connectProductCall(
                                                                providerListener
                                                                    .userprofileData
                                                                    .user,
                                                                providerListener
                                                                    .representativeList[
                                                                        index]
                                                                    .user_id,
                                                                providerListener
                                                                    .productsDetails
                                                                    .id,
                                                                providerListener
                                                                        .representativeList[
                                                                            index]
                                                                        .mobile ??
                                                                    "");*/
                                                          }
                                                        },
                                                        onWhatAppPressed:
                                                            () async {
                                                          setState(() {
                                                            indexSaveContact =
                                                                index;
                                                          });
                                                          if ((prefs.getInt(
                                                                          'paywall') ??
                                                                      0) ==
                                                                  2 &&
                                                              (prefs.getString(
                                                                          'membership_status') ??
                                                                      "") !=
                                                                  "active")
                                                          {
                                                    /*push(context,SubscribeToMembership());*/
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(35)),
                                                                      //this right here
                                                                      child: SubscribeToMembership()
                                                                  );
                                                                });

                                                          } else {
                                                            /*print(providerListener
                                                                .representativeList[
                                                                    index]
                                                                .status);
                                                            if (providerListener
                                                                    .representativeList[
                                                                        index]
                                                                    .status ==
                                                                "accepted") {
                                                              connectProductWhatsApp(
                                                                  providerListener
                                                                      .userprofileData
                                                                      .user,
                                                                  providerListener
                                                                      .representativeList[
                                                                          index]
                                                                      .user_id,
                                                                  providerListener
                                                                      .productsDetails
                                                                      .id,
                                                                  providerListener
                                                                          .representativeList[index]
                                                                          .mobile ??
                                                                      "",
                                                                  0);
                                                            } else if (providerListener
                                                                    .representativeList[
                                                                        index]
                                                                    .status ==
                                                                "not initiated") {
                                                              _pc1.close();
                                                              setState(() {
                                                                _visible3 =
                                                                    true;
                                                                _visible1 =
                                                                    false;
                                                                _pc3.open();
                                                              });
                                                            } else if (providerListener
                                                                    .representativeList[
                                                                        index]
                                                                    .status ==
                                                                "initiated") {
                                                              //below condition if contact is not saved in current and request initiated from another device
                                                              String
                                                                  mobileNumber =
                                                                  providerListener
                                                                          .representativeList[index]
                                                                          .mobile ??
                                                                      "";
                                                              PermissionStatus
                                                                  permissionStatus =
                                                                  await _getContactPermission();
                                                              if (permissionStatus ==
                                                                  PermissionStatus
                                                                      .granted) {
                                                                try {
                                                                  Iterable<
                                                                          Contact>
                                                                      asdf =
                                                                      await ContactsService.getContactsForPhone(
                                                                          mobileNumber);

                                                                  if (asdf.length ==
                                                                      0) {
                                                                    _pc1.close();
                                                                    _visible1 =
                                                                        false;
                                                                    setState(
                                                                        () {
                                                                      _pc3.open();
                                                                      _visible3 =
                                                                          true;
                                                                    });
                                                                  } else {
                                                                    toastCommon(
                                                                        context,
                                                                        getTranslated(context, 'request_ent') ??
                                                                            "");
                                                                  }
                                                                } catch (e) {
                                                                  toastCommon(
                                                                      context,
                                                                      getTranslated(
                                                                          context,
                                                                          'no_data_tv'));
                                                                }
                                                              } else {
                                                                _handleInvalidPermissions(
                                                                    permissionStatus);
                                                              }
                                                            }*/
                                                          }
                                                        },
                                                        representativeOBJ:
                                                            providerListener
                                                                    .representativeList[
                                                                index],
                                                      );
                                                    }),
                                              )
                                            : SizedBox(
                                                height: 1,
                                              ),
                                        Spacer(),
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Get a call from the company",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),

                                              //Please check the Prefs of memeber ship coz the Subscribe dialog is not appearing

                                              CallMeButton(
                                                onPressed: () {
                                                  if ((prefs.getInt(
                                                                  'paywall') ??
                                                              0) ==
                                                          2 &&
                                                      (prefs.getString(
                                                                  'membership_status') ??
                                                              "") !=
                                                          "active") {
                                                    /*push(context,SubscribeToMembership());*/
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(35)),
                                                              //this right here
                                                              child: SubscribeToMembership()
                                                          );
                                                        });
                                                  } else {
                                                    if (_isChecked ==
                                                        false) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return Dialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                    BorderRadius.circular(35)),
                                                                //this right here
                                                                child: CallMeDialog(
                                                                  radius: radius,
                                                                  closePressed: () {
                                                                    pop(context);
                                                                  },
                                                                  isChecked: _isChecked,
                                                                  checkBoxChanged: (value) {
                                                                    setState(() {
                                                                      _isChecked = !_isChecked;
                                                                      prefs.setBool('_isChecked', value);
                                                                      print("_isChecked $_isChecked");
                                                                    });
                                                                  },
                                                                )
                                                            );
                                                          });
                                                    } else {
                                                      Provider.of<CustomViewModel>(
                                                              context,
                                                              listen: false)
                                                          .requestCallMe(
                                                              providerListener
                                                                  .userprofileData
                                                                  .user,
                                                              providerListener
                                                                  .productsDetails
                                                                  .user_id,
                                                              providerListener
                                                                  .productsDetails
                                                                  .id)
                                                          .then((value) {
                                                        toastCommon(
                                                            context,
                                                            getTranslated(
                                                                    context,
                                                                    'request_ent') ??
                                                                "");
                                                      });
                                                    }
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                collapsed: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenWidth(25),
                                      vertical: 5),
                                    /*child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      FavButton(
                                        providerListener: providerListener,
                                        onPressed: () {},
                                        favButtonChild: FavoriteButton(
                                          iconSize: 40,
                                          valueChanged: (_isFavorite) {
                                            print(
                                                'Is Favorite $_isFavorite)');
                                            Provider.of<CustomViewModel>(
                                                    context,
                                                    listen: false)
                                                .LikeDislikeProduct(
                                                    providerListener
                                                        .userprofileData
                                                        .user,
                                                    providerListener
                                                        .productsDetails
                                                        .user_id,
                                                    providerListener
                                                        .productsDetails
                                                        .id);
                                          },
                                          isFavorite: (providerListener
                                                  .productsDetails.liked ??
                                              false),
                                        ),
                                      ),
                                      ContactButton(
                                        onPressed: () {
                                          _pc1.open();
                                        },
                                      ),
                                      Container(
                                        child: Text(
                                          (providerListener
                                                          .representativeList
                                                          .length ??
                                                      0)
                                                  .toString() +
                                              " " +
                                              getTranslated(context,
                                                      'numberOfOnline')
                                                  .toString(),
                                          maxLines: 2,
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  )*/
                                ),
                              ),
                            ),
                            /*providerListener.productsDetails != null
                                ? Visibility(
                                    maintainState: true,
                                    maintainAnimation: true,
                                    visible: _visible2,
                                    child: CallMeSlide(
                                      radius: radius,
                                      panelController: _pc2,
                                      closePressed: () {
                                        _pc2.close();
                                        _visible2 = false;
                                        _visible1 = true;
                                        setState(() {
                                          _pc1.open();
                                        });
                                      },
                                      isChecked: _isChecked,
                                      checkBoxChanged: (value) {
                                        setState(() {
                                          _isChecked = !_isChecked;
                                          prefs.setBool('_isChecked', value);
                                        });
                                      },
                                    ),
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),*/
                            /*providerListener.productsDetails != null &&
                                    providerListener.representativeList.length >
                                        0 &&
                                    indexSaveContact != -1
                                ? Visibility(
                                    maintainState: true,
                                    maintainAnimation: true,
                                    visible: _visible3,
                                    child: SaveContact(
                                      name: (providerListener
                                                  .representativeList[
                                                      indexSaveContact]
                                                  .first_name ??
                                              "") +
                                          " " +
                                          (providerListener
                                                  .representativeList[
                                                      indexSaveContact]
                                                  .last_name ??
                                              ""),
                                      org_name: (providerListener
                                              .productsDetails
                                              .organisation_name ??
                                          ""),
                                      image_url: (providerListener
                                              .representativeList[
                                                  indexSaveContact]
                                              .image_url ??
                                          ""),
                                      radius: radius,
                                      panelController: _pc3,
                                      closePressed: () {
                                        _pc3.close();
                                        _pc1.open();
                                        setState(() {
                                          _visible3 = false;
                                          _visible1 = true;
                                        });
                                      },
                                      saveContactPressed: () async {
                                        PermissionStatus permissionStatus =
                                            await _getContactPermission();
                                        if (permissionStatus ==
                                            PermissionStatus.granted) {
                                          String mobileNumber = providerListener
                                                  .representativeList[
                                                      indexSaveContact]
                                                  .mobile ??
                                              "";

                                          Iterable<Contact> asdf =
                                              await ContactsService
                                                  .getContactsForPhone(
                                                      mobileNumber);

                                          if (asdf.length == 0) {
                                            try {
                                              Contact contact = Contact();
                                              contact.givenName =
                                                  providerListener
                                                          .representativeList[
                                                              indexSaveContact]
                                                          .first_name +
                                                      " " +
                                                      providerListener
                                                          .representativeList[
                                                              indexSaveContact]
                                                          .last_name;
                                              contact.displayName =
                                                  providerListener
                                                          .representativeList[
                                                              indexSaveContact]
                                                          .first_name +
                                                      " " +
                                                      providerListener
                                                          .representativeList[
                                                              indexSaveContact]
                                                          .last_name;
                                              contact.phones = [
                                                Item(
                                                    label: "mobile",
                                                    value: mobileNumber)
                                              ];
                                              contact.company = providerListener
                                                  .productsDetails
                                                  .organisation_name;
                                              await ContactsService.addContact(
                                                  contact);

                                              Iterable<Contact> temp =
                                                  await ContactsService
                                                      .getContactsForPhone(
                                                          mobileNumber);

                                              if (temp.length > 0) {
                                                print(
                                                    "******************added");
                                                //we have save log on server if saved
                                                connectProductWhatsAppWithSaveButton(
                                                    providerListener
                                                        .userprofileData.user,
                                                    providerListener
                                                        .representativeList[
                                                            indexSaveContact]
                                                        .user_id,
                                                    providerListener
                                                        .productsDetails.id,
                                                    providerListener
                                                            .representativeList[
                                                                indexSaveContact]
                                                            .mobile ??
                                                        "",
                                                    1);
                                              } else {}
                                            } catch (e) {
                                              print(e);
                                            }
                                          } else {
                //we have save log on server even if present in device as user may use other account in same device
                                            print("******************present");
                                            connectProductWhatsAppWithSaveButton(
                                                providerListener
                                                    .userprofileData.user,
                                                providerListener
                                                    .representativeList[
                                                        indexSaveContact]
                                                    .user_id,
                                                providerListener
                                                    .productsDetails.id,
                                                providerListener
                                                        .representativeList[
                                                            indexSaveContact]
                                                        .mobile ??
                                                    "",
                                                1);
                                          }
                                        } else {
                                          _handleInvalidPermissions(
                                              permissionStatus);
                                        }
                                      },
                                    ),
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),*/
                            /*providerListener.productsDetails != null &&
                                    providerListener.representativeList.length >
                                        0 &&
                                    indexSaveContact != -1
                                ? Visibility(
                                    maintainState: true,
                                    maintainAnimation: true,
                                    visible: _visible4,
                                    child: WhatsAppReqSent(
                                      radius: radius,
                                      panelController: _pc4,
                                      closePressed: () {
                                        _pc4.close();
                                        _visible4 = false;
                                        _visible1 = true;
                                        setState(() {
                                          _pc1.open();
                                        });
                                      },
                                      whatsAppPressed: () {
                                        _pc4.close();
                                        _visible4 = false;
                                        _visible1 = true;
                                        setState(() {
                                          _pc1.open();
                                        });
                                      },
                                    ),
                                  )
                                : SizedBox(
                                    height: 7,
                                  ),*/
                          ],
                        ),
                      )
                    : SizedBox(height: 1),

              ],
            ),
          )
        : Container(
            height: SizeConfig.screenHeight,
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

  Widget Offers(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Color(0xFF08A796).withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2)
        ],
        color: Color(0xFF08A796),
      ),
      margin: EdgeInsets.only(
          top: getProportionateScreenHeight(20),
          left: getProportionateScreenHeight(30),
          bottom: getProportionateScreenHeight(20)),
      width: 150,
      child: Stack(
        children: [
          Center(
            child: Container(
                width: getProportionateScreenWidth(125),
                child: Image.asset("assets/images/tractor.png")),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "10%",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Discount",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavButton extends StatelessWidget {
  const FavButton({
    Key key,
    @required this.providerListener,
    this.onPressed,
    this.favButtonChild,
  }) : super(key: key);

  final CustomViewModel providerListener;
  final Function onPressed;
  final FavoriteButton favButtonChild;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints.tightFor(
            height: getProportionateScreenHeight(65)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: onPressed,
          child: Row(
            children: [
              favButtonChild,
              SizedBox(width: getProportionateScreenWidth(10),),
              Text("#Add to Wishlist",style: GoogleFonts.poppins(
                color: Color(0xFF9B9B9B),

              ),)
            ],
          ),
        ));
  }
}

class CallMeDialog extends StatelessWidget {

  const CallMeDialog({
    Key key,
    @required this.radius,
    this.closePressed,
    this.saveContactPressed,
    this.checkBoxChanged,
    this.isChecked,
  }) : super(key: key);

  final BorderRadiusGeometry radius;
  final Function closePressed, saveContactPressed, checkBoxChanged;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    return Container(
      padding: EdgeInsets.all(20),
      width: getProportionateScreenWidth(639),
      height: getProportionateScreenHeight(560),
      child: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  providerListener.productsDetails.title_english,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(16),
                ),
                Container(
                  height: getProportionateScreenHeight(44),
                  child: Text(
                    getTranslated(context, 'contactPopUpInfo') + " ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  providerListener.productsDetails.title_english,
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E3E3E)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  getTranslated(context, 'you_should_receive_a_call_from_them'),
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8E8E8E)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(19),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: getProportionateScreenWidth(45),
                      backgroundImage:
                      NetworkImage(providerListener.userprofileData.image_url),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    FaIcon(
                      FontAwesomeIcons.share,
                      color: Colors.green,
                      size: 22,
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    CircleAvatar(
                      radius: getProportionateScreenWidth(45),
                      backgroundImage: NetworkImage(
                          providerListener.productsDetails.smallthumb_url),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        activeColor: Color(COLOR_BACKGROUND),
                        checkColor: Colors.white,
                        value: isChecked,
                        onChanged: checkBoxChanged),
                    SizedBox(
                      width: getProportionateScreenWidth(5),
                    ),
                    Text(
                      getTranslated(context, 'do_not_show_this_message_again'),
                      style: GoogleFonts.poppins(
                        color: Color(0xFF8E8E8E),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          height: getProportionateScreenHeight(65),
                        ),
                        child: ElevatedButton(
                            onPressed: closePressed,
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                onPrimary: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Text(
                              getTranslated(context, 'no'),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300, fontSize: 20),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenHeight(10),
                    ),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(height: getProportionateScreenHeight(65)),
                        child: ElevatedButton(
                            onPressed: () {
                              Provider.of<CustomViewModel>(context, listen: false)
                                  .requestCallMe(
                                  providerListener.userprofileData.user,
                                  providerListener.productsDetails.user_id,
                                  providerListener.productsDetails.id)
                                  .then((value) {
                                toastCommon(context,
                                    getTranslated(context, 'callback_string'));
                                closePressed();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(35)),
                                          //this right here
                                          child: RequestSentDialog()
                                      );
                                    });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF008940),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Text(
                              getTranslated(context, 'okay'),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: closePressed,
              icon: Icon(Icons.close),
              iconSize: getProportionateScreenHeight(40),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

}

class RequestSentDialog extends StatelessWidget {
  const RequestSentDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(522),
      width: getProportionateScreenWidth(639),
      child: Stack(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Call back request sent successfully.",
                  style: GoogleFonts.poppins(
                      fontSize: getProportionateScreenHeight(29),
                      color: Color(0xFF008940)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(28),
                ),
                Icon(
                  Icons.check_circle_outline,
                  size: getProportionateScreenWidth(176),
                  color: Color(0xff008940),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: (){
                pop(context);
              },
              icon: Icon(Icons.close),
              iconSize: getProportionateScreenHeight(40),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class CallMeSlide extends StatelessWidget {
  const CallMeSlide({
    Key key,
    @required this.radius,
    this.panelController,
    this.closePressed,
    this.saveContactPressed,
    this.checkBoxChanged,
    this.isChecked,
  }) : super(key: key);

  final BorderRadiusGeometry radius;
  final PanelController panelController;
  final Function closePressed, saveContactPressed, checkBoxChanged;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SlidingUpPanel(
      controller: panelController,
      maxHeight: 550,
      margin: EdgeInsets.only(
          left: getProportionateScreenWidth(865),
          right: getProportionateScreenWidth(221)),
      borderRadius: radius,
      panel: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: IconButton(
                onPressed: closePressed,
                icon: Icon(Icons.close),
                iconSize: 40,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              providerListener.productsDetails.title_english,
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 44,
              child: Text(
                getTranslated(context, 'contactPopUpInfo') + " ",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              providerListener.productsDetails.title_english,
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E3E3E)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              getTranslated(context, 'you_should_receive_a_call_from_them'),
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8E8E8E)),
            ),
            SizedBox(
              height: 19,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage:
                      NetworkImage(providerListener.userprofileData.image_url),
                ),
                SizedBox(
                  width: 14,
                ),
                FaIcon(
                  FontAwesomeIcons.share,
                  color: Colors.green,
                  size: 22,
                ),
                SizedBox(
                  width: 14,
                ),
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                      providerListener.productsDetails.smallthumb_url),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    activeColor: Color(COLOR_BACKGROUND),
                    checkColor: Colors.white,
                    value: isChecked,
                    onChanged: checkBoxChanged),
                SizedBox(
                  width: 5,
                ),
                Text(
                  getTranslated(context, 'do_not_show_this_message_again'),
                  style: GoogleFonts.poppins(
                    color: Color(0xFF8E8E8E),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: 65,
                    ),
                    child: ElevatedButton(
                        onPressed: closePressed,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onPrimary: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Text(
                          getTranslated(context, 'no'),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300, fontSize: 20),
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 65),
                    child: ElevatedButton(
                        onPressed: () {
                          Provider.of<CustomViewModel>(context, listen: false)
                              .requestCallMe(
                                  providerListener.userprofileData.user,
                                  providerListener.productsDetails.user_id,
                                  providerListener.productsDetails.id)
                              .then((value) {
                            toastCommon(context,
                                getTranslated(context, 'callback_string'));
                            closePressed();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF008940),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Text(
                          getTranslated(context, 'okay'),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SaveContact extends StatefulWidget {
  const SaveContact({
    Key key,
    @required this.radius,
    this.name,
    this.org_name,
    this.panelController,
    this.closePressed,
    this.saveContactPressed,
    this.image_url,
  }) : super(key: key);

  final PanelController panelController;
  final Function closePressed, saveContactPressed;
  final String name, org_name, image_url;

  final BorderRadiusGeometry radius;

  @override
  _SaveContactState createState() => _SaveContactState();
}

class _SaveContactState extends State<SaveContact> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: widget.panelController,
      minHeight: 550,
      margin: EdgeInsets.only(
          left: getProportionateScreenWidth(865),
          right: getProportionateScreenWidth(221)),
      borderRadius: widget.radius,
      panel: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CloseButton(
              onPressed: widget.closePressed,
            ),
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(widget.image_url),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.name,
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E3E3E)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.org_name,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            Flexible(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                        getTranslated(context, 'save_contact_text').toString() +
                            "\n",
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.black),
                    children: [
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Image.asset(
                              "assets/images/whatsapp.png",
                              height: 18,
                            ),
                          )),
                      TextSpan(
                          text: "WhatsApp.",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF58C12A)))
                    ]),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              getTranslated(context, 'request_save_contact')
                  .replaceAll('{userNameText}', widget.name),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            Spacer(),
            ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(height: 65, width: double.infinity),
              child: ElevatedButton(
                  onPressed: widget.saveContactPressed,
                  style: ElevatedButton.styleFrom(
                      primary: Color(COLOR_BACKGROUND),
                      onPrimary: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Text(
                    getTranslated(context, 'save_contact'),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class WhatsAppReqSent extends StatelessWidget {
  const WhatsAppReqSent({
    Key key,
    @required this.radius,
    this.panelController,
    this.closePressed,
    this.whatsAppPressed,
  }) : super(key: key);

  final BorderRadiusGeometry radius;
  final PanelController panelController;
  final Function closePressed, whatsAppPressed;

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SlidingUpPanel(
      controller: panelController,
      borderRadius: radius,
      minHeight: 550,
      margin: EdgeInsets.only(
          left: getProportionateScreenWidth(865),
          right: getProportionateScreenWidth(221)),
      maxHeight: 550,
      panel: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CloseButton(
              onPressed: closePressed,
            ),
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage((providerListener
                      .representativeList[indexSaveContact].image_url ??
                  "")),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              (providerListener
                          .representativeList[indexSaveContact].first_name ??
                      "") +
                  " " +
                  (providerListener
                          .representativeList[indexSaveContact].last_name ??
                      ""),
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E3E3E)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              (providerListener.productsDetails.organisation_name ?? ""),
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            Icon(
              Icons.check,
              color: Color(0xFF47AF1A),
              size: 80,
            ),
            Text(
              getTranslated(context, 'request_save_contact').replaceAll(
                  '{userNameText}',
                  (providerListener
                          .representativeList[indexSaveContact].first_name ??
                      "")) /* +
                  ". You will be able to connect "
                      "on WhatsApp once he accepts it."*/
              ,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            Spacer(),
            ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(height: 65, width: double.infinity),
              child: ElevatedButton(
                  onPressed: whatsAppPressed,
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF1FFEB),
                      onPrimary: Color(0xFF47AF1A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: getTranslated(context, 'okay'),
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF58C12A)))
                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({
    Key key,
    this.onPressed,
  }) : super(key: key);
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.close),
        iconSize: 40,
        color: Colors.grey,
      ),
    );
  }
}

class CallMeButton extends StatelessWidget {
  const CallMeButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 365, height: 65),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Color(0xFFFFE867),
            onPrimary: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            textStyle:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.call),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(getTranslated(context, 'call_back_request'))
          ],
        ),
      ),
    );
  }
}

class RepInformation extends StatelessWidget {
  const RepInformation({
    Key key,
    this.onWhatAppPressed,
    this.onCallPressed,
    this.representativeOBJ,
  }) : super(key: key);

  final Function onWhatAppPressed, onCallPressed;
  final RepresentativeListParser representativeOBJ;

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Container(
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: getProportionateScreenHeight(25),
                backgroundColor: Colors.white,
                backgroundImage: representativeOBJ.image_url != null
                    ? NetworkImage(representativeOBJ.image_url)
                    : AssetImage('assets/images/google.jpg'),
              ),
              SizedBox(
                width: getProportionateScreenWidth(15),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: getProportionateScreenWidth(200),
                    child: Text(
                      representativeOBJ.first_name +
                          " " +
                          representativeOBJ.last_name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      representativeOBJ.languages.split(",").length > 0
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFFF9FFCC),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: Text(
                                  representativeOBJ.languages.split(",")[0],
                                  style: TextStyle(
                                    fontSize: 9,
                                  )),
                            )
                          : SizedBox(
                              width: 1,
                            ),
                      SizedBox(
                        width: 9,
                      ),
                      representativeOBJ.languages.split(",").length > 1
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFFF9FFCC),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: Text(
                                  representativeOBJ.languages.split(",")[1],
                                  style: TextStyle(
                                    fontSize: 9,
                                  )),
                            )
                          : SizedBox(
                              width: 1,
                            ),
                      representativeOBJ.languages.split(",").length > 2
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFFF9FFCC),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: Text(
                                  representativeOBJ.languages.split(",")[2],
                                  style: TextStyle(
                                    fontSize: 9,
                                  )),
                            )
                          : SizedBox(
                              width: 1,
                            ),
                    ],
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              representativeOBJ.contact_phone == true
                  ? InkWell(
                      onTap: onCallPressed,
                      child: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Icon(
                          Icons.call,
                          color: Colors.green,
                          size: getProportionateScreenWidth(17),
                        ),
                        radius: getProportionateScreenWidth(15),
                      ),
                    )
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              representativeOBJ.contact_whatsapp == true
                  ? InkWell(
                      onTap: onWhatAppPressed,
                      child: CircleAvatar(
                        backgroundColor: representativeOBJ.status == "accepted"
                            ? Colors.green.shade100
                            : representativeOBJ.status == "not initiated"
                                ? Colors.grey.shade300
                                : representativeOBJ.status == "initiated"
                                    ? Colors.yellow.shade100
                                    : Colors.grey.shade300,
                        //have to change this to SVG as there are 3 colors assigned to this :
                        //"not Added" :grey , "Requested" : yellow , "Added" : "green"
                        child: representativeOBJ.status == "accepted"
                            ? Image.asset(
                                "assets/images/whatsapp.png",
                                height: getProportionateScreenWidth(15),
                              )
                            : representativeOBJ.status == "not initiated"
                                ? Image.asset(
                                    "assets/images/whatsappGrey.png",
                                    height: getProportionateScreenWidth(15),
                                  )
                                : representativeOBJ.status == "initiated"
                                    ? Image.asset(
                                        "assets/images/whatsappYellow.png",
                                        height: getProportionateScreenWidth(15),
                                      )
                                    : Image.asset(
                                        "assets/images/whatsappGrey.png",
                                        height: getProportionateScreenWidth(15),
                                      ),
                        radius: getProportionateScreenWidth(15),
                      ),
                    )
                  : SizedBox(
                      width: 1,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactButton extends StatelessWidget {
  const ContactButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          height: getProportionateScreenHeight(65)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              primary: Color(0xFF044BB0),
              elevation: 1,
              padding: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.call),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              Text(
                getTranslated(context, 'contact'),
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}

class GridProds extends StatelessWidget {
  final Function onPressed;
  final String imgPath, name, desc;

  GridProds({this.onPressed, this.imgPath, this.name, this.desc});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isSmallScreen(context) ? GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            offset: const Offset(
              1.0,
              1.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          )
        ]),
        margin: EdgeInsets.only(top: 20, bottom: 20, left: 30),
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          image: NetworkImage(imgPath ?? ""),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                )),
            Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700]),
                      ),
                      Text(
                        desc,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    ) : GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 205,
        width: 170,
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            offset: const Offset(
              1.0,
              1.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          )
        ]),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: imgPath == null || imgPath == ""
                              ? AssetImage(
                                  "assets/images/product_placeholder.png")
                              : NetworkImage(imgPath ?? ""),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                )),
            Expanded(
                child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]),
                  ),
                  Text(
                    parseHtmlString(desc),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 10),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class MoreProds extends StatelessWidget {
  final Function onPressed;
  final String imgPath, name, desc;

  MoreProds({this.onPressed, this.imgPath, this.name, this.desc});

  @override
  Widget build(BuildContext context) {
    String description;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            offset: const Offset(
              1.0,
              1.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          )
        ]),
        margin: EdgeInsets.only(top: 20, bottom: 20, left: 30),
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          image: NetworkImage(imgPath ?? ""),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                )),
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]),
                  ),
                  Text(
                    desc,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class PDFButton extends StatelessWidget {
  const PDFButton({
    Key key,
    this.onPdfPressed,
    this.onDownloadPressed,
    this.broucherOBJ,
    this.onWholePressed,
  }) : super(key: key);

  final Function onPdfPressed, onDownloadPressed, onWholePressed;
  final DetailedBrouchersParser broucherOBJ;

  @override
  Widget build(BuildContext context) {double screenWidth = MediaQuery.of(context).size.width;
    return ResponsiveWidget.isSmallScreen(context) ? Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 82),
        child: ElevatedButton(
          onPressed: onWholePressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 3,
            padding: EdgeInsets.all(0),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 82,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(broucherOBJ.smallthumb_url ?? ""),
                        fit: BoxFit.fill),
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth / 3,
                    child: Text(
                      broucherOBJ.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                          color: Color(0xFF363636),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: onPdfPressed,
                icon: Icon(Icons.picture_as_pdf),
                color: Colors.grey,
                iconSize: getProportionateScreenHeight(30),
              ),
              IconButton(
                onPressed: onDownloadPressed,
                icon: Icon(Icons.download_sharp),
                color: Colors.grey,
                iconSize: getProportionateScreenHeight(30),
              )
            ],
          ),
        ),
      ),
    ) : Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 74,width: getProportionateScreenWidth(364)),
        child: ElevatedButton(
          onPressed: onWholePressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 3,
            padding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: getProportionateScreenWidth(82),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(broucherOBJ.smallthumb_url ?? ""),
                        fit: BoxFit.fill),
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),
              SizedBox(
                width: 13,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    child: Text(
                      broucherOBJ.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                          color: Color(0xFF363636),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: onPdfPressed,
                icon: Icon(Icons.picture_as_pdf),
                color: Colors.grey,
                iconSize: 22,
              ),
              IconButton(
                onPressed: onDownloadPressed,
                icon: Icon(Icons.download_sharp),
                color: Colors.grey,
                iconSize: 22,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyLink extends StatelessWidget {
  const CompanyLink({
    Key key,
    this.title,
    this.imagePath,
    this.onPressed,
  }) : super(key: key);

  final String title, imagePath;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10)
                      ]),
                  child: Center(
                      child: Image.network(
                    imagePath ?? "",
                    fit: BoxFit.contain,
                  )),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(15),
                ),
                Container(
                  width: 239,
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Color(0xFF5C5C5C),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

/*SingleChildScrollView(
                    child: providerListener.productsDetails != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              providerListener.productsDetailsAssetsUrl.length >
                                      0
                                  ? Stack(
                                      children: [
                                        CarouselSlider(
                                          options: CarouselOptions(
                                              onPageChanged: (index, onTap) {
                                                setState(() {
                                                  currentS = index;
                                                });
                                                print(currentS.toString());
                                              },
                                              autoPlay: true,
                                              height: SizeConfig.screenWidth,
                                              viewportFraction: 1,
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 2000)),
                                          items: providerListener
                                              .productsDetailsAssetsUrl
                                              .map((url) {
                                            int index = providerListener
                                                .productsDetailsAssetsUrl
                                                .indexOf(url);
                                            return Builder(
                                              builder: (BuildContext context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    providerListener
                                                                .productsDetailsAssets[
                                                                    index]
                                                                .media_type ==
                                                            "youtubevideo"
                                                        ? push(
                                                            context,
                                                            SamplePlayer(
                                                                null,
                                                                providerListener
                                                                    .productsDetailsAssets[
                                                                        index]
                                                                    .media_url))
                                                        : push(
                                                            context,
                                                            ViewPhotos(
                                                              url: providerListener
                                                                      .productsDetailsAssets[
                                                                          index]
                                                                      .media_url ??
                                                                  "",
                                                            ));
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: SizeConfig
                                                                .screenWidth -
                                                            10,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.green[700],
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  providerListener
                                                                          .productsDetailsAssets[
                                                                              index]
                                                                          .media_url ??
                                                                      ""),
                                                              fit: BoxFit.fill),
                                                        ),
                                                      ),
                                                      providerListener
                                                                  .productsDetailsAssets[
                                                                      index]
                                                                  .media_type ==
                                                              "youtubevideo"
                                                          ? Center(
                                                              child: Opacity(
                                                                opacity: 0.7,
                                                                child: Icon(
                                                                  Icons
                                                                      .play_circle_fill,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 50,
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              height: 1,
                                                            ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        ),
                                        Positioned(
                                          top: SizeConfig.screenWidth / 1.1,
                                          left: 0,
                                          right: 0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: providerListener
                                                .productsDetailsAssetsUrl
                                                .map((url) {
                                              int index = providerListener
                                                  .productsDetailsAssetsUrl
                                                  .indexOf(url);
                                              return Container(
                                                width: 30.0,
                                                height: 5.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: currentS == index
                                                      ? Colors.white
                                                      : Colors.black
                                                          .withOpacity(0.3),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 35,
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                              width: 55,
                                              height: 55,
                                            ),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white
                                                      .withOpacity(0.5),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15))),
                                              onPressed: () async {
                                                final RenderBox box =
                                                    context.findRenderObject();
                                                if (Platform.isAndroid) {
                                                  var response = await http.get(
                                                      Uri.parse((providerListener
                                                              .productsDetails
                                                              .bigthumb_url ??
                                                          "")));
                                                  final documentDirectory =
                                                      (await getExternalStorageDirectory())
                                                          .path;
                                                  File imgFile = new File(
                                                      '$documentDirectory/' +
                                                          providerListener
                                                              .productsDetails
                                                              .title_english +
                                                          ".png");
                                                  imgFile.writeAsBytesSync(
                                                      response.bodyBytes);

                                                  Share.shareFiles([
                                                    "${documentDirectory}/" +
                                                        providerListener
                                                            .productsDetails
                                                            .title_english +
                                                        ".png"
                                                  ],
                                                      text: "Hi, Check out this product.\n" +
                                                          (providerListener
                                                                  .productsDetails
                                                                  .title_english ??
                                                              "") +
                                                          " on kisan App\n");
                                                } else {
                                                  Share.share(
                                                      "Hi, Check out this product.\n" +
                                                          (providerListener
                                                                  .productsDetails
                                                                  .title_english ??
                                                              "") +
                                                          " on kisan App\n",
                                                      subject: (providerListener
                                                              .productsDetails
                                                              .bigthumb_url ??
                                                          ""),
                                                      sharePositionOrigin:
                                                          box.localToGlobal(
                                                                  Offset.zero) &
                                                              box.size);
                                                }
                                              },
                                              child: Icon(
                                                Icons.share,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 10,
                                          top: 35,
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                              width: 55,
                                              height: 55,
                                            ),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white
                                                      .withOpacity(0.5),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15))),
                                              onPressed: () {
                                                pop(context);
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 1,
                                    ),
                              SizedBox(
                                height: 27,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  languageCode == "en"
                                      ? utf8.decode(providerListener
                                              .productsDetails.title_english
                                              .toString()
                                              .runes
                                              .toList() ??
                                          "")
                                      : languageCode == "hi"
                                          ? utf8.decode(providerListener
                                                  .productsDetails.title_hindi
                                                  .toString()
                                                  .runes
                                                  .toList() ??
                                              "")
                                          : utf8.decode(providerListener
                                                  .productsDetails.title_marathi
                                                  .toString()
                                                  .runes
                                                  .toList() ??
                                              ""),
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Color(0xFF044BB0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: RichText(
                                    text: TextSpan(
                                        text: currencySymbl,
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF393939),
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        children: [
                                      TextSpan(
                                        text: " " +
                                            (providerListener.productsDetails
                                                        .price ??
                                                    0)
                                                .toString(),
                                        style: GoogleFonts.poppins(
                                            color: Color(0xFF393939),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text: " onwards",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20))
                                    ])),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  parseHtmlString(languageCode == "en"
                                      ? utf8.decode(providerListener
                                              .productsDetails.desc_english
                                              .toString()
                                              .runes
                                              .toList() ??
                                          "")
                                      : languageCode == "hi"
                                          ? utf8.decode(providerListener
                                                  .productsDetails.desc_hindi
                                                  .toString()
                                                  .runes
                                                  .toList() ??
                                              "")
                                          : utf8.decode(providerListener
                                                  .productsDetails.desc_marathi
                                                  .toString()
                                                  .runes
                                                  .toList() ??
                                              "")),
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Color(0xFF393939),
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  'Special Offer',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF044BB0),
                                    fontSize: getProportionateScreenHeight(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                height: 220,
                                child: ListView.builder(
                                    itemCount: 3,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      //TODO: get from server
                                      return Offers(context);
                                    }),
                              ),
                              //PDF Button ------------
                              SizedBox(
                                height: 30,
                              ),
                              providerListener.productsDetailsBrouchers.length >
                                      0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Text(
                                            getTranslated(context, 'Broucher'),
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFF044BB0),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 13,
                                        ),
                                        Container(
                                          height: ((providerListener
                                                      .productsDetailsBrouchers
                                                      .length)
                                                  .toDouble()) *
                                              100,
                                          width: SizeConfig.screenWidth,
                                          child: MediaQuery.removePadding(
                                            context: context,
                                            removeTop: true,
                                            removeBottom: true,
                                            child: ListView.builder(
                                                itemCount: providerListener
                                                    .productsDetailsBrouchers
                                                    .length,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return PDFButton(
                                                    onWholePressed: () {
                                                      push(
                                                          context,
                                                          pdfviewer(
                                                              providerListener
                                                                  .productsDetailsBrouchers[
                                                                      index]
                                                                  .title,
                                                              providerListener
                                                                  .productsDetailsBrouchers[
                                                                      index]
                                                                  .media_url));
                                                    },
                                                    onDownloadPressed: () {
                                                      print("Download Pdf");
                                                      setState(() {
                                                        download_link =
                                                            providerListener
                                                                .productsDetailsBrouchers[
                                                                    index]
                                                                .media_url;
                                                      });

                                                      universalLoader.style(
                                                          message:
                                                              'Downloading file...',
                                                          backgroundColor:
                                                              Colors.white,
                                                          progressWidget:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 10,
                                                            backgroundColor: Color(
                                                                COLOR_PRIMARY),
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Color(
                                                                        COLOR_BACKGROUND)),
                                                          ),
                                                          elevation: 10.0,
                                                          insetAnimCurve: Curves
                                                              .easeInOutSine,
                                                          progress: 0.0,
                                                          maxProgress: 100.0,
                                                          progressTextStyle:
                                                              TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      13.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          messageTextStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 19.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600));

                                                      _download();
                                                    },
                                                    onPdfPressed: () {
                                                      print("View Pdf");
                                                      push(
                                                          context,
                                                          pdfviewer(
                                                              providerListener
                                                                  .productsDetailsBrouchers[
                                                                      index]
                                                                  .title,
                                                              providerListener
                                                                  .productsDetailsBrouchers[
                                                                      index]
                                                                  .media_url));
                                                    },
                                                    broucherOBJ: providerListener
                                                            .productsDetailsBrouchers[
                                                        index],
                                                  );
                                                }),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 1,
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: CompanyLink(
                                  title: providerListener
                                          .productsDetails.organisation_name ??
                                      "",
                                  imagePath: providerListener
                                          .productsDetails.image_bigthumb_url ??
                                      "",
                                  onPressed: () {
                                    push(
                                        context,
                                        CompanyDetails(providerListener
                                            .productsDetails.user_id));
                                    print(
                                        "Company link Pressed : To Company Profile");
                                  },
                                ),
                              ),
                              //-----More from the company
                              SizedBox(
                                height: 31,
                              ),
                              providerListener
                                          .productsListFromSameCompany.length >
                                      0
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 300,
                                            child: Text(
                                              getTranslated(
                                                      context, 'Simmilar') +
                                                  "More from " +
                                                  (providerListener
                                                          .productsDetails
                                                          .organisation_name ??
                                                      ""),
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                color: Color(0xFF044BB0),
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        20),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          //Change it with different SVG
                                          GestureDetector(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.play_circle_fill_outlined,
                                              size: 25,
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 1,
                                    ),
                              providerListener
                                          .productsListFromSameCompany.length >
                                      0
                                  ? Container(
                                      height: 260,
                                      child: ListView.builder(
                                          itemCount: providerListener
                                              .productsListFromSameCompany
                                              .length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return MoreProds(
                                              name: providerListener
                                                      .productsListFromSameCompany[
                                                          index]
                                                      .title_english ??
                                                  "",
                                              desc: parseHtmlString(providerListener
                                                      .productsListFromSameCompany[
                                                          index]
                                                      .desc_english) ??
                                                  "",
                                              imgPath: providerListener
                                                      .productsListFromSameCompany[
                                                          index]
                                                      .bigthumb_url ??
                                                  "",
                                              onPressed: () {
                                                pushReplacement(
                                                    context,
                                                    DetailedProducts(
                                                        providerListener
                                                            .productsListFromSameCompany[
                                                                index]
                                                            .id,
                                                        providerListener
                                                            .productsListFromSameCompany[
                                                                index]
                                                            .user_id));
                                              },
                                            );
                                          }),
                                    )
                                  : SizedBox(
                                      height: 1,
                                    ),
                              SizedBox(
                                height: 36,
                              ),
                              providerListener.productsListofSimilar.length > 0
                                  ? Container(
                                      height: (providerListener
                                                          .productsListofSimilar
                                                          .length /
                                                      2)
                                                  .ceil()
                                                  .toDouble() *
                                              265 +
                                          100,
                                      width: double.infinity,
                                      color: Color(0xFFEBEBEB),
                                      padding: EdgeInsets.only(
                                          left: 30,
                                          right: 30,
                                          top: 24,
                                          bottom: 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(
                                                context, 'simmilar_prod'),
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFF383838),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            height: (providerListener
                                                            .productsListofSimilar
                                                            .length /
                                                        2)
                                                    .ceil()
                                                    .toDouble() *
                                                232,
                                            child: MediaQuery.removePadding(
                                              context: context,
                                              removeBottom: true,
                                              child: GridView.count(
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: 20,
                                                  crossAxisSpacing: 20,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  childAspectRatio: 0.8,
                                                  children: List.generate(
                                                      providerListener
                                                          .productsListofSimilar
                                                          .length, (index) {
                                                    return GridProds(
                                                      name: providerListener
                                                              .productsListofSimilar[
                                                                  index]
                                                              .title_english ??
                                                          "",
                                                      desc: parseHtmlString(
                                                              providerListener
                                                                  .productsListofSimilar[
                                                                      index]
                                                                  .desc_english) ??
                                                          "",
                                                      imgPath: providerListener
                                                              .productsListofSimilar[
                                                                  index]
                                                              .bigthumb_url ??
                                                          "",
                                                      onPressed: () {
                                                        pushReplacement(
                                                            context,
                                                            DetailedProducts(
                                                                providerListener
                                                                    .productsListofSimilar[
                                                                        index]
                                                                    .id,
                                                                providerListener
                                                                    .productsListofSimilar[
                                                                        index]
                                                                    .user_id));
                                                      },
                                                    );
                                                  })),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 70,
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 1,
                                    ),
                              SizedBox(
                                height: getProportionateScreenHeight(80),
                              )
                            ],
                          )
                        : SizedBox(
                            height: 1,
                          )),*/
