import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:kisanweb/Models/CallHistoryUserObj.dart';
import 'package:kisanweb/Models/CompanyCallObj.dart';
import 'package:kisanweb/Models/ProductCallObj.dart';
import 'package:kisanweb/Models/UserDataParser.dart';
import 'package:kisanweb/Models/UserProfileParser.dart';
import 'package:kisanweb/Models/AdsListParser.dart';
import 'package:kisanweb/Models/AdsObject.dart';
import 'package:kisanweb/Models/ProductListParser.dart';
import 'package:kisanweb/Models/CompaniesListParser.dart';
import 'package:kisanweb/Models/OfferListParser.dart';
import 'package:kisanweb/Models/DemoListParser.dart';
import 'package:kisanweb/Models/WebinarDetails.dart';
import 'package:kisanweb/Models/LaunchListParser.dart';
import 'package:kisanweb/Models/CategoryListParser.dart';
import 'package:kisanweb/Models/FilterCategoryListParser.dart';
import 'package:kisanweb/Models/FilterLanguageListParser.dart';
import 'package:kisanweb/Models/SubCategoryListParser.dart';
import 'package:kisanweb/Models/DetailedProuctParser.dart';
import 'package:kisanweb/Models/DetailedAssetsParser.dart';
import 'package:kisanweb/Models/DetailedBrouchersParser.dart';
import 'package:kisanweb/Models/DetailedCompanyParser.dart';
import 'package:kisanweb/Models/NotificationsListParser.dart';
import 'package:kisanweb/Models/RepresentativeListParser.dart';
import 'package:kisanweb/Models/KissanNetObj.dart';
import 'package:kisanweb/Models/MemberShipPlansListParser.dart';
import 'package:kisanweb/Models/SubscriptionInitialInfo.dart';
import 'package:kisanweb/Models/GetDetailsFromPin.dart';
import 'package:kisanweb/Models/MembershipInfo.dart';
import 'package:kisanweb/services/web_service.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kisanweb/Models/CallHistoryListParser.dart';
import 'package:kisanweb/Models/CallHistoryUserObj.dart';
import 'package:kisanweb/Models/EventDetails.dart';
import 'package:kisanweb/Models/WebinarListParser.dart';

class CustomViewModel extends ChangeNotifier {
  //GoogleLogin data to forward in progile
  String googleEmail;
  String googleFName;
  String googleLName;
  String googleImageUrl;
  int unread_notification_count = 0;
  String profile_url;

  String tempEmail;
  String tempFName;
  String tempLName;
  String tempProfileLink;

  bool canLoadMoreWebinar = true;
  bool canLoadMoreMyWebinar = true;
  bool canLoadMoreProducts = true;
  bool canLoadMoreCompanies = true;
  bool canLoadMoreCalls = true;

  Future setGoogleData(
      String email, String displayname, String photoUrl) async {
    googleEmail = email;
    googleFName = displayname.split(" ").first; // will be matched 1 times.
    googleLName = displayname.split(" ").last;
    googleImageUrl = photoUrl;
    notifyListeners();
  }

  //toke, user data and profile urls
  var verification_token = null;
  UserDataParser userData;
  UserProfileParser userprofileData;
  GetDetailsFromPin getDetailsFromPin;
  String image_url, image_bigthumb_url, image_smallthumb_url;

  //homescreen
  List<AdsListParser> homeAdsList = [];
  List<String> homeAdsListImages = [];
  List<AdsListParser> categoryAdsList = [];
  List<String> categoryAdsListImages = [];

  AdsObject topAd = null;
  AdsObject middleAd = null;
  AdsObject bottomAd = null;

  List<ProductListParser> productsList = [];
  List<ProductListParser> featuredproductsList = [];
  List<OfferListParser> offersList = [];
  List<DemoListParser> demosList = [];
  List<LaunchListParser> launchList = [];
  List<WebinarListParser> eventList = [];
  List<WebinarListParser> MyWebinarList = [];
  String WebinarCounts="0";

  List<WebinarListParser> featuredeventList = [];
  List<CategoryListParser> categoryList = [];
  List<CompaniesListParser> companiesList = [];
  List<CompaniesListParser> featuredcompaniesList = [];

  //products found screen
  List<ProductListParser> productsListbycatidsandsearchstring =
  []; //this list is also used in search screen

  ProductListParser productsCouts;

  //Search Screen
  List<CompaniesListParser> companiessListbycatidsandsearchstring = [];

  List<OfferListParser> offersListbysearchstring = [];
  int searchProductCounts = 0;
  int searchCompaniesCounts = 0;

  Future setUnReadNotCount() async {
    print("setUnReadNotCount2");
    this.unread_notification_count = 0;
    notifyListeners();
    return "success";
  }

  //category page
  List<SubCategoryListParser> subcategoryList = [];
  SubCategoryListParser subcategoryCouts; // comapnies and products ounts

  List<SubCategoryListParser> searchedSubCategoryList = [];

  //notifications
  List<NotificationsListParser> notificationsList = [];

//  String notificationsCounts = "";

  //products details screen
  DetailedProuctParser productsDetails;
  List<DetailedAssetsParser> productsDetailsAssets = [];
  List<String> productsDetailsAssetsUrl = []; //for slider
  List<DetailedBrouchersParser> productsDetailsBrouchers = [];
  List<ProductListParser> productsListFromSameCompany = [];
  List<ProductListParser> productsListofSimilar = [];

  //products details screen
  DetailedCompanyParser companyDetails;
  List<DetailedAssetsParser> companyDetailsAssets = [];
  String BrandBannerbigthumb_url, BrandBannermedia_type, BrandBannermedia_url;
  List<DetailedAssetsParser> companyDetailsVideos =
  []; // we can use DetailedAssetsParser Model for this
  List<String> companyDetailsAssetsUrl = []; //for slider
  List<DetailedBrouchersParser> companyDetailsBrouchers = [];
  List<ProductListParser> companyDetailsProductsList = [];

  //representativeList
  List<RepresentativeListParser> representativeList = [];

  //shortlisted screen
  List<ProductListParser> favproductsList = [];
  List<OfferListParser> favoffersList = [];
  List<CompaniesListParser> favcompaniesList = [];

  //Call History Tab
  List<CallHistoryListParser> callHistoryList = [];
  List<CallHistoryUserObj> callHistoryUserObj = [];
  List<CompanyCallObj> companyCallObj = [];
  List<ProductCallObj> productCallObj = [];

  //KissanNetObj
  KissanNetObj kissanNetObj;

  //MemberShipPlansList
  String USE_RAZORPAY_SUBSCRIPTIONS = "0";
  List<MemberShipPlansListParser> membershipplansList = [];
  MembershipInfo membershipInfo;

  //Subscription
  SubscriptionInitialInfo subscriptionInitialInfo;

  //GreenPasses
  String order_id, order_id_webinar;

  //EventDetails and its webinars, categories
  EventDetails eventDetails;
  List<WebinarListParser> webinarList = [];
  List<CategoryListParser> pavilionsList = [];
  List<dynamic> subcategories = [];
  List<String> pavilion_id_list = [];
  List<String> subcategory_ids_list = [];
  int category_count = 0;
  int subcategory_count = 0;

  //WebinarDetails webinarDetails;
  WebinarDetails webinarDetails;

  //View all webinars and its filiters
  List<WebinarListParser> webinarListViewAll = [];
  List<FilterCategoryListParser> filterCategoryList = [];
  List<FilterLanguageListParser> filterLanguageList = [];
  List<String> recencyLang = [];

  //shuffle featuredProduct indexes
  int shuffled_index1FP = 0;
  int shuffled_index2FP = 0;
  int max_idFP = 0;

  //shuffle featuredCompanies indexes
  int shuffled_index1FC = 0;
  int shuffled_index2FC = 0;
  int max_idFC = 0;

