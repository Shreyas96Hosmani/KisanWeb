import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/Models/NotificationPayload.dart';

//import 'package:kisanweb/UI/BannerEvents/event_page.dart';
//import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/HomeScreen/Widgets/bottom_tabs.dart';
import 'package:kisanweb/UI/Intro/InitialScreen.dart';
import 'package:kisanweb/UI/Intro/LanguageScreen.dart';
import 'package:kisanweb/UI/Intro/splash_one.dart';

//import 'package:kisanweb/UI/NotficationScreen/Notifications.dart';
import 'package:kisanweb/UI/Profile/BasicProfile.dart';
import 'package:kisanweb/UI/SearchScreen/SearchScreen.dart';
import 'package:kisanweb/UI/Subscribe/SubscribeToMembership.dart';

//import 'package:kisanweb/UI/SearchScreen/SearchScreen.dart';
//import 'package:kisanweb/UI/Subscribe/SubscribeToMembership.dart';
import 'package:kisanweb/UI/Tabs/HistoryTab.dart';
import 'package:kisanweb/UI/Tabs/HomeTab.dart';
import 'package:kisanweb/UI/Tabs/ShortListedTab.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:kisanweb/main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';

//We are going to use the google client for this example...
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

SharedPreferences prefs;
String languageCode = 'en';

var fcmtoken = '';

BuildContext buildContext;

/*/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;*/

/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.data}');


  /*prefs.setString("checksave", "great");
  prefs.remove('checksave');*/

  NotificationPayload notificationPayload;


  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://mipmap/ic_launcher',
      [
        NotificationChannel(
            channelKey: '10000',
            channelName: 'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            defaultColor: Color(0xFF00A651),
            icon: 'resource://mipmap/ic_launcher',
            ledColor: Colors.white,
            channelShowBadge: true,
            enableVibration: true,
            importance: NotificationImportance.High)
      ]);

  if ("custom" == message.data['action']) {
    notificationPayload = NotificationPayload(
        message.data['wzrk_acct_id'].toString(),
        message.data['description'].toString(),
        message.data['notification_type'].toString(),
        message.data['offered'].toString(),
        message.data['action'].toString(),
        message.data['notification_id'].toString(),
        message.data['owner_organisation_name'].toString(),
        message.data['image_url'].toString(),
        message.data['owner_user_id'].toString(),
        message.data['user_id'].toString(),
        message.data['valid_date'].toString(),
        message.data['nm'].toString(),
        message.data['nt'].toString(),
        message.data['notification_user_id'].toString(),
        message.data['title'],
        message.data['offer_type'].toString(),
        message.data['event_id'].toString(),
        message.data['pushNotificationAction'].toString(),
        message.data['notification_action'].toString(),
        message.data['owner_image_url'].toString(),
        message.data['wzrk_pivot'].toString(),
        message.data['wzrk_cid'].toString(),
        message.data['wzrk_pid'].toString(),
        message.data['wzrk_rnv'].toString(),
        message.data['wzrk_ttl'].toString(),
        message.data['for_item_id'].toString(),
        message.data['wzrk_push_amp'].toString(),
        message.data['wzrk_dt'].toString(),
        message.data['wzrk_id'].toString(),
        message.data['wzrk_pn'].toString());

    if (message.data['notification_action'] == "org_event_promotion") {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(1000),
            channelKey: '10000',
            title: parseHtmlString(message.data['description'] ?? "title"),
            body: 'Event that may interest you!',
            largeIcon: message.data['owner_image_url'] ?? "",
            hideLargeIconOnExpand: true,
            bigPicture: message.data['image_url'] ?? "",
            notificationLayout: NotificationLayout.BigPicture,
          ),
          actionButtons: [
            NotificationActionButton(
              key: "see",
              label: "SEE DETAILS",
            )
          ]);
    } else if (message.data['notification_action'] == "org_product_promotion") {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(1000),
            channelKey: '10000',
            title: parseHtmlString(
                message.data['owner_organisation_name'] ?? "title"),
            body: 'has invited you to see their product' +
                " " +
                parseHtmlString(message.data['description'] ?? ""),
            largeIcon: message.data['owner_image_url'] ?? "",
            hideLargeIconOnExpand: true,
            bigPicture: message.data['image_url'] ?? "",
            notificationLayout: NotificationLayout.BigPicture,
          ),
          actionButtons: [
            NotificationActionButton(
              key: "see",
              label: "SEE DETAILS",
            ),
          ]);
    } else {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(1000),
              channelKey: '10000',
              title: "title",
              body: "body"),
          actionButtons: [
            NotificationActionButton(
              key: "see",
              label: "SEE DETAILS",
            )
          ]);
    }
    /*AwesomeNotifications().actionStream.listen((receivedNotification) {


      print("******* background");
      print(receivedNotification);

      if (notificationPayload.notification_action == "org_product_promotion") {
        push(
            navigatorKey.currentState.context,
            HomeScreen(
                "DetailedProducts",
                int.parse(notificationPayload.for_item_id),
                int.parse(notificationPayload.owner_user_id)));
      } else if (notificationPayload.notification_action ==
          "org_event_promotion") {
        push(
            navigatorKey.currentState.context,
            MyApp(
                "BannerEventPage", int.parse(notificationPayload.event_id), 0));
      }else{
        showToast("boom", context: navigatorKey.currentState.context);
      }
    });*/
  } else {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: Random().nextInt(1000),
          channelKey: '10000',
          title: message.data['nt'] ?? "Title",
          body: message.data['nm'] ?? "body"),
    );
  }
}

 */

