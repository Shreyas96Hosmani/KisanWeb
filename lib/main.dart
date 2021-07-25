import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
//import 'package:kisanweb/UI/Auth/LoginWithOTP.dart';
//import 'package:kisanweb/UI/BannerEvents/event_page.dart';
//import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/Intro/InitialScreen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'Helpers/helper.dart';
import 'Helpers/size_config.dart';
import 'Models/NotificationPayload.dart';
import 'View Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:kisanweb/localization/demo_localization.dart';
import 'dart:convert' show utf8;
import 'package:path_provider/path_provider.dart';
import 'services/web_service.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp("HomeScreen", 0, 0));
}

class MyApp extends StatefulWidget {
  String where;
  int id1, id2;

  MyApp(this.where, this.id1, this.id2);

  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState state = context.findAncestorStateOfType<MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  bool _isfilesLoaded = false;
  bool _isPermissionDenied = false;


  Future<void> initTask() async {
    final response = await WebService().GetLanguageKeys(1614837539938);

    if (response != "error") {
      String source = Utf8Decoder().convert(response.bodyBytes);

      var responseDecoded = jsonDecode(source);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      print("*****************" + responseDecodedSuccess);
      if (responseDecodedSuccess == "false") {
        toastCommon(context, "Please check your internet and reopen the app.");
      } else if (responseDecodedSuccess == "true") {
        final Map<String, String> EnglishMap = {};
        final Map<String, String> HindiMap = {};
        final Map<String, String> MarathiMap = {};

        final data = responseDecoded['data'];
        if (data != null) {
          for (Map i in data) {
            EnglishMap[i['key']] = i['en'];
            HindiMap[i['key']] = i['hi'];
            MarathiMap[i['key']] = i['mr'];
          }
        }

        storage.setItem('en', json.encode(EnglishMap));
        storage.setItem('hi', json.encode(HindiMap));
        storage.setItem('mr', json.encode(MarathiMap));

        setState(() {
          _isfilesLoaded = true;
        });

      }
    } else {
      toastCommon(context, "Please check your internet and reopen the app.");
    }
  }

  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    initTask();
    WidgetsBinding.instance.addObserver(this);
    initTask();
    if(kIsWeb){
      print("Running on web");
    }else{
      print("Not running on web");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    if (_isPermissionDenied == true) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Permissions Denied',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Please allow storage permission to run this app.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(COLOR_BACKGROUND),
                          fontSize: 16.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                      ),
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        elevation: 18.0,
                        color: Color(COLOR_BACKGROUND),
                        clipBehavior: Clip.antiAlias,
                        child: MaterialButton(
                            minWidth: 200.0,
                            height: 35,
                            child: new Text('Open Settings',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                            onPressed: () async {
                              openAppSettings();
                            }),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh,
                                color: Colors.black,
                                size: 25,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Refresh',
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Colors.black)),
                            ],
                          ),
                          onTap: () async {
                            setState(() {
                              _isPermissionDenied = false;
                            });
                            initTask();
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      if (this._locale != null && _isfilesLoaded == true) {
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Color(COLOR_BACKGROUND)));
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => CustomViewModel(),
              child: MaterialApp(
                  navigatorKey: navigatorKey,
                  locale: _locale,
                  theme: ThemeData(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  supportedLocales: [
                    Locale("en", "US"),
                    Locale("hi", "IN"),
                    Locale("mr", "IN")
                  ],
                  localizationsDelegates: [
                    DemoLocalization.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (locale, supportedLocales) {
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode == locale.languageCode &&
                          supportedLocale.countryCode == locale.countryCode) {
                        return supportedLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
                  debugShowCheckedModeBanner: false,
                  /* widget.where=="InitialScreen"?InitialScreen():widget.where=="DetailedProducts"?DetailedProducts(widget.id1, widget.id2):widget.where=="DetailedProducts"?DetailedProducts(widget.id1, widget.id2):widget.where=="BannerEventPage"?BannerEventPage(widget.id1):InitialScreen())*/
                  home: InitialScreen(widget.where, widget.id1, widget.id2)),
            ),
          ],
          child: MaterialApp(
              navigatorKey: navigatorKey,
              locale: _locale,
              supportedLocales: [
                Locale("en", "US"),
                Locale("hi", "IN"),
                Locale("mr", "IN")
              ],
              theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              localizationsDelegates: [
                DemoLocalization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              debugShowCheckedModeBanner: false,
              home: InitialScreen(widget.where, widget.id1, widget.id2)),
        );
      } else {
        return Container(
          height: SizeConfig.screenHeight,
          color: Color(COLOR_BACKGROUND),
          child: Center(
            child: new CircularProgressIndicator(
              strokeWidth: 1,
              backgroundColor: Color(COLOR_WHITE),
              valueColor:
              AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
            ),
          ),
        );
      }
    }

