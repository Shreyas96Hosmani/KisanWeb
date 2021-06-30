import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

//import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
import 'package:kisanweb/UI/CompanyProfile/ViewPhotoScreen.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/DetailedScreens/VideoScreen.dart';
import 'package:kisanweb/UI/DetailedScreens/pdfViewer.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

SharedPreferences prefs;
String languageCode = 'en';

class AboutTab extends StatefulWidget {
  const AboutTab({
    Key key,
  }) : super(key: key);

  @override
  _AboutTabState createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  final Dio _dio = Dio();

  String download_link;

  String _progress = "-";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool _isAboutLoaded = false;

  Future<void> initTask() async {
    prefs = await SharedPreferences.getInstance();
    languageCode = prefs.getString(LAGUAGE_CODE) ?? "en";
    setState(() {
      _isAboutLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTask();
    //flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    /*final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);*/
    /*flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);*/
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
      /* print("total $received $total");
      if (received == total && total > 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Download Completed",
          style: TextStyle(color: Colors.white),
        )));
      }*/
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

    universalLoader.style(
        message: 'Downloading file...',
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

    return _isAboutLoaded == true
        ? /*Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            height: 500 +
                ((providerListener.companyDetailsBrouchers.length)*90).ceil().toDouble()+
                100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    parseHtmlString(languageCode == "en"
                        ? utf8.decode(
                            (providerListener.companyDetails.about ?? "")
                                .runes
                                .toList())
                        : languageCode == "hi"
                            ? utf8.decode((providerListener
                                            .companyDetails.about_hindi ??
                                        "")
                                    .runes
                                    .toList()) ??
                                ""
                            : utf8.decode((providerListener
                                            .companyDetails.about_marathi ??
                                        "")
                                    .runes
                                    .toList()) ??
                                ""),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 8,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                //Images Section
                providerListener.companyDetailsAssetsUrl.length > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: HeaderTexts(
                          title: 'Media',
                        ),
                      )
                    : SizedBox(
                        height: 1,
                      ),
                providerListener.companyDetailsAssetsUrl.length > 0
                    ? Container(
                        height: 122,
                        child: ListView.builder(
                            itemCount:
                                providerListener.companyDetailsAssetsUrl.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  providerListener.companyDetailsAssets[index]
                                              .media_type ==
                                          "youtubevideo"
                                      ? push(
                                          context,
                                          SamplePlayer(
                                              null,
                                              providerListener
                                                  .companyDetailsAssets[index]
                                                  .media_url))
                                      : push(
                                          context,
                                          ViewPhotos(
                                            url: providerListener
                                                        .companyDetailsAssetsUrl[
                                                    index] ??
                                                "",
                                          ));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 30),
                                  height: getProportionateScreenWidth(85),
                                  width: getProportionateScreenWidth(85),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(providerListener
                                                      .companyDetailsAssetsUrl[
                                                  index] ??
                                              ""),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        )
                                      ]),
                                ),
                              );
                            }),
                      )
                    : SizedBox(
                        height: 1,
                      ),
                SizedBox(
                  height: getProportionateScreenHeight(35),
                ),
                //Pdfs section
                providerListener.companyDetailsBrouchers.length > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: HeaderTexts(
                          title: getTranslated(context, 'broucher_txt'),
                        ),
                      )
                    : SizedBox(
                        height: 1,
                      ),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                providerListener.companyDetailsBrouchers.length > 0
                    ? Container(
                        height:
                            ((providerListener.companyDetailsBrouchers.length)
                                    .toDouble()) *
                                100,
                        width: SizeConfig.screenWidth,
                        child: MediaQuery.removePadding(
                          removeTop: true,
                          removeBottom: true,
                          context: context,
                          child: ListView.builder(
                              itemCount: providerListener
                                  .companyDetailsBrouchers.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return PDFButton(
                                  onWholePressed: () {
                                    print("View Pdf");
                                    push(
                                        context,
                                        pdfviewer(
                                            providerListener
                                                .companyDetailsBrouchers[index]
                                                .title,
                                            providerListener
                                                .companyDetailsBrouchers[index]
                                                .media_url));
                                  },
                                  onDownloadPressed: () async {
                                    print("Download Pdf");
                                    setState(() {
                                      download_link = providerListener
                                          .companyDetailsBrouchers[index]
                                          .media_url;
                                    });
                                    await canLaunch(providerListener
                                        .companyDetailsBrouchers[index]
                                        .media_url
                                        .toString());
                                    _download();
                                  },
                                  onPdfPressed: () {
                                    print("View Pdf");

                                    push(
                                        context,
                                        pdfviewer(
                                            providerListener
                                                .companyDetailsBrouchers[index]
                                                .title,
                                            providerListener
                                                .companyDetailsBrouchers[index]
                                                .media_url));
                                  },
                                  broucherOBJ: providerListener
                                      .companyDetailsBrouchers[index],
                                );
                              }),
                        ),
                      )
                    : SizedBox(
                        height: 1,
                      ),
              ],
            ),
          )*/
        Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 670,
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        parseHtmlString(languageCode == "en"
                            ? utf8.decode(
                                (providerListener.companyDetails.about ?? "")
                                    .runes
                                    .toList())
                            : languageCode == "hi"
                                ? utf8.decode((providerListener
                                                .companyDetails.about_hindi ??
                                            "")
                                        .runes
                                        .toList()) ??
                                    ""
                                : utf8.decode((providerListener
                                                .companyDetails.about_marathi ??
                                            "")
                                        .runes
                                        .toList()) ??
                                    ""),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 8,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.only(top: 20),
                      height: ((providerListener.companyDetailsBrouchers.length)
                              .toDouble()) *
                          100 + 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFDEDEDE)),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          providerListener.companyDetailsBrouchers.length > 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 30),
                                  child: HeaderTexts(
                                    title: getTranslated(context, 'broucher_txt'),
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            removeBottom: true,
                            context: context,
                            child: ListView.builder(
                                itemCount:
                                    providerListener.companyDetailsBrouchers.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return PDFButton(
                                    onWholePressed: () {
                                      print("View Pdf");
                                      push(
                                          context,
                                          pdfviewer(
                                              providerListener
                                                  .companyDetailsBrouchers[index]
                                                  .title,
                                              providerListener
                                                  .companyDetailsBrouchers[index]
                                                  .media_url));
                                    },
                                    onDownloadPressed: () async {
                                      print("Download Pdf");
                                      setState(() {
                                        download_link = providerListener
                                            .companyDetailsBrouchers[index]
                                            .media_url;
                                      });
                                      await canLaunch(providerListener
                                          .companyDetailsBrouchers[index].media_url
                                          .toString());
                                      _download();
                                    },
                                    onPdfPressed: () {
                                      print("View Pdf");

                                      push(
                                          context,
                                          pdfviewer(
                                              providerListener
                                                  .companyDetailsBrouchers[index]
                                                  .title,
                                              providerListener
                                                  .companyDetailsBrouchers[index]
                                                  .media_url));
                                    },
                                    broucherOBJ: providerListener
                                        .companyDetailsBrouchers[index],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                SizedBox(height: 150,)
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
}