  //shuffle Product indexes
  int shuffled_index1P = 0;
  int shuffled_index2P = 0;
  int max_idP = 0;

  //shuffle Companies indexes
  int shuffled_index1C = 0;
  int shuffled_index2C = 0;
  int max_idC = 0;

  Future sendOTP(String phoneNumber, bool _isChecked) async {
    final response = await WebService().sendOTP(phoneNumber, _isChecked);

    var responseDecoded = jsonDecode(response.body);
    var responseDecodedSuccess = responseDecoded['success'];
    var responseDecodedMsg = responseDecoded['message'].toString();

    if (responseDecodedSuccess == "false") {
      notifyListeners();
      return responseDecodedMsg;
    } else if (responseDecodedSuccess == "true") {
      verification_token = responseDecoded['data']['token'].toString();
      notifyListeners();
      return responseDecodedMsg;
    } else {
      notifyListeners();
      return "error";
    }
  }

  Future resendOTP(String phoneNo, String mode, String OPT_IN_OUT) async {
    final response = await WebService().resendOTP(phoneNo, mode, OPT_IN_OUT);

    var responseDecoded = jsonDecode(response.body);
    var responseDecodedSuccess = responseDecoded['success'];
    var responseDecodedMsg = responseDecoded['message'].toString();

    if (responseDecodedSuccess == "false") {
      notifyListeners();
      return responseDecodedMsg;
    } else if (responseDecodedSuccess == "true") {
      verification_token = responseDecoded['data']['token'].toString();
      notifyListeners();
      return responseDecodedMsg;
    } else {
      notifyListeners();
      return "error";
    }
  }

  Future verifyOTP(String verification_code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response =
    await WebService().verifyOTP(verification_token, verification_code);

    var responseDecoded = jsonDecode(response.body);
    var responseDecodedSuccess = responseDecoded['success'];
    var responseDecodedMsg = responseDecoded['message'].toString();

    if (responseDecodedSuccess == "false") {
      notifyListeners();
      return responseDecodedMsg;
    } else if (responseDecodedSuccess == "true") {
      print("response" + responseDecodedMsg.toString());
      if (responseDecodedMsg == "This is signup.") {
        prefs.setString("token", responseDecoded['registration_token']);
      } else {
        prefs.setString("token", responseDecoded['token']);
      }

      notifyListeners();
      return responseDecodedMsg;
    } else {
      notifyListeners();
      return "error";
    }
  }

  Future verifyOTPAfterGoogleAUth(String verification_code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("*********ishere");
    final response =
    await WebService().verifyOTP(verification_token, verification_code);

    var responseDecoded = jsonDecode(response.body);
    var responseDecodedSuccess = responseDecoded['success'];
    var responseDecodedMsg = responseDecoded['message'].toString();

    if (responseDecodedSuccess == "false") {
      notifyListeners();
      return responseDecodedMsg;
    } else if (responseDecodedSuccess == "true") {
      print("response" + responseDecodedMsg.toString());

      if (responseDecodedMsg == "This is signup.") {
        prefs.setString("token", responseDecoded['registration_token']);
        notifyListeners();
        return "This is signup.";
      } else {
        prefs.setString("token", responseDecoded['token']);

        if (responseDecoded['user']['email'] != null &&
            responseDecoded['user']['email'] != "") {
          tempEmail = responseDecoded['user']['email'];
          tempFName = responseDecoded['user']['first_name'];
          tempLName = responseDecoded['user']['last_name'];
          tempProfileLink =
          responseDecoded['user']['user_profile']['image_smallthumb_url'];

          notifyListeners();
          print("email is present");
          return "email is present";
        } else {
          UpdateProfileDataAfterGoogleAuth(googleFName, googleLName, "otp",
              googleEmail, "google", true, googleImageUrl);
          notifyListeners();
          return "User authenticated successfully.";
        }
      }
    } else {
      notifyListeners();
      return "error";
    }
  }

  Future GetProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await WebService().GetProfileData();