class HomeScreen extends StatefulWidget {
  String where;
  int id1, id2;

  HomeScreen(this.where, this.id1, this.id2);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CleverTapPlugin _clevertapPlugin;

  PageController _tabPageController;
  int _selectedTab = 0;
  bool _isloaded = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /*
  Future<void> NotificatiosnFun() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
/*

    channel = const AndroidNotificationChannel(
      '10000', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

*/

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      fcmtoken = await FirebaseMessaging.instance.getToken();
      print("fcmtoken");
      print(fcmtoken);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message message message");

      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      print("asdf");
      print(message.data ?? "data");
      NotificationPayload notificationPayload;

      AwesomeNotifications().initialize(
          // set the icon to null if you want to use the default app icon
          'resource://mipmap/ic_launcher',
          [
            NotificationChannel(
                channelKey: '10000',
                channelName: 'High Importance Notifications',
                channelDescription:
                    'This channel is used for important notifications.',
                defaultColor: Color(0xFF00A651),
                icon: 'resource://mipmap/ic_launcher',
                ledColor: Colors.white,
                channelShowBadge: true,
                enableVibration: true,
                importance: NotificationImportance.High)
          ]);

      if ("custom" == message.data['action']) {
        setState(() {
          notificationPayload = NotificationPayload(
              message.data['wzrk_acct_id'].toString(),
              message.data['description'].toString(),
              message.data['notification_type'].toString(),
              message.data['offered'].toString(),
              message.data['action'].toString(),
              message.data['notification_id'].toString(),
              message.data['owner_organisation_name'].toString(),
              message.data['image_url'].toString(),
              message.data['owner_user_id'].toString(),
              message.data['user_id'].toString(),
              message.data['valid_date'].toString(),
              message.data['nm'].toString(),
              message.data['nt'].toString(),
              message.data['notification_user_id'].toString(),
              message.data['title'],
              message.data['offer_type'].toString(),
              message.data['event_id'].toString(),
              message.data['pushNotificationAction'].toString(),
              message.data['notification_action'].toString(),
              message.data['owner_image_url'].toString(),
              message.data['wzrk_pivot'].toString(),
              message.data['wzrk_cid'].toString(),
              message.data['wzrk_pid'].toString(),
              message.data['wzrk_rnv'].toString(),
              message.data['wzrk_ttl'].toString(),
              message.data['for_item_id'].toString(),
              message.data['wzrk_push_amp'].toString(),
              message.data['wzrk_dt'].toString(),
              message.data['wzrk_id'].toString(),
              message.data['wzrk_pn'].toString());
        });

        if (message.data['notification_action'] == "org_event_promotion") {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: Random().nextInt(1000),
                channelKey: '10000',
                title: parseHtmlString(message.data['description'] ?? "title"),
                body: 'Event that may interest you!',
                largeIcon: message.data['owner_image_url'] ?? "",
                hideLargeIconOnExpand: true,
                bigPicture: message.data['image_url'] ?? "",
                notificationLayout: NotificationLayout.BigPicture,
              ),
              actionButtons: [
                NotificationActionButton(
                  key: "see",
                  label: "SEE DETAILS",
                )
              ]);
        } else if (message.data['notification_action'] ==
            "org_product_promotion") {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: Random().nextInt(1000),
                channelKey: '10000',
                title: parseHtmlString(
                    message.data['owner_organisation_name'] ?? "title"),
                body: 'has invited you to see their product' +
                    " " +
                    parseHtmlString(message.data['description'] ?? ""),
                largeIcon: message.data['owner_image_url'] ?? "",
                hideLargeIconOnExpand: true,
                bigPicture: message.data['image_url'] ?? "",
                notificationLayout: NotificationLayout.BigPicture,
              ),
              actionButtons: [
                NotificationActionButton(
                  key: "see",
                  label: "SEE DETAILS",
                ),
              ]);
        } else {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: Random().nextInt(1000),
                  channelKey: '10000',
                  title: "title",
                  body: "body"),
              actionButtons: [
                NotificationActionButton(
                  key: "see",
                  label: "SEE DETAILS",
                )
              ]);
        }

        AwesomeNotifications().actionStream.listen((receivedNotification) {
          print("******* foreground");
          print(receivedNotification);

          print("*******asdfg");
          print(receivedNotification.actionLifeCycle);
          // if "actionLifeCycle": "AppKilled" then nothing else if "Foreground" then check for event

          if (receivedNotification.actionLifeCycle ==
              NotificationLifeCycle.Foreground) {
            if (notificationPayload.notification_action ==
                "org_product_promotion") {
              push(
                  context,
                  DetailedProducts(int.parse(notificationPayload.for_item_id),
                      int.parse(notificationPayload.owner_user_id)));
            } else if (notificationPayload.notification_action ==
                "org_event_promotion") {
              push(context,
                  BannerEventPage(int.parse(notificationPayload.event_id)));
            }
          }
        });
      } else {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(1000),
              channelKey: '10000',
              title: message.data['nt'] ?? "Title",
              body: message.data['nm'] ?? "body"),
        );
      }

      /*     flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'ic_launcher',
            ),
          ));*/
    });

    CleverTapPlugin.setDebugLevel(3);
    print("*********1");
    /*CleverTapPlugin.createNotificationChannel(
        "fluttertest", "Flutter Test", "Flutter Test", 10000, true);*/
    CleverTapPlugin.initializeInbox();
    CleverTapPlugin.registerForPush(); //only for iOS
    ///var initialUrl = CleverTapPlugin.getInitialUrl();
    CleverTapPlugin.setPushToken(fcmtoken);

    var stuff = ["bags", "shoes"];
    var profile = {
      'Name': 'Sohel',
      'Identity': '+919022695314',
      'DOB': '22-04-1990',

      ///Key always has to be "DOB" and format should always be dd-MM-yyyy
      'Email': 'sohel@marvel.com',
      'Phone': '+919022695314',
      'props': 'property11',
      'stuff': stuff
    };
    CleverTapPlugin.profileSet(profile);
    print("Pushed profile " + profile.toString());
  }

   */

  Future<void> initTask() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      languageCode = prefs.getString(LAGUAGE_CODE) ?? "en";
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .GetProfileData()
        .then((value) {
      setState(() {
        if (value == "error") {
          //for unexpected error
          // errorMessage = "Error in fetching data";
          //logout user
          LogOut();
        } else if (value == "success") {
          _isloaded = true;

          Provider.of<CustomViewModel>(context, listen: false).AppStart();
          Provider.of<CustomViewModel>(context, listen: false)
              .GetAdsForHomeSlider();

          Provider.of<CustomViewModel>(context, listen: false).GetCategories();
          Provider.of<CustomViewModel>(context, listen: false).GetAds();
          Provider.of<CustomViewModel>(context, listen: false).GetProducts();
          Provider.of<CustomViewModel>(context, listen: false)
              .GetFeaturedProducts();
          Provider.of<CustomViewModel>(context, listen: false).GetCompanies();
          Provider.of<CustomViewModel>(context, listen: false)
              .GetFeaturedCompanies();

          Provider.of<CustomViewModel>(context, listen: false).GetEvents();
          Provider.of<CustomViewModel>(context, listen: false)
              .GetFeaturedEvents();

          /* Provider.of<CustomViewModel>(context, listen: false).GetOffers();
          Provider.of<CustomViewModel>(context, listen: false).GetDemos();
          Provider.of<CustomViewModel>(context, listen: false)
              .GetLatestLaunch();*/
          Provider.of<CustomViewModel>(context, listen: false)
              .GetNotifications();

          this.initDynamicLinks();
          if (widget.where != "HomeScreen") {
            //TODO: custom notificatiosn
//            push(
//                context,
//                widget.where == "DetailedProducts"
//                    ? DetailedProducts(widget.id1, widget.id2)
//                    : widget.where == "BannerEventPage"
//                        ? BannerEventPage(widget.id1)
//                        : NotificationScreen());
          }
        } else {
          // errorMessage = value;
          LogOut();
        }
      });
    });
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    print("*****************");
    if (deepLink != null) {
      print(deepLink.toString());
      print(deepLink.queryParameters['event_id']);
//      push(
//          context,
//          BannerEventPage(
//              int.parse(deepLink.queryParameters['event_id'].toString())));
    }
  }

  Future LogOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    pushReplacement(context, InitialScreen("HomeScreen", 0, 0));
  }

  @override
  void initState() {
    _tabPageController = PageController();
    super.initState();
    //NotificatiosnFun();
    initTask();
  }

  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      buildContext = context;
    });
    SizeConfig().init(context);
    final providerListener = Provider.of<CustomViewModel>(context);

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

    return _isloaded == true
        ? Scaffold(
            key: _scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(200)),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color(0xFF00A651).withOpacity(0.3),
                      offset: Offset(0, -10),
                      spreadRadius: 4,
                      blurRadius: 10)
                ]),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.menu_rounded,
                              size: 36,
                            ),
                            color: Color(0xFF00A651),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                          ),
                          SizedBox(width: 30,),
                          SvgPicture.asset(
                            "assets/icons/greenKisan_Logo.svg",
                            height: getProportionateScreenHeight(47),
                          ),
                        ],
                      ),
                      /*IconButton(
                        padding: EdgeInsets.zero,
                        icon: SvgPicture.asset(
                          "assets/icons/searchIcon.svg",
                          width: getProportionateScreenWidth(25),
                        ),
                        color: Color(0xFF00A651),
                        onPressed: () {
                          //push(context, SearchScreen());
                        },
                      ),*/
                      Container(
                        width: 600,
                        height: 54,
                        child: TextField(
                          onTap: () {
                            push(context, SearchScreen());
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              contentPadding: EdgeInsets.zero,
                              hintText: "Search a product or company",
                              focusColor: Color(0xFF00A651),
                              filled: true,
                              fillColor: Color(0xFFF8F8F8),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF00A651), width: 1.5),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF00A651), width: 1.5),
                                  borderRadius: BorderRadius.circular(15)),
                              suffixIcon: Icon(
                                Icons.search,
                                color: Color(0xFF9B9B9B),
                              ),
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.3),
                                  fontSize: getProportionateScreenHeight(18), fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Stack(
                        children: [
                          Center(
                            child: IconButton(
                              onPressed: () {
                                //push(context, NotificationScreen());
                              },
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.notifications,
                                color: Color(0xFF00A651),
                                size: 36,
                              ),
                              color: Colors.black,
                            ),
                          ),
                          providerListener.notificationsList.length > 0
                              ? Positioned(
                                  top: 15,
                                  right: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      color: Colors.red,
                                    ),
                                    child: Text(
                                      providerListener.notificationsList.length
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          //push(context, Profile());
                          push(
                              context,
                              BasicProfile(
                                  providerListener.userData.first_name ?? "",
                                  providerListener.userData.last_name ?? "",
                                  providerListener.userData.email ?? "",
                                  providerListener.userprofileData.image_url ?? "",
                                  providerListener.userprofileData.state,
                                  providerListener.userprofileData.city));
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent,
                          backgroundImage: providerListener
                              .userprofileData.image_smallthumb_url.isEmpty
                              ? AssetImage('assets/icons/defaultGreenProfile.svg')
                              : NetworkImage(
                              providerListener.userprofileData.image_smallthumb_url),
                        ),
                      ),
                      /*IconButton(
                        padding: EdgeInsets.zero,
                        icon: providerListener
                            .userprofileData.image_smallthumb_url.isEmpty
                            ? AssetImage('assets/icons/defaultGreenProfile.svg')
                            : NetworkImage(
                            providerListener.userprofileData.image_smallthumb_url),
                        color: Color(0xFF00A651),
                        onPressed: () {
                          //push(context, SearchScreen());
                        },
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
            drawer: CustomDrawer(context),
            /*bottomNavigationBar: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BottomTabs(
                  selectedTab: _selectedTab,
                  tabPressed: (num) {
                    _tabPageController.animateToPage(num,
                        duration: Duration(milliseconds: ANIMATION_DURATION),
                        curve: Curves.easeOutCubic);
                  },
                ),
              ),
            ),*/
            body: WillPopScope(
              onWillPop: () => showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text(getTranslated(context, 'are_you_sure')),
                  content: new Text('Do you want to exit the App'),
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(getTranslated(context, 'no')),
                      ),
                    ),
                    SizedBox(height: 16),
                    new GestureDetector(
                      onTap: () => exit(0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(getTranslated(context, 'yes_confirm')),
                      ),
                    ),
                  ],
                ),
              ),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _tabPageController,
                        onPageChanged: (num) {
                          setState(() {
                            _selectedTab = num;
                          });
                        },
                        children: [
                          HomeTab(),
                          Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Webinar Coming soon',
                                  textAlign: TextAlign.center,
                                )),
                          ),
                          ShortListedTab(),
                          CallHistory(),
                          /*Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Coming soon',
                                  textAlign: TextAlign.center,
                                )),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
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

  Widget CustomDrawer(BuildContext context) {
    return Drawer(
      child: Container(
          color: Color(COLOR_BACKGROUND),
          /*padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(30),
              vertical: getProportionateScreenHeight(50)),*/
          child: Column(
            children: [
              SizedBox(height: 40,),
              DrawerHeader(context),
              /*Container(
                height: getProportionateScreenHeight(500),
                child:
                ListView.builder(
                  itemCount: drawerItems.length,
                  itemBuilder: (context, index) {
                    return DrawerItem(
                      icon: drawerItems[index]['icon'],
                      text: drawerItems[index]['text'],
                      onPressed: drawerItems[index]['onPressed'],
                    );
                  },
                ),
              ),*/
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              DrawerSvgItem(
                icon: "assets/icons/home.svg",
                text: getTranslated(context, 'home'),
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
              ),
              DrawerSvgItem(
                icon: "assets/icons/webinarOptIcon.svg",
                text: "Webinar",
                onPressed: () {
                  /*pop(context);
                  push(context, LanguageScreen(2));*/
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
              ),
              DrawerSvgItem(
                icon: "assets/icons/shortlisticon.svg",
                text: "Wishlist",
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
              ),
              DrawerSvgItem(
                icon: "assets/icons/callHistoryIcon.svg",
                text: "History",
                onPressed: () {},
              ),
              Container(height: 1.5,color: Colors.white.withOpacity(0.5),),
              DrawerItem(
                icon: Icons.calendar_today_rounded,
                text: getTranslated(context, 'my_webinars'),
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
              ),
              DrawerSvgItem(
                icon: "assets/icons/WhiteSubscribeIcon.svg",
                text: "My Pass",
                onPressed: () {},
              ),
              Container(height: 1.5,color: Colors.white.withOpacity(0.5),),
              /*DrawerItem(
                icon: Icons.language,
                text: getTranslated(context, 'language'),
                onPressed: () {
                  pop(context);
                  push(context, LanguageScreen(2));
                },
              ),*/
              DrawerItem(
                icon: Icons.settings,
                text: "Settings",
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
              ),
              DrawerItem(
                icon: Icons.share,
                text: getTranslated(context, 'invite_friends'),
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
              ),
              DrawerItem(
                icon: Icons.help,
                text: "FAQ & Support",
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
              ),
              /*DrawerItem(
                icon: Icons.info,
                text: getTranslated(context, 'about_app'),
                onPressed: () {},
              ),*/
              DrawerItem(
                icon: Icons.description_rounded,
                text: getTranslated(context, 'termandprivacypolicy'),
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
              ),
              DrawerItem(
                icon: Icons.logout,
                text: "Logout",
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  pushReplacement(context, InitialScreen("HomeScreen", 0, 0));
                },
              ),
            ],
          )),
    );
  }

  Widget DrawerHeader(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    return Container(
      child: Column(
        children: [
          /*Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: providerListener
                        .userprofileData.image_smallthumb_url.isEmpty
                    ? AssetImage('assets/images/defaultProfile.png')
                    : NetworkImage(
                        providerListener.userprofileData.image_smallthumb_url),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 155,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (providerListener.userData.first_name ?? "") +
                          " " +
                          (providerListener.userData.last_name ?? ""),
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                          fontSize: getProportionateScreenHeight(18),
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                        "${providerListener.userprofileData.mobile1 ?? ""} | "
                        "${providerListener.userprofileData.city ?? ""}, "
                        "${providerListener.userprofileData.state ?? ""}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenHeight(11),
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  push(
                      context,
                      BasicProfile(
                          providerListener.userData.first_name ?? "",
                          providerListener.userData.last_name ?? "",
                          providerListener.userData.email ?? "",
                          providerListener.userprofileData.image_url ?? "",
                          providerListener.userprofileData.state,
                          providerListener.userprofileData.city));
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              )
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),*/
          providerListener.membershipInfo != null
              ? providerListener.membershipInfo.status != "active"
                  ? InkWell(
                      onTap: () {
                        push(context, SubscribeToMembership());
                      },
                      child: Container(
                        width: 282,
                        height: 115,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10)
                          ],
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/tileOrange1.png",
                              ),
                              fit: BoxFit.cover),
                          color: Colors.transparent,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: getProportionateScreenWidth(20),
                              child: Opacity(
                                opacity: 0.2,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Image.asset("assets/images/days.png",
                                        height:
                                            getProportionateScreenHeight(104))),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17,
                                  vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated(context, 'become_a_member'),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 2),
                                          child: Text(
                                              getTranslated(context,
                                                  'become_a_member_descripton'),
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.deepOrange,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        //push(context, SubscribeToMembership());
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
                      },
                      child: Container(
                        width: 282,
                        height: 115,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/tileGreen1.png",
                                ),
                                fit: BoxFit.cover),
                            color: Colors.transparent,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 10)
                            ]),
                        child: Stack(
                          children: [
                            Positioned(
                              right: getProportionateScreenWidth(20),
                              child: Opacity(
                                opacity: 0.2,
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      "assets/images/days.png",
                                      height: getProportionateScreenHeight(104),
                                    )),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 17,
                                  vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated(context, 'IamKisan'),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 2),
                                          child: languageCode == "en"
                                              ? Text(
                                                  getTranslated(context, 'membership_valid_till') +
                                                      " " +
                                                      DateFormat.MMMd()
                                                          .format(DateTime.parse(providerListener
                                                                  .membershipInfo
                                                                  .expires_at ??
                                                              ""))
                                                          .toString() +
                                                      ", " +
                                                      DateTime.parse(providerListener.membershipInfo.expires_at ?? "")
                                                          .year
                                                          .toString() +
                                                      "\n" +
                                                      getTranslated(
                                                          context, 'auto_renwe_a_day_before'),
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w400,
                                                  ))
                                              : Text(
                                                  DateFormat.MMMd()
                                                          .format(DateTime.parse(providerListener
                                                                  .membershipInfo
                                                                  .expires_at ??
                                                              ""))
                                                          .toString() +
                                                      ", " +
                                                      DateTime.parse(providerListener.membershipInfo.expires_at ?? "")
                                                          .year
                                                          .toString() +
                                                      " " +
                                                      getTranslated(context, 'membership_valid_till') +
                                                      "\n" +
                                                      getTranslated(context, 'auto_renwe_a_day_before'),
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "More info >",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    12)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
              : SizedBox(
                  height: 1,
                ),
        ],
      ),
    );
  }
}

class DrawerSvgItem extends StatelessWidget {
  const DrawerSvgItem({
    Key key,
    this.icon,
    this.text,
    this.onPressed,
  }) : super(key: key);

  final String text,icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: ListTile(
            visualDensity: VisualDensity(vertical: -1, horizontal: 0),
            title: Row(
              children: <Widget>[
                SvgPicture.asset(icon,color: Colors.white,height: getProportionateScreenHeight(25),),
                SizedBox(width: getProportionateScreenWidth(10),),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenHeight(15),
                      fontFamily: 'Poppins Medium'),
                )
              ],
            )),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key key,
    this.icon,
    this.text,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: ListTile(
            visualDensity: VisualDensity(vertical: -1, horizontal: 0),
            title: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: getProportionateScreenHeight(25),
                ),
                SizedBox(width: getProportionateScreenWidth(10),),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenHeight(15),
                      fontFamily: 'Poppins Medium'),
                )
              ],
            )),
      ),
    );
  }
}