//    if(ResponsiveWidget.isSmallScreen(context) || ResponsiveWidget.isMediumScreen(context)){
//
//      print("SSSMMMAAALLL SSSCCCRRREEENNN");
//
//      if (_isPermissionDenied == true) {
//        return MaterialApp(
//          navigatorKey: navigatorKey,
//          title: 'Permissions Denied',
//          debugShowCheckedModeBanner: false,
//          theme: ThemeData(
//            brightness: Brightness.dark,
//          ),
//          home: Scaffold(
//            body: Container(
//              color: Colors.white,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: [
//                  Container(
//                    alignment: Alignment.center,
//                    margin: EdgeInsets.all(20),
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        Text(
//                          'Please allow storage permission to run this app.',
//                          textAlign: TextAlign.center,
//                          style: TextStyle(
//                            color: Color(COLOR_BACKGROUND),
//                            fontSize: 16.0,
//                          ),
//                        ),
//                        Container(
//                          margin: EdgeInsets.all(10),
//                        ),
//                        Container(
//                          margin: EdgeInsets.all(10),
//                        ),
//                        Material(
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(22.0)),
//                          elevation: 18.0,
//                          color: Color(COLOR_BACKGROUND),
//                          clipBehavior: Clip.antiAlias,
//                          child: MaterialButton(
//                              minWidth: 200.0,
//                              height: 35,
//                              child: new Text('Open Settings',
//                                  style: new TextStyle(
//                                      fontSize: 16.0, color: Colors.white)),
//                              onPressed: () async {
//                                openAppSettings();
//                              }),
//                        ),
//                        SizedBox(
//                          height: 50,
//                        ),
//                        InkWell(
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: [
//                                Icon(
//                                  Icons.refresh,
//                                  color: Colors.black,
//                                  size: 25,
//                                ),
//                                SizedBox(
//                                  width: 20,
//                                ),
//                                Text('Refresh',
//                                    style: new TextStyle(
//                                        fontSize: 16.0, color: Colors.black)),
//                              ],
//                            ),
//                            onTap: () async {
//                              setState(() {
//                                _isPermissionDenied = false;
//                              });
//                              initTask();
//                            }),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        );
//      } else {
//        if (this._locale != null && _isfilesLoaded == true) {
//          SystemChrome.setSystemUIOverlayStyle(
//              SystemUiOverlayStyle(statusBarColor: Color(COLOR_BACKGROUND)));
//          return MultiProvider(
//            providers: [
//              ChangeNotifierProvider(
//                create: (context) => CustomViewModel(),
//                child: MaterialApp(
//                    navigatorKey: navigatorKey,
//                    locale: _locale,
//                    supportedLocales: [
//                      Locale("en", "US"),
//                      Locale("hi", "IN"),
//                      Locale("mr", "IN")
//                    ],
//                    localizationsDelegates: [
//                      DemoLocalization.delegate,
//                      GlobalMaterialLocalizations.delegate,
//                      GlobalWidgetsLocalizations.delegate,
//                      GlobalCupertinoLocalizations.delegate,
//                    ],
//                    localeResolutionCallback: (locale, supportedLocales) {
//                      for (var supportedLocale in supportedLocales) {
//                        if (supportedLocale.languageCode == locale.languageCode &&
//                            supportedLocale.countryCode == locale.countryCode) {
//                          return supportedLocale;
//                        }
//                      }
//                      return supportedLocales.first;
//                    },
//                    debugShowCheckedModeBanner: false,
//                    /* widget.where=="InitialScreen"?InitialScreen():widget.where=="DetailedProducts"?DetailedProducts(widget.id1, widget.id2):widget.where=="DetailedProducts"?DetailedProducts(widget.id1, widget.id2):widget.where=="BannerEventPage"?BannerEventPage(widget.id1):InitialScreen())*/
//                    home: Scaffold(
//                      body: Center(
//                        child: Text("Hello Mobile!"),
//                      ),
//                    )),
//              ),
//            ],
//            child: MaterialApp(
//                navigatorKey: navigatorKey,
//                locale: _locale,
//                supportedLocales: [
//                  Locale("en", "US"),
//                  Locale("hi", "IN"),
//                  Locale("mr", "IN")
//                ],
//                localizationsDelegates: [
//                  DemoLocalization.delegate,
//                  GlobalMaterialLocalizations.delegate,
//                  GlobalWidgetsLocalizations.delegate,
//                  GlobalCupertinoLocalizations.delegate,
//                ],
//                localeResolutionCallback: (locale, supportedLocales) {
//                  for (var supportedLocale in supportedLocales) {
//                    if (supportedLocale.languageCode == locale.languageCode &&
//                        supportedLocale.countryCode == locale.countryCode) {
//                      return supportedLocale;
//                    }
//                  }
//                  return supportedLocales.first;
//                },
//                debugShowCheckedModeBanner: false,
//                home: InitialScreen(widget.where, widget.id1, widget.id2)),
//          );
//        } else {
//          return Container(
//            height: SizeConfig.screenHeight,
//            color: Color(COLOR_BACKGROUND),
//            child: Center(
//              child: new CircularProgressIndicator(
//                strokeWidth: 1,
//                backgroundColor: Color(COLOR_WHITE),
//                valueColor:
//                AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
//              ),
//            ),
//          );
//        }
//      }
//    }else{
//      if (_isPermissionDenied == true) {
//        return MaterialApp(
//          navigatorKey: navigatorKey,
//          title: 'Permissions Denied',
//          debugShowCheckedModeBanner: false,
//          theme: ThemeData(
//            brightness: Brightness.dark,
//            visualDensity: VisualDensity.adaptivePlatformDensity,
//          ),
//          home: Scaffold(
//            body: Container(
//              color: Colors.white,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: [
//                  Container(
//                    alignment: Alignment.center,
//                    margin: EdgeInsets.all(20),
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        Text(
//                          'Please allow storage permission to run this app.',
//                          textAlign: TextAlign.center,
//                          style: TextStyle(
//                            color: Color(COLOR_BACKGROUND),
//                            fontSize: 16.0,
//                          ),
//                        ),
//                        Container(
//                          margin: EdgeInsets.all(10),
//                        ),
//                        Container(
//                          margin: EdgeInsets.all(10),
//                        ),
//                        Material(
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(22.0)),
//                          elevation: 18.0,
//                          color: Color(COLOR_BACKGROUND),
//                          clipBehavior: Clip.antiAlias,
//                          child: MaterialButton(
//                              minWidth: 200.0,
//                              height: 35,
//                              child: new Text('Open Settings',
//                                  style: new TextStyle(
//                                      fontSize: 16.0, color: Colors.white)),
//                              onPressed: () async {
//                                openAppSettings();
//                              }),
//                        ),
//                        SizedBox(
//                          height: 50,
//                        ),
//                        InkWell(
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: [
//                                Icon(
//                                  Icons.refresh,
//                                  color: Colors.black,
//                                  size: 25,
//                                ),
//                                SizedBox(
//                                  width: 20,
//                                ),
//                                Text('Refresh',
//                                    style: new TextStyle(
//                                        fontSize: 16.0, color: Colors.black)),
//                              ],
//                            ),
//                            onTap: () async {
//                              setState(() {
//                                _isPermissionDenied = false;
//                              });
//                              initTask();
//                            }),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        );
//      } else {
//        if (this._locale != null && _isfilesLoaded == true) {
//          SystemChrome.setSystemUIOverlayStyle(
//              SystemUiOverlayStyle(statusBarColor: Color(COLOR_BACKGROUND)));
//          return MultiProvider(
//            providers: [
//              ChangeNotifierProvider(
//                create: (context) => CustomViewModel(),
//                child: MaterialApp(
//                    navigatorKey: navigatorKey,
//                    locale: _locale,
//                    theme: ThemeData(
//                      visualDensity: VisualDensity.adaptivePlatformDensity,
//                    ),
//                    supportedLocales: [
//                      Locale("en", "US"),
//                      Locale("hi", "IN"),
//                      Locale("mr", "IN")
//                    ],
//                    localizationsDelegates: [
//                      DemoLocalization.delegate,
//                      GlobalMaterialLocalizations.delegate,
//                      GlobalWidgetsLocalizations.delegate,
//                      GlobalCupertinoLocalizations.delegate,
//                    ],
//                    localeResolutionCallback: (locale, supportedLocales) {
//                      for (var supportedLocale in supportedLocales) {
//                        if (supportedLocale.languageCode == locale.languageCode &&
//                            supportedLocale.countryCode == locale.countryCode) {
//                          return supportedLocale;
//                        }
//                      }
//                      return supportedLocales.first;
//                    },
//                    debugShowCheckedModeBanner: false,
//                    /* widget.where=="InitialScreen"?InitialScreen():widget.where=="DetailedProducts"?DetailedProducts(widget.id1, widget.id2):widget.where=="DetailedProducts"?DetailedProducts(widget.id1, widget.id2):widget.where=="BannerEventPage"?BannerEventPage(widget.id1):InitialScreen())*/
//                    home: InitialScreen(widget.where, widget.id1, widget.id2)),
//              ),
//            ],
//            child: MaterialApp(
//                navigatorKey: navigatorKey,
//                locale: _locale,
//                supportedLocales: [
//                  Locale("en", "US"),
//                  Locale("hi", "IN"),
//                  Locale("mr", "IN")
//                ],
//                theme: ThemeData(
//                  visualDensity: VisualDensity.adaptivePlatformDensity,
//                ),
//                localizationsDelegates: [
//                  DemoLocalization.delegate,
//                  GlobalMaterialLocalizations.delegate,
//                  GlobalWidgetsLocalizations.delegate,
//                  GlobalCupertinoLocalizations.delegate,
//                ],
//                localeResolutionCallback: (locale, supportedLocales) {
//                  for (var supportedLocale in supportedLocales) {
//                    if (supportedLocale.languageCode == locale.languageCode &&
//                        supportedLocale.countryCode == locale.countryCode) {
//                      return supportedLocale;
//                    }
//                  }
//                  return supportedLocales.first;
//                },
//                debugShowCheckedModeBanner: false,
//                home: InitialScreen(widget.where, widget.id1, widget.id2)),
//          );
//        } else {
//          return Container(
//            height: SizeConfig.screenHeight,
//            color: Color(COLOR_BACKGROUND),
//            child: Center(
//              child: new CircularProgressIndicator(
//                strokeWidth: 1,
//                backgroundColor: Color(COLOR_WHITE),
//                valueColor:
//                AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
//              ),
//            ),
//          );
//        }
//      }
//    }
  }
}