    if (response != "error") {
      print("GetProfileData");
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      userData = new UserDataParser(
        responseDecoded['email'].toString(),
        responseDecoded['username'].toString(),
        responseDecoded['first_name'].toString(),
        responseDecoded['last_name'].toString(),
      );
      userprofileData = new UserProfileParser(
          responseDecoded['user_profile']['about'],
          responseDecoded['user_profile']['account_type'],
          responseDecoded['user_profile']['address1'],
          responseDecoded['user_profile']['address2'],
          responseDecoded['user_profile']['address3'],
          responseDecoded['user_profile']['city'],
          responseDecoded['user_profile']['state'],
          responseDecoded['user_profile']['pin'],
          responseDecoded['user_profile']['country'],
          responseDecoded['user_profile']['mobile1'],
          responseDecoded['user_profile']['email'],
          responseDecoded['user_profile']['has_paid'],
          responseDecoded['user_profile']['longitude'],
          responseDecoded['user_profile']['latitude'],
          responseDecoded['user_profile']['designation'],
          responseDecoded['user_profile']['occupation'],
          responseDecoded['user_profile']['occupation_other'],
          responseDecoded['user_profile']['gender'],
          responseDecoded['user_profile']['avatar'],
          responseDecoded['user_profile']['image_url'],
          responseDecoded['user_profile']['image_bigthumb_url'],
          responseDecoded['user_profile']['image_smallthumb_url'],
          responseDecoded['user_profile']['registration_type'],
          responseDecoded['user_profile']['is_email_verified'],
          responseDecoded['user_profile']['is_mobile_verified'],
          responseDecoded['user_profile']['sso_id'],
          responseDecoded['user_profile']['tehsil'],
          responseDecoded['user_profile']['is_dnd'],
          responseDecoded['user_profile']['whatsapp_opt_in_status'],
          responseDecoded['user_profile']['user']);

      profile_url = responseDecoded['user_profile']['image_smallthumb_url'];
      print("profile_url");
      print(profile_url);
      prefs.setString("first_name", responseDecoded['first_name']);
      prefs.setString("last_name", responseDecoded['last_name']);
      prefs.setString("email", responseDecoded['email']);
      prefs.setString("mobile", responseDecoded['user_profile']['mobile1']);
      prefs.setString("optin",
          responseDecoded['user_profile']['whatsapp_opt_in_status'].toString());

      notifyListeners();
      return "success";
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future ImageUpload(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await WebService().ImageUpload(image);
    if (response != "error") {
      //if condition, to refresh profiledata on email upload only if user logged in
      notifyListeners();
      return "success";
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future Register(
      String first_name,
      String last_name,
      String city,
      String state,
      String longitude,
      String latitude,
      String login_type,
      String email,
      String email_source,
      bool mark_email_verified,
      String reg_type) async {
    final response = await WebService().Register(
        first_name,
        last_name,
        city,
        state,
        longitude,
        latitude,
        login_type,
        email,
        email_source,
        mark_email_verified,
        reg_type);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", responseDecoded['token']);

        userData = new UserDataParser(
          responseDecoded['user']['email'].toString(),
          responseDecoded['user']['username'].toString(),
          responseDecoded['user']['first_name'].toString(),
          responseDecoded['user']['last_name'].toString(),
        );
        userprofileData = new UserProfileParser(
            responseDecoded['user']['user_profile']['about'],
            responseDecoded['user']['user_profile']['account_type'],
            responseDecoded['user']['user_profile']['address1'],
            responseDecoded['user']['user_profile']['address2'],
            responseDecoded['user']['user_profile']['address3'],
            responseDecoded['user']['user_profile']['city'],
            responseDecoded['user']['user_profile']['state'],
            responseDecoded['user']['user_profile']['pin'],
            responseDecoded['user']['user_profile']['country'],
            responseDecoded['user']['user_profile']['mobile1'],
            responseDecoded['user']['user_profile']['email'],
            responseDecoded['user']['user_profile']['has_paid'],
            responseDecoded['user']['user_profile']['longitude'],
            responseDecoded['user']['user_profile']['latitude'],
            responseDecoded['user']['user_profile']['designation'],
            responseDecoded['user']['user_profile']['occupation'],
            responseDecoded['user']['user_profile']['occupation_other'],
            responseDecoded['user']['user_profile']['gender'],
            responseDecoded['user']['user_profile']['avatar'],
            responseDecoded['user']['user_profile']['image_url'],
            responseDecoded['user']['user_profile']['image_bigthumb_url'],
            responseDecoded['user']['user_profile']['image_smallthumb_url'],
            responseDecoded['user']['user_profile']['registration_type'],
            responseDecoded['user']['user_profile']['is_email_verified'],
            responseDecoded['user']['user_profile']['is_mobile_verified'],
            responseDecoded['user']['user_profile']['sso_id'],
            responseDecoded['user']['user_profile']['tehsil'],
            responseDecoded['user']['user_profile']['is_dnd'],
            responseDecoded['user']['user_profile']['whatsapp_opt_in_status'],
            responseDecoded['user']['user_profile']['user']);
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future RegisterGoogle(
      String first_name,
      String last_name,
      String city,
      String state,
      String longitude,
      String latitude,
      String login_type,
      String image_url,
      String email,
      String email_source,
      bool mark_email_verified,
      String reg_type) async {
    final response = await WebService().RegisterGoogle(
        first_name,
        last_name,
        city,
        state,
        longitude,
        latitude,
        login_type,
        image_url,
        email,
        email_source,
        mark_email_verified,
        reg_type);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", responseDecoded['token']);

        userData = new UserDataParser(
          responseDecoded['user']['email'].toString(),
          responseDecoded['user']['username'].toString(),
          responseDecoded['user']['first_name'].toString(),
          responseDecoded['user']['last_name'].toString(),
        );
        userprofileData = new UserProfileParser(
            responseDecoded['user']['user_profile']['about'],
            responseDecoded['user']['user_profile']['account_type'],
            responseDecoded['user']['user_profile']['address1'],
            responseDecoded['user']['user_profile']['address2'],
            responseDecoded['user']['user_profile']['address3'],
            responseDecoded['user']['user_profile']['city'],
            responseDecoded['user']['user_profile']['state'],
            responseDecoded['user']['user_profile']['pin'],
            responseDecoded['user']['user_profile']['country'],
            responseDecoded['user']['user_profile']['mobile1'],
            responseDecoded['user']['user_profile']['email'],
            responseDecoded['user']['user_profile']['has_paid'],
            responseDecoded['user']['user_profile']['longitude'],
            responseDecoded['user']['user_profile']['latitude'],
            responseDecoded['user']['user_profile']['designation'],
            responseDecoded['user']['user_profile']['occupation'],
            responseDecoded['user']['user_profile']['occupation_other'],
            responseDecoded['user']['user_profile']['gender'],
            responseDecoded['user']['user_profile']['avatar'],
            responseDecoded['user']['user_profile']['image_url'],
            responseDecoded['user']['user_profile']['image_bigthumb_url'],
            responseDecoded['user']['user_profile']['image_smallthumb_url'],
            responseDecoded['user']['user_profile']['registration_type'],
            responseDecoded['user']['user_profile']['is_email_verified'],
            responseDecoded['user']['user_profile']['is_mobile_verified'],
            responseDecoded['user']['user_profile']['sso_id'],
            responseDecoded['user']['user_profile']['tehsil'],
            responseDecoded['user']['user_profile']['is_dnd'],
            responseDecoded['user']['user_profile']['whatsapp_opt_in_status'],
            responseDecoded['user']['user_profile']['user']);
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future UpdateProfileData(
      String first_name,
      String last_name,
      String login_type,
      String email,
      String email_source,
      bool is_email_verified,
      String city,
      String state,
      String longitude,
      String latitude,
      bool isChecked) async {
    final response = await WebService().UpdateProfileData(
        first_name,
        last_name,
        login_type,
        email,
        email_source,
        is_email_verified,
        city,
        state,
        longitude,
        latitude,
        isChecked);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        userData = new UserDataParser(
          responseDecoded['data']['email'].toString(),
          responseDecoded['data']['username'].toString(),
          responseDecoded['data']['first_name'].toString(),
          responseDecoded['data']['last_name'].toString(),
        );
        userprofileData = new UserProfileParser(
            responseDecoded['data']['user_profile']['about'],
            responseDecoded['data']['user_profile']['account_type'],
            responseDecoded['data']['user_profile']['address1'],
            responseDecoded['data']['user_profile']['address2'],
            responseDecoded['data']['user_profile']['address3'],
            responseDecoded['data']['user_profile']['city'],
            responseDecoded['data']['user_profile']['state'],
            responseDecoded['data']['user_profile']['pin'],
            responseDecoded['data']['user_profile']['country'],
            responseDecoded['data']['user_profile']['mobile1'],
            responseDecoded['data']['user_profile']['email'],
            responseDecoded['data']['user_profile']['has_paid'],
            responseDecoded['data']['user_profile']['longitude'],
            responseDecoded['data']['user_profile']['latitude'],
            responseDecoded['data']['user_profile']['designation'],
            responseDecoded['data']['user_profile']['occupation'],
            responseDecoded['data']['user_profile']['occupation_other'],
            responseDecoded['data']['user_profile']['gender'],
            responseDecoded['data']['user_profile']['avatar'],
            responseDecoded['data']['user_profile']['image_url'],
            responseDecoded['data']['user_profile']['image_bigthumb_url'],
            responseDecoded['data']['user_profile']['image_smallthumb_url'],
            responseDecoded['data']['user_profile']['registration_type'],
            responseDecoded['data']['user_profile']['is_email_verified'],
            responseDecoded['data']['user_profile']['is_mobile_verified'],
            responseDecoded['data']['user_profile']['sso_id'],
            responseDecoded['data']['user_profile']['tehsil'],
            responseDecoded['data']['user_profile']['is_dnd'],
            responseDecoded['data']['user_profile']['whatsapp_opt_in_status'],
            responseDecoded['data']['user_profile']['user']);
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future UpdateProfileDataAfterGoogleAuth(
      String first_name,
      String last_name,
      String login_type,
      String email,
      String email_source,
      bool is_email_verified,
      String image_url) async {
    final response = await WebService().UpdateProfileDataAfterGoogleAuth(
        first_name,
        last_name,
        login_type,
        email,
        email_source,
        is_email_verified,
        image_url);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        userData = new UserDataParser(
          responseDecoded['data']['email'].toString(),
          responseDecoded['data']['username'].toString(),
          responseDecoded['data']['first_name'].toString(),
          responseDecoded['data']['last_name'].toString(),
        );
        userprofileData = new UserProfileParser(
            responseDecoded['data']['user_profile']['about'],
            responseDecoded['data']['user_profile']['account_type'],
            responseDecoded['data']['user_profile']['address1'],
            responseDecoded['data']['user_profile']['address2'],
            responseDecoded['data']['user_profile']['address3'],
            responseDecoded['data']['user_profile']['city'],
            responseDecoded['data']['user_profile']['state'],
            responseDecoded['data']['user_profile']['pin'],
            responseDecoded['data']['user_profile']['country'],
            responseDecoded['data']['user_profile']['mobile1'],
            responseDecoded['data']['user_profile']['email'],
            responseDecoded['data']['user_profile']['has_paid'],
            responseDecoded['data']['user_profile']['longitude'],
            responseDecoded['data']['user_profile']['latitude'],
            responseDecoded['data']['user_profile']['designation'],
            responseDecoded['data']['user_profile']['occupation'],
            responseDecoded['data']['user_profile']['occupation_other'],
            responseDecoded['data']['user_profile']['gender'],
            responseDecoded['data']['user_profile']['avatar'],
            responseDecoded['data']['user_profile']['image_url'],
            responseDecoded['data']['user_profile']['image_bigthumb_url'],
            responseDecoded['data']['user_profile']['image_smallthumb_url'],
            responseDecoded['data']['user_profile']['registration_type'],
            responseDecoded['data']['user_profile']['is_email_verified'],
            responseDecoded['data']['user_profile']['is_mobile_verified'],
            responseDecoded['data']['user_profile']['sso_id'],
            responseDecoded['data']['user_profile']['tehsil'],
            responseDecoded['data']['user_profile']['is_dnd'],
            responseDecoded['data']['user_profile']['whatsapp_opt_in_status'],
            responseDecoded['data']['user_profile']['user']);
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GoogleLogin(var google_id_token, var fcm_id) async {
    /*print("token*****");
    logLongString(google_id_token);*/

    final response = await WebService().GoogleLogin(google_id_token, fcm_id);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      print(responseDecodedMsg);
      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if ((responseDecoded['token'] ?? 0) != 0) {
        print("response" + responseDecodedMsg.toString());
        prefs.setString("token", responseDecoded['token']);

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetAds() async {
    final response = await WebService().GetAds();

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['records'];

        for (Map i in data) {
          if (AdsListParser.fromJson(i).ad_position == "top") {
            topAd = AdsObject(
              AdsListParser.fromJson(i).ad_position,
              AdsListParser.fromJson(i).ad_screen,
              AdsListParser.fromJson(i).pavilion_id,
              AdsListParser.fromJson(i).media_type,
              AdsListParser.fromJson(i).media_url,
              AdsListParser.fromJson(i).bigthumb_url,
              AdsListParser.fromJson(i).smallthumb_url,
              AdsListParser.fromJson(i).link_type,
              AdsListParser.fromJson(i).link_url,
              AdsListParser.fromJson(i).link_for,
              AdsListParser.fromJson(i).linking_id,
              AdsListParser.fromJson(i).organisation_id,
              AdsListParser.fromJson(i).pavilion_name_for_category,
            );
          } else if (AdsListParser.fromJson(i).ad_position == "middle") {
            middleAd = AdsObject(
              AdsListParser.fromJson(i).ad_position,
              AdsListParser.fromJson(i).ad_screen,
              AdsListParser.fromJson(i).pavilion_id,
              AdsListParser.fromJson(i).media_type,
              AdsListParser.fromJson(i).media_url,
              AdsListParser.fromJson(i).bigthumb_url,
              AdsListParser.fromJson(i).smallthumb_url,
              AdsListParser.fromJson(i).link_type,
              AdsListParser.fromJson(i).link_url,
              AdsListParser.fromJson(i).link_for,
              AdsListParser.fromJson(i).linking_id,
              AdsListParser.fromJson(i).organisation_id,
              AdsListParser.fromJson(i).pavilion_name_for_category,
            );
          } else {
            bottomAd = AdsObject(
              AdsListParser.fromJson(i).ad_position,
              AdsListParser.fromJson(i).ad_screen,
              AdsListParser.fromJson(i).pavilion_id,
              AdsListParser.fromJson(i).media_type,
              AdsListParser.fromJson(i).media_url,
              AdsListParser.fromJson(i).bigthumb_url,
              AdsListParser.fromJson(i).smallthumb_url,
              AdsListParser.fromJson(i).link_type,
              AdsListParser.fromJson(i).link_url,
              AdsListParser.fromJson(i).link_for,
              AdsListParser.fromJson(i).linking_id,
              AdsListParser.fromJson(i).organisation_id,
              AdsListParser.fromJson(i).pavilion_name_for_category,
            );
          }
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetAdsForHomeSlider() async {
    final response = await WebService().GetAdsForHomeSlider();

    if (response != "error") {
      this.homeAdsList.clear();
      this.homeAdsListImages.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['records'];

        for (Map i in data) {
          homeAdsList.add(AdsListParser.fromJson(i));
          homeAdsListImages.add(AdsListParser.fromJson(i).bigthumb_url);
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetAdsForCategorySlider(int event_id, int pavilion_id) async {
    final response =
    await WebService().GetAdsForCategorySlider(event_id, pavilion_id);

    if (response != "error") {
      this.categoryAdsList.clear();
      this.categoryAdsListImages.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['records'];

        for (Map i in data) {
          categoryAdsList.add(AdsListParser.fromJson(i));
          categoryAdsListImages.add(AdsListParser.fromJson(i).bigthumb_url);
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetProducts() async {
    final response = await WebService().GetProducts();

    if (response != "error") {
      this.productsList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];

        for (Map i in data) {
          productsList.add(ProductListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetFeaturedProducts() async {
    final response = await WebService()
        .GetFeaturedProducts(shuffled_index1FP, shuffled_index2FP, max_idFP);

    if (response != "error") {
      this.featuredproductsList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];
        this.featuredproductsList.clear();

        for (Map i in data) {
          featuredproductsList.add(ProductListParser.fromJson(i));
        }

        shuffled_index1FP = responseDecoded['data']['shuffled_index1'];
        shuffled_index2FP = responseDecoded['data']['shuffled_index2'];
        max_idFP = responseDecoded['data']['max_id'];

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetCompanies() async {
    final response = await WebService().GetCompanies();

    if (response != "error") {
      this.companiesList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];

        for (Map i in data) {
          companiesList.add(CompaniesListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetFeaturedCompanies() async {
    final response = await WebService()
        .GetFeaturedCompanies(shuffled_index1FC, shuffled_index2FC, max_idFC);

    if (response != "error") {
      this.featuredcompaniesList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];
        this.featuredcompaniesList.clear();

        for (Map i in data) {
          featuredcompaniesList.add(CompaniesListParser.fromJson(i));
        }

        shuffled_index1FC = responseDecoded['data']['shuffled_index1'];
        shuffled_index2FC = responseDecoded['data']['shuffled_index2'];
        max_idFC = responseDecoded['data']['max_id'];

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetOffers() async {
    final response = await WebService().GetOffers();

    if (response != "error") {
      this.offersList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          offersList.add(OfferListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetDemos() async {
    final response = await WebService().GetDemos();

    if (response != "error") {
      this.demosList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          demosList.add(DemoListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetLatestLaunch() async {
    final response = await WebService().GetLatestLaunch();

    if (response != "error") {
      this.launchList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          launchList.add(LaunchListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetEvents() async {
    final response =
    await WebService().GetEvents(userprofileData.user.toString());

    if (response != "error") {
      this.eventList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          eventList.add(WebinarListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetFeaturedEvents() async {
    final response =
    await WebService().GetFeaturedEvents(userprofileData.user.toString());

    if (response != "error") {
      this.featuredeventList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          featuredeventList.add(WebinarListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetCategories() async {
    final response = await WebService().GetCategories();

    if (response != "error") {
      this.categoryList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          categoryList.add(CategoryListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetSubCategories(int event_id, int pavilion_id) async {

    final response = await WebService().GetSubCategories(event_id, pavilion_id);

    if (response != "error") {
      this.subcategoryList.clear();
      this.searchedSubCategoryList.clear();

      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        subcategoryCouts = SubCategoryListParser.forcounts(
            responseDecoded['data']['companies'],
            responseDecoded['data']['products']);

        final data = responseDecoded['data']['list'];
        for (Map i in data) {
          subcategoryList.add(SubCategoryListParser.fromJson(i));
          searchedSubCategoryList.add(SubCategoryListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future SearchSubCategories(String text) async {
    this.searchedSubCategoryList.clear();

    for (int i = 0; i < subcategoryList.length; i++) {
      if (subcategoryList[i]
          .name
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        searchedSubCategoryList.add(subcategoryList[i]);
      }
    }

    notifyListeners();
    return "success";
  }

  //these func used in searchscreen(multiple cat) and product found(single cat id)
  Future GetProductsByCategoryIdsAndSearchString(int isfromSearch, int event_id,
      List<int> catids, String searchString, int user_id) async {
    this.canLoadMoreProducts = true;
    final response = await WebService().GetProductsByCategoryIdsAndSearchString(
        isfromSearch,
        event_id,
        catids,
        searchString,
        1,
        shuffled_index1P,
        shuffled_index2P,
        max_idP,
        user_id);

    if (response != "error") {
      this.productsListbycatidsandsearchstring.clear();
      this.searchProductCounts = 0;
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response asdf" + responseDecoded.toString());

        productsCouts = ProductListParser.forcounts(
            responseDecoded['data']['companies'],
            responseDecoded['data']['products']);

        // searchProductCounts = responseDecoded['data']['products'];

        final data = responseDecoded['data']['list'];

        for (Map i in data) {
          productsListbycatidsandsearchstring
              .add(ProductListParser.fromJson(i));
        }

        if (isfromSearch == 0) {
          shuffled_index1P = responseDecoded['data']['shuffled_index1'];
          shuffled_index2P = responseDecoded['data']['shuffled_index2'];
          max_idP = responseDecoded['data']['max_id'];
        }

        if (productsListbycatidsandsearchstring.length == 0 ||
            responseDecoded['data']['products'] <= 10) {
          this.canLoadMoreProducts = false;
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future AppendProductsForSearch(int event_id, List<int> catids,
      String searchString, int pageCount, int user_id) async {
    this.canLoadMoreProducts = true;

    print("AppendProductsForSearch2");
    final response = await WebService().GetProductsByCategoryIdsAndSearchString(
        1, event_id, catids, searchString, pageCount, 0, 0, 0, user_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("AppendProductsForSearch3");

        final data = responseDecoded['data']['list'];

        int temp = productsListbycatidsandsearchstring.length;
        for (Map i in data) {
          productsListbycatidsandsearchstring
              .add(ProductListParser.fromJson(i));
        }

        if (temp == productsListbycatidsandsearchstring.length ||
            productsListbycatidsandsearchstring.length - temp < 10) {
          this.canLoadMoreProducts = false;
          notifyListeners();
          return "No more items";
        } else {
          notifyListeners();
          return "success";
        }
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetCompaniesByCategoryIdsAndSearchString(int isfromSearch,
      int event_id, List<int> catids, String searchString, int user_id) async {
    this.canLoadMoreCompanies = true;

    final response = await WebService()
        .GetCompaniesByCategoryIdsAndSearchString(
        isfromSearch,
        event_id,
        catids,
        searchString,
        1,
        shuffled_index1C,
        shuffled_index2C,
        max_idC,
        user_id);

    if (response != "error") {
      this.companiessListbycatidsandsearchstring.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      print("*******2");
      print(responseDecodedSuccess);
      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];

        for (Map i in data) {
          companiessListbycatidsandsearchstring
              .add(CompaniesListParser.fromJson(i));
        }

        print("=========");
        print(shuffled_index1P.toString());
        print(shuffled_index1P.toString());
        print(shuffled_index1P.toString());
        print("=========");
        print(shuffled_index1C.toString());
        print(shuffled_index1C.toString());
        print(shuffled_index1C.toString());

        if (isfromSearch == 0) {
          shuffled_index1C = responseDecoded['data']['shuffled_index1'];
          shuffled_index2C = responseDecoded['data']['shuffled_index2'];
          max_idC = responseDecoded['data']['max_id'];
        }

        if (companiessListbycatidsandsearchstring.length == 0 ||
            productsCouts.companies <= 10) {
          this.canLoadMoreCompanies = false;
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future AppendCompaniesForSearch(int event_id, List<int> catids,
      String searchString, int pageCount, int user_id) async {
    this.canLoadMoreCompanies = true;

    final response = await WebService()
        .GetCompaniesByCategoryIdsAndSearchString(
        1, event_id, catids, searchString, pageCount, 0, 0, 0, user_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      print("*******2");
      print(responseDecodedSuccess);
      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];

        int temp = companiessListbycatidsandsearchstring.length;
        for (Map i in data) {
          companiessListbycatidsandsearchstring
              .add(CompaniesListParser.fromJson(i));
        }

        if (temp == companiessListbycatidsandsearchstring.length ||
            companiessListbycatidsandsearchstring.length - temp < 10) {
          this.canLoadMoreCompanies = false;
          notifyListeners();
          return "No more items";
        } else {
          notifyListeners();
          return "success";
        }
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetOffersBySearchString(String searchString) async {
    final response = await WebService().GetOffersBySearchString(searchString);

    if (response != "error") {
      this.offersListbysearchstring.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          offersListbysearchstring.add(OfferListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetDetailedOfProduct(int product_id) async {
    final response = await WebService().GetDetailedOfProduct(product_id);

    if (response != "error") {
      this.productsDetailsAssets.clear();
      this.productsDetailsAssetsUrl.clear();
      this.productsDetailsBrouchers.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        productsDetails = new DetailedProuctParser(
            responseDecoded['data']['id'],
            responseDecoded['data']['user_id'],
            responseDecoded['data']['title_english'],
            responseDecoded['data']['title_marathi'],
            responseDecoded['data']['title_hindi'],
            responseDecoded['data']['desc_english'],
            responseDecoded['data']['desc_marathi'],
            responseDecoded['data']['desc_hindi'],
            responseDecoded['data']['price'],
            responseDecoded['data']['currency'],
            responseDecoded['data']['featured'],
            responseDecoded['data']['organisation_name'],
            responseDecoded['data']['image_bigthumb_url'],
            responseDecoded['data']['media_url'],
            responseDecoded['data']['bigthumb_url'],
            responseDecoded['data']['smallthumb_url'],
            responseDecoded['data']['media_type'],
            responseDecoded['data']['liked'],
            responseDecoded['data']['product_category_id']);

        final assets = responseDecoded['data']['assets'];

        for (Map i in assets) {
          productsDetailsAssets.add(DetailedAssetsParser.fromJson(i));
          productsDetailsAssetsUrl
              .add(DetailedAssetsParser.fromJson(i).media_url);
        }

        final Brouchers = responseDecoded['data']['brouchers'];

        for (Map i in Brouchers) {
          productsDetailsBrouchers.add(DetailedBrouchersParser.fromJson(i));
        }
        if (responseDecoded['data']['product_category_id'] != null) {
          List<int> ids = [];
          ids.add(responseDecoded['data']['product_category_id']);
          GetSimilarProducts(ids, responseDecoded['data']['id']);
        }
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetProductsFromSameCompany(int company_id, skip_product_id) async {
    final response = await WebService()
        .GetProductsFromSameCompany(company_id, skip_product_id);

    if (response != "error") {
      this.productsListFromSameCompany.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];

        for (Map i in data) {
          productsListFromSameCompany.add(ProductListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetSimilarProducts(List<int> category, int skip_product_id) async {
    final response =
    await WebService().GetSimilarProducts(category, skip_product_id);

    if (response != "error") {
      this.productsListofSimilar.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];

        for (Map i in data) {
          productsListofSimilar.add(ProductListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetDetailedOfCompany(int company_id) async {
    final response = await WebService().GetDetailedOfCompany(company_id);

    if (response != "error") {
      this.companyDetailsAssets.clear();
      this.companyDetailsAssetsUrl.clear();
      this.companyDetailsBrouchers.clear();
      this.companyDetailsVideos.clear();
      this.companyDetailsProductsList.clear();

      BrandBannerbigthumb_url = null;
      BrandBannermedia_type = null;
      BrandBannermedia_url = null;
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        companyDetails = new DetailedCompanyParser(
            responseDecoded['data']['id'],
            responseDecoded['data']['about'],
            responseDecoded['data']['account_type'],
            responseDecoded['data']['address1'],
            responseDecoded['data']['address2'],
            responseDecoded['data']['address3'],
            responseDecoded['data']['city'],
            responseDecoded['data']['state'],
            responseDecoded['data']['pin'],
            responseDecoded['data']['country'],
            responseDecoded['data']['land_line  '],
            responseDecoded['data']['mobile1'],
            responseDecoded['data']['mobile2'],
            responseDecoded['data']['email'],
            responseDecoded['data']['website'],
            responseDecoded['data']['longitude'],
            responseDecoded['data']['latitude'],
            responseDecoded['data']['contact_first_name'],
            responseDecoded['data']['contact_last_name'],
            responseDecoded['data']['sso_id'],
            responseDecoded['data']['image_bigthumb_url'],
            responseDecoded['data']['image_smallthumb_url'],
            responseDecoded['data']['image_url'],
            responseDecoded['data']['organisation_name'],
            responseDecoded['data']['brandname_marathi'],
            responseDecoded['data']['brandname_hindi'],
            responseDecoded['data']['about_marathi'],
            responseDecoded['data']['about_hindi'],
            responseDecoded['data']['dealer_website'],
            responseDecoded['data']['cover_media_id'],
            responseDecoded['data']['brandname'],
            responseDecoded['data']['whatsapp_opt_in_status'],
            responseDecoded['data']['liked'],
            responseDecoded['data']['media_type'],
            responseDecoded['data']['image_max_color'],
            responseDecoded['data']['image_min_color']);

        final assets = responseDecoded['data']['assets'];

        for (Map i in assets) {
          companyDetailsAssets.add(DetailedAssetsParser.fromJson(i));

          if ((DetailedAssetsParser.fromJson(i).is_cover ?? false) == true) {
            BrandBannerbigthumb_url =
                DetailedAssetsParser.fromJson(i).bigthumb_url;
            BrandBannermedia_type = DetailedAssetsParser.fromJson(i).media_type;
            BrandBannermedia_url = DetailedAssetsParser.fromJson(i).media_url;
          }
        }

        final images = responseDecoded['data']['images'];

        for (Map i in images) {
          companyDetailsAssetsUrl
              .add(DetailedAssetsParser.fromJson(i).bigthumb_url);
        }

        final Brouchers = responseDecoded['data']['brouchers'];

        for (Map i in Brouchers) {
          companyDetailsBrouchers.add(DetailedBrouchersParser.fromJson(i));
        }

        final video = responseDecoded['data']['video'];

        for (Map i in video) {
          companyDetailsVideos.add(DetailedAssetsParser.fromJson(i));
        }

        final products = responseDecoded['data']['products'];

        for (Map i in products) {
          companyDetailsProductsList.add(ProductListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetNotifications() async {
    final response = await WebService().GetNotifications();

    print("response******" + response.toString());

    if (response != "error") {
      this.notificationsList.clear();
      // notificationsCounts = "";
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        //   notificationsCounts = responseDecoded['data']['totalcount'].toString();

        final data = responseDecoded['data']['records'];
        for (Map i in data) {
          notificationsList.add(NotificationsListParser.fromJson(i));
        }
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future Getrepresentative(int company_id) async {
    final response = await WebService().Getrepresentative(company_id);

    if (response != "error") {
      this.representativeList.clear();
      // notificationsCounts = "";
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      print("response123" + responseDecodedMsg.toString());
      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        //   notificationsCounts = responseDecoded['data']['totalcount'].toString();

        final data = responseDecoded['data'];
        for (Map i in data) {
          representativeList.add(RepresentativeListParser.fromJson(i));
        }
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future LikeDislikeProduct(int user_id, int company_id, int product_id) async {
    final response =
    await WebService().LikeDislikeProduct(user_id, company_id, product_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future LikeDislikeCompany(int user_id, int company_id) async {
    final response = await WebService().LikeDislikeCompany(user_id, company_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetFavProducts() async {
    final response = await WebService().GetFavProducts();

    if (response != "error") {
      this.favproductsList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];

        for (Map i in data) {
          favproductsList.add(ProductListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetFavOffers() async {
    final response = await WebService().GetFavOffers();

    if (response != "error") {
      this.favoffersList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          favoffersList.add(OfferListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetFavCompanies() async {
    final response = await WebService().GetFavCompanies();

    if (response != "error") {
      this.favcompaniesList.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data']['list'];

        for (Map i in data) {
          favcompaniesList.add(CompaniesListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future Getkisannet() async {
    final response = await WebService().Getkisannet();

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('paywall', responseDecoded['paywall']['paywall']);

      if (kIsWeb) {
        // running on the web!
        KissanNetObj(
            false,
            1,
            responseDecoded['kisan_exhibition']['home_tile_url_link'],
            responseDecoded['kisan_exhibition']['video_english'],
            responseDecoded['kisan_exhibition']['video_hindi'],
            responseDecoded['kisan_exhibition']['video_marathi'],
            responseDecoded['kisan_exhibition']['play_event_video'],
            responseDecoded['paywall']['paywall'],
            responseDecoded['whatsapp']['consent_reminder_days']);
      } else {
        // NOT running on the web! You can check for additional platforms here.
        if (Platform.isAndroid) {
          // Android-specific code
          KissanNetObj(
              responseDecoded['app_update']['android']['force_update_needed'],
              responseDecoded['app_update']['android']
              ['force_update_version_code'],
              responseDecoded['kisan_exhibition']['home_tile_url_link'],
              responseDecoded['kisan_exhibition']['video_english'],
              responseDecoded['kisan_exhibition']['video_hindi'],
              responseDecoded['kisan_exhibition']['video_marathi'],
              responseDecoded['kisan_exhibition']['play_event_video'],
              responseDecoded['paywall']['paywall'],
              responseDecoded['whatsapp']['consent_reminder_days']);
        } else if (Platform.isIOS) {
          // iOS-specific code
          KissanNetObj(
              responseDecoded['app_update']['ios']['force_update_needed'],
              responseDecoded['app_update']['ios']['force_update_version_code'],
              responseDecoded['kisan_exhibition']['home_tile_url_link'],
              responseDecoded['kisan_exhibition']['video_english'],
              responseDecoded['kisan_exhibition']['video_hindi'],
              responseDecoded['kisan_exhibition']['video_marathi'],
              responseDecoded['kisan_exhibition']['play_event_video'],
              responseDecoded['paywall']['paywall'],
              responseDecoded['whatsapp']['consent_reminder_days']);
        }
      }

      notifyListeners();
      return "success";
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future AppStart() async {
    final response = await WebService().AppStart();
    unread_notification_count = 0;

    if (response != "error") {
      this.membershipplansList.clear();
      USE_RAZORPAY_SUBSCRIPTIONS = "0";
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response********" + responseDecoded.toString());

        final data = responseDecoded['data']['membership_plans_info'];

        for (Map i in data) {
          membershipplansList.add(MemberShipPlansListParser.fromJson(i));
        }

        membershipInfo = new MembershipInfo(
            responseDecoded['data']['membership_info']['id'],
            responseDecoded['data']['membership_info']['expires_at'],
            responseDecoded['data']['membership_info']['status'],
            responseDecoded['data']['membership_info']['is_offline'],
            responseDecoded['data']['membership_info']['is_complementary'],
            responseDecoded['data']['membership_info']['is_expired']);

        unread_notification_count =
        responseDecoded['data']['unread_notification_count'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("membership_status",
            responseDecoded['data']['membership_info']['status'] ?? "");

        USE_RAZORPAY_SUBSCRIPTIONS =
        responseDecoded['data']['USE_RAZORPAY_SUBSCRIPTIONS'];

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future InitiateSubscription(String razorpay_plan_id) async {
    final response = await WebService().InitiateSubscription(razorpay_plan_id);

    if (response != "error") {
      subscriptionInitialInfo = null;
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        print(responseDecoded);
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        subscriptionInitialInfo = new SubscriptionInitialInfo(
            responseDecoded['data']['subscription_details']['id'],
            responseDecoded['data']['subscription_details']
            ['razorpay_subscription_id'],
            responseDecoded['data']['subscription_details']['plan_id'],
            responseDecoded['data']['subscription_details']['razorpay_plan_id'],
            responseDecoded['data']['subscription_details']['status'],
            responseDecoded['data']['subscription_details']['short_url'],
            responseDecoded['data']['subscription_details']
            ['expires_at_datetime']);
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future VerifySubscription(String razorpay_payment_id,
      String razorpay_subscription_id, String razorpay_signature) async {
    final response = await WebService().VerifySubscription(
        razorpay_payment_id, razorpay_subscription_id, razorpay_signature);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        AppStart();
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future FailureSubscription(
      String razorpay_subscription_id, Map errorMap) async {
    final response = await WebService()
        .FailureSubscription(razorpay_subscription_id, errorMap);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future connectProductCall(int user_id, int rep_id, int product_id) async {
    final response =
    await WebService().connectProductCall(user_id, rep_id, product_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future connectProductWhatsApp(
      int user_id, int rep_id, int product_id, int add_contact) async {
    final response = await WebService()
        .connectProductWhatsApp(user_id, rep_id, product_id, add_contact);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future connectCompanyCall(int user_id, int rep_id, int company_id) async {
    final response =
    await WebService().connectCompanyCall(user_id, rep_id, company_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future connectCompanyWhatsApp(
      int user_id, int rep_id, int company_id, int add_contact) async {
    final response = await WebService()
        .connectCompanyWhatsApp(user_id, rep_id, company_id, add_contact);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetFromPin(String pin_code) async {
    final response = await WebService().GetFromPin(pin_code);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return "error";
      } else if (responseDecodedSuccess == "true") {
        getDetailsFromPin = new GetDetailsFromPin(
            responseDecoded['data']['country'],
            responseDecoded['data']['state'],
            responseDecoded['data']['city']);

        notifyListeners();
        return getDetailsFromPin;
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future requestCallMe(int user_id, int company_id, int product_id) async {
    final response =
    await WebService().requestCallMe(user_id, company_id, product_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future InitiateGreenPass(
      String mobile, String first_name, String last_name) async {
    final response =
    await WebService().InitiateGreenPass(mobile, first_name, last_name);

    if (response != "error") {
      order_id = null;
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        print(responseDecoded);
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        order_id = responseDecoded['data']['order_id'];
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      order_id = null;
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future VerifyGreepass(String razorpay_payment_id, String razorpay_order_id,
      String razorpay_signature, int user_id) async {
    final response = await WebService().VerifyGreepass(
        razorpay_payment_id, razorpay_order_id, razorpay_signature, user_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        AppStart();
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future FailureGreepass(String razorpay_order_id, int user_id, String code,
      String error_description) async {
    final response = await WebService()
        .FailureGreepass(razorpay_order_id, user_id, code, error_description);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        AppStart();
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future visitProduct(int company_id, int product_id) async {
    final response = await WebService()
        .visitProduct(userprofileData.user, company_id, product_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future visitCompany(int company_id) async {
    final response =
    await WebService().visitCompany(userprofileData.user, company_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetCallHistory(String search_string) async {
    this.canLoadMoreCalls = false;

    final response = await WebService().GetCallHistory(search_string, 1);

    if (response != "error") {
      this.callHistoryList.clear();
      this.callHistoryUserObj.clear();
      this.companyCallObj.clear();
      this.productCallObj.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        int j = 0;

        for (Map i in data) {
          callHistoryList.add(CallHistoryListParser.fromJson(i));

          callHistoryUserObj.add(CallHistoryUserObj.fromJson(
              responseDecoded['data'][j]['user_data']));

          if (responseDecoded['data'][j]['company'] != null) {
            companyCallObj.add(
                CompanyCallObj.fromJson(responseDecoded['data'][j]['company']));
          }else{
            companyCallObj.add(null);
          }

          if (responseDecoded['data'][j]['products'] != null) {
            productCallObj.add(ProductCallObj.fromJson(
                responseDecoded['data'][j]['products']));
          }else{
            productCallObj.add(null);
          }

          j++;
        }

        if (callHistoryList.length == 0 || j < 10) {
          this.canLoadMoreCalls = false;
        } else {
          this.canLoadMoreCalls = true;
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future AppendCallHistory(String search_string, int pageCount) async {
    this.canLoadMoreCalls = true;

    final response =
    await WebService().GetCallHistory(search_string, pageCount);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        this.canLoadMoreCalls = false;
        notifyListeners();
        return "No more items";
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        int j = 0;

        int temp = callHistoryList.length;
        for (Map i in data) {
          callHistoryList.add(CallHistoryListParser.fromJson(i));
          callHistoryUserObj.add(CallHistoryUserObj.fromJson(
              responseDecoded['data'][j]['user_data']));

          if (responseDecoded['data'][j]['company'] != null) {
            companyCallObj.add(
                CompanyCallObj.fromJson(responseDecoded['data'][j]['company']));
          }else{
            companyCallObj.add(null);
          }

          if (responseDecoded['data'][j]['products'] != null) {
            productCallObj.add(ProductCallObj.fromJson(
                responseDecoded['data'][j]['products']));
          }else{
            productCallObj.add(null);
          }

          j++;
        }

        if (temp == callHistoryList.length ||
            callHistoryList.length - temp < 10) {
          this.canLoadMoreCalls = false;
          notifyListeners();
          return "No more items";
        } else {
          notifyListeners();
          return "success";
        }
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetEventsDetails(int event_id) async {
    final response = await WebService().GetEventsDetails(event_id);

    if (response != "error") {
      eventDetails = null;
      this.webinarList.clear();
      this.pavilionsList.clear();
      this.subcategories.clear();
      this.pavilion_id_list.clear();
      this.subcategory_ids_list.clear();
      category_count = 0;
      subcategory_count = 0;

      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        print(responseDecoded);
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        if (responseDecoded['data']['event_details']['type'] == "WSM") {
          eventDetails = new EventDetails(
            responseDecoded['data']['event_details']['user_id'],
            responseDecoded['data']['event_details']['type'],
            responseDecoded['data']['event_details']['title'],
            responseDecoded['data']['event_details']['about'],
            responseDecoded['data']['event_details']['about_hindi'],
            responseDecoded['data']['event_details']['about_marathi'],
            responseDecoded['data']['event_details']['created_date'],
            responseDecoded['data']['event_details']['image_path'],
            responseDecoded['data']['event_details']['image_path_medium'],
            responseDecoded['data']['event_details']['image_path_small'],
            responseDecoded['data']['event_details']['webinar_ids'],
            responseDecoded['data']['event_details']['pavilion_id'],
            responseDecoded['data']['event_details']['media_type'],
            responseDecoded['data']['event_details']['media_url'],
            responseDecoded['data']['event_details']['start_date'],
            responseDecoded['data']['event_details']['end_date'],
            responseDecoded['data']['event_details']['share_link'],
            responseDecoded['data']['event_details']['event_date_status'],
            responseDecoded['data']['event_details']['quiz_form_url'],
            responseDecoded['data']['event_details']['survey_form_url'],
            responseDecoded['data']['event_details']['poll_form_url'],
            responseDecoded['data']['is_added_to_calender'],
          );

          final data = responseDecoded['data']['webinars'];

          if (data != null) {
            for (Map i in data) {
              webinarList.add(WebinarListParser.fromJson(i));
            }
          }

          final pavilions = responseDecoded['data']['pavilions'];
          if (pavilions != null) {
            for (Map j in pavilions) {
              pavilionsList.add(CategoryListParser.fromJson(j));
            }
          }

          final temp_subcategories = responseDecoded['data']['subcategories'];
          if (temp_subcategories != null) {
            subcategories = temp_subcategories;
          }

          if (responseDecoded['data']['event_details']['pavilion_id'] != null) {
            pavilion_id_list = responseDecoded['data']['event_details']
            ['pavilion_id']
                .toString()
                .split(",");
          }

          if (responseDecoded['data']['event_details']['subcategory_ids'] !=
              null) {
            subcategory_ids_list = responseDecoded['data']['event_details']
            ['subcategory_ids']
                .toString()
                .split(",");
          }

          category_count =
              responseDecoded['data']['event_details']['category_count'] ?? 0;
          subcategory_count = responseDecoded['data']['event_details']
          ['subcategory_count'] ??
              0;

          notifyListeners();
          return "success";
        } else {
          notifyListeners();
          return "webinar";
        }
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future EventRegister(int event_id, int user_id) async {
    final response = await WebService().EventRegister(event_id, user_id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();
      print(responseDecodedMsg);
      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetWebinarDetail(int event_id) async {
    final response =
    await WebService().GetWebinarDetail(event_id, userprofileData.user);

    if (response != "error") {
      webinarDetails = null;
      var responseDecoded = jsonDecode(response.body);
      print(responseDecoded);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print(responseDecoded.toString());

        final addons = responseDecoded['data'][0]['addons'];

        String addons_name = "";

        if (addons.length > 0) {
          for (int d = 0; d < addons.length; d++) {
            if (addons[d]['name'] == "Callback") {
              addons_name = addons[d]['name'];
            }
          }
        }

        webinarDetails = new WebinarDetails(
            responseDecoded['data'][0]['id'],
            responseDecoded['data'][0]['user_id'],
            responseDecoded['data'][0]['type'],
            responseDecoded['data'][0]['title'],
            responseDecoded['data'][0]['about'],
            responseDecoded['data'][0]['scheduled_date'],
            responseDecoded['data'][0]['scheduled_time'],
            responseDecoded['data'][0]['duration'],
            responseDecoded['data'][0]['language'],
            responseDecoded['data'][0]['created_date'],
            responseDecoded['data'][0]['updated_date'],
            responseDecoded['data'][0]['image_path'],
            responseDecoded['data'][0]['status'],
            responseDecoded['data'][0]['meeting_link'],
            responseDecoded['data'][0]['meeting_id'],
            responseDecoded['data'][0]['meeting_password'],
            responseDecoded['data'][0]['share_link'],
            responseDecoded['data'][0]['audience_size'],
            responseDecoded['data'][0]['featured'],
            responseDecoded['data'][0]['image_path_medium'],
            responseDecoded['data'][0]['image_path_small'],
            responseDecoded['data'][0]['price'],
            responseDecoded['data'][0]['media_type'],
            responseDecoded['data'][0]['media_url'],
            responseDecoded['data'][0]['allowed_audience'],
            responseDecoded['data'][0]['image_bigthumb_url'],
            responseDecoded['data'][0]['organisation_name'],
            responseDecoded['data'][0]['first_name'],
            responseDecoded['data'][0]['last_name'],
            responseDecoded['data'][0]['mobile'],
            responseDecoded['data'][0]['in_event'].toString(),
            addons_name);

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }


  Future setWebinarLive() async {
    webinarDetails.status = "live";
    notifyListeners();
  }

  Future CreateOrder(String event_id) async {
    final response = await WebService()
        .CreateOrder(userprofileData.user.toString(), event_id);

    if (response != "error") {
      order_id_webinar = null;
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();
      if (responseDecodedSuccess == "false") {
        notifyListeners();

        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        order_id_webinar = responseDecoded['data']['id'];

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future VerifyOrder(String razorpay_payment_id, String razorpay_order_id,
      String razorpay_signature, String event_id) async {
    final response = await WebService().VerifyOrder(
        razorpay_payment_id,
        razorpay_order_id,
        razorpay_signature,
        userprofileData.user.toString(),
        event_id);

    print(response);
    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future OptInOut(String OPT_IN_OUT) async {
    final response = await WebService().OptInOut(OPT_IN_OUT);

    if (response != "error") {
      order_id_webinar = null;
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();
      if (responseDecodedSuccess == "false") {
        notifyListeners();

        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetWebinarList(
      String search_string,
      String language,
      String min_scheduled_date,
      String max_scheduled_date,
      String category) async {
    this.canLoadMoreWebinar = true;

    final response = await WebService().GetWebinarList(
        userprofileData.user.toString(),
        search_string,
        language,
        min_scheduled_date,
        max_scheduled_date,
        category,
        1);

    if (response != "error") {
      this.webinarListViewAll.clear();
      WebinarCounts =  "0";
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          webinarListViewAll.add(WebinarListParser.fromJson(i));
        }
        if (webinarListViewAll.length == 0 || webinarListViewAll.length < 10) {
          this.canLoadMoreWebinar = false;
        }
        WebinarCounts =  responseDecoded['count'].toString();

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future AppendWebinarList(
      String search_string,
      String language,
      String min_scheduled_date,
      String max_scheduled_date,
      String category,
      int pageCount) async {
    this.canLoadMoreWebinar = true;

    final response = await WebService().GetWebinarList(
        userprofileData.user.toString(),
        search_string,
        language,
        min_scheduled_date,
        max_scheduled_date,
        category,
        pageCount);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        int temp = webinarListViewAll.length;
        for (Map i in data) {
          webinarListViewAll.add(WebinarListParser.fromJson(i));
        }
        if (temp == webinarListViewAll.length ||
            webinarListViewAll.length - temp < 10) {
          this.canLoadMoreWebinar = false;
          notifyListeners();
          return "No more items";
        } else {
          notifyListeners();
          return "success";
        }
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetEventFilters() async {
    final response = await WebService().GetEventFilters();

    if (response != "error") {
      this.filterCategoryList.clear();
      this.filterLanguageList.clear();
      this.recencyLang.clear();
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == false) {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == true) {
        print("response" + responseDecodedMsg.toString());

        final lang_list = responseDecoded['lang_list'];

        for (Map i in lang_list) {
          filterLanguageList.add(FilterLanguageListParser.fromJson(i));
          recencyLang.add(FilterLanguageListParser.fromJson(i).language);
        }

        final category_list = responseDecoded['category_list'];

        for (Map i in category_list) {
          filterCategoryList.add(FilterCategoryListParser.fromJson(i));
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetMyWebinarList(String user_id) async {
    this.canLoadMoreMyWebinar = true;
    final response = await WebService().GetMyWebinarList(user_id, 1);

    if (response != "error") {
      this.MyWebinarList.clear();
      WebinarCounts =  "0";
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        for (Map i in data) {
          MyWebinarList.add(WebinarListParser.fromJson(i));
        }

        if (MyWebinarList.length == 0 || MyWebinarList.length < 10) {
          this.canLoadMoreMyWebinar = false;
        }

        WebinarCounts =   responseDecoded['count'].toString();
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future AppendMyWebinarList(String user_id, int pageCount) async {
    this.canLoadMoreMyWebinar = true;

    final response = await WebService().GetMyWebinarList(user_id, pageCount);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == "false") {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == "true") {
        print("response" + responseDecodedMsg.toString());

        final data = responseDecoded['data'];

        int temp = MyWebinarList.length;
        for (Map i in data) {
          MyWebinarList.add(WebinarListParser.fromJson(i));
        }
        if (temp == MyWebinarList.length || MyWebinarList.length - temp < 10) {
          this.canLoadMoreMyWebinar = false;
          notifyListeners();
          return "No more items";
        } else {
          notifyListeners();
          return "success";
        }

        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future requestCallMeForWebinar(String id) async {
    final response =
    await WebService().requestCallMeForWebinar(userprofileData.email, id);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      var responseDecodedSuccess = responseDecoded['success'];
      var responseDecodedMsg = responseDecoded['message'].toString();

      if (responseDecodedSuccess == false) {
        notifyListeners();
        return responseDecodedMsg;
      } else if (responseDecodedSuccess == true) {
        print("response" + responseDecodedMsg.toString());
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }
}
