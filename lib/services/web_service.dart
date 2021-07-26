import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class WebService {
  // All items by location Apis
  Future sendOTP(String phoneNumber, bool _isChecked) async {
    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "mobile": phoneNumber,
        "source": "android",
        "account_type": 1,
        "mode": "whatsapp",
        "method": _isChecked == true ? "OPT_IN" : "OPT_OUT"
      };

      var body = json.encode(data);
      print("body" + body.toString());
      final response = await http.post(Uri.parse(send_custom_otp_mobile),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Unable to perform request!");
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future resendOTP(phoneNo, mode, OPT_IN_OUT) async {
    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "mobile": phoneNo,
        "source": "android",
        "account_type": 1,
        "mode": mode,
        "method": OPT_IN_OUT
      };

      var body = json.encode(data);
      print("body" + body.toString());
      final response = await http.post(Uri.parse(send_custom_otp_mobile),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Unable to perform request!");
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future verifyOTP(String verification_token, String verification_code) async {
    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "verification_token": verification_token,
        "verification_code": verification_code,
        "source": "web/app",
        "account_type": 1,
      };
      var body = json.encode(data);

      final response = await http.post(Uri.parse(api_token_custom_otp_auth),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Unable to perform request!");
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse(profiles),
        headers: {
          'Authorization': 'Bearer ' + prefs.getString("token"),
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future ImageUpload(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var streamFront = new http.ByteStream(Stream.castFrom(image.openRead()));
      var lengthFront = await image.length();
      var uri = Uri.parse(image_upload);
      var request = new http.MultipartRequest("POST", uri);
      var multipartFileFront = new http.MultipartFile(
          "myfile", streamFront, lengthFront,
          filename: basename(image.path));
      request.files.add(multipartFileFront);
      request.headers
          .addAll({'Authorization': 'Bearer ' + prefs.getString("token")});
      var respond = await request.send();
      if (respond.statusCode == 200) {
        return "success";
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data;

    try {
      if (email.length > 0) {
        data = {
          "client_id": client_id,
          "client_secret": client_secret,
          "first_name": first_name ?? "",
          "last_name": last_name ?? "",
          "city": city ?? "",
          "state": state ?? "",
          "longitude": longitude ?? "",
          "latitude": latitude ?? "",
          "login_type": login_type,
          "registration_id": prefs.getString("token"),
          "email": email ?? "",
          "email_source": email_source ?? "",
          "mark_email_verified": mark_email_verified,
          "reg_type": reg_type
        };
      } else {
        data = {
          "client_id": client_id,
          "client_secret": client_secret,
          "first_name": first_name ?? "",
          "last_name": last_name ?? "",
          "city": city ?? "",
          "state": state ?? "",
          "longitude": longitude ?? "",
          "latitude": latitude ?? "",
          "login_type": login_type,
          "registration_id": prefs.getString("token"),
          "mark_email_verified": mark_email_verified,
          "reg_type": reg_type
        };
      }

      var body = json.encode(data);

      final response = await http.post(Uri.parse(register),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data;

    try {
      if (email.length > 0) {
        data = {
          "client_id": client_id,
          "client_secret": client_secret,
          "first_name": first_name ?? "",
          "last_name": last_name ?? "",
          "city": city ?? "",
          "state": state ?? "",
          "longitude": longitude ?? "",
          "latitude": latitude ?? "",
          "login_type": login_type,
          "image_url": image_url,
          "image_bigthumb_url": image_url,
          "image_smallthumb_url": image_url,
          "registration_id": prefs.getString("token"),
          "email": email ?? "",
          "email_source": email_source ?? "",
          "mark_email_verified": mark_email_verified,
          "reg_type": reg_type
        };
      } else {
        data = {
          "client_id": client_id,
          "client_secret": client_secret,
          "first_name": first_name ?? "",
          "last_name": last_name ?? "",
          "city": city ?? "",
          "state": state ?? "",
          "longitude": longitude ?? "",
          "latitude": latitude ?? "",
          "login_type": login_type,
          "registration_id": prefs.getString("token"),
          "mark_email_verified": mark_email_verified,
          "reg_type": reg_type
        };
      }

      var body = json.encode(data);

      final response = await http.post(Uri.parse(register),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "user_details": {
          "first_name": first_name,
          "last_name": last_name,
          "email": email
        },
        "user_profile": {
          "email": email,
          "city": city,
          "state": state,
          "longitude": longitude,
          "latitude": latitude
        },
        "notification_consent": {
          "method": isChecked == true ? "OPT_IN" : "OPT_OUT",
          "source": "android",
          "mode": "whatsapp"
        }
      };

      var body = json.encode(data);

      final response = await http.put(Uri.parse(profiles),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "user_details": {
          "first_name": first_name,
          "last_name": last_name,
          "email": email
        },
        "user_profile": {
          "email": email,
          "is_email_verified": true,
          "email_source": "google",
          "image_url": image_url,
          "image_bigthumb_url": image_url,
          "image_smallthumb_url": image_url
        },
        "notification_consent": {
          "method": "OPT_IN",
          "source": "android",
          "mode": "whatsapp"
        }
      };

      var body = json.encode(data);

      final response = await http.put(Uri.parse(profiles),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetAds() async {
    try {
      Map data = {"ad_position": "top,middle,bottom"};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(getadlist),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetAdsForHomeSlider() async {
    try {
      Map data = {"ad_position": "topslider", "ad_screen": "logged_home"};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(getadlist),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetAdsForCategorySlider(int event_id, int pavilion_id) async {
    try {
      Map data;

      if (event_id == 0) {
        data = {
          "ad_position": "topslider",
          "ad_screen": "pavilion_details",
          "pavilionid": pavilion_id.toString()
        };
      } else {
        data = {
          "ad_position": "topslider",
          "ad_screen": "pavilion_details",
          "pavilionid": pavilion_id.toString(),
          "event_id": event_id
        };
      }

      var body = json.encode(data);

      final response = await http.post(Uri.parse(getadlist),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"order_column": "created_datetime", "order_by": "DESC"};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(newly_added_products),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetFeaturedProducts(
      int shuffled_index1, int shuffled_index2, int max_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "page": 1,
        "featured": 1,
        "shuffled_index1": shuffled_index1,
        "shuffled_index2": shuffled_index2,
        "max_id": max_id
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(shuffled_products),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetCompanies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"order_column": "created_on", "order_by": "DESC"};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(companies),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetFeaturedCompanies(
      int shuffled_index1, int shuffled_index2, int max_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "search_string ": "",
        "page": 1,
        "featured": 1,
        "shuffled_index1": shuffled_index1,
        "shuffled_index2": shuffled_index2,
        "max_id": max_id
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(shuffled_companies),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetOffers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "search_string": "",
        "order_column": "created_date",
        "order_by": "DESC"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(offers),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetDemos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "search_string": "",
        "page": 1,
        "order_column": "created_date",
        "order_by": "DESC"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(demos),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetLatestLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "search_string": "",
        "order_column": "created_date",
        "order_by": "DESC"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(launch),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetEvents(String user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "source": "web/app",
        "account_type": 1,
        "user_id": user_id,
        "page": 1,
        "type": "published,live",
        "search_string": ""
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(eventlist),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetFeaturedEvents(String user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "source": "web/app",
        "account_type": 1,
        "user_id": user_id,
        "page": 1,
        "type": "published,live",
        "search_string": "",
        "featured": 1
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(eventlist),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetCategories() async {
    try {
      final response = await http.get(Uri.parse(pavilions));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetSubCategories(int event_id, int pavilion_id) async {
    try {
      Map data;

      if (event_id == 0) {
        data = {"pavilion_id": pavilion_id};
      } else {
        data = {"pavilion_id": pavilion_id, "event_id": event_id};
      }

      var body = json.encode(data);

      final response = await http.post(Uri.parse(pavilion_category),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetProductsByCategoryIdsAndSearchString(
      int isfromSearch,
      int event_id,
      List<int> catids,
      String searchString,
      int pageCount,
      int shuffled_index1,
      int shuffled_index2,
      int max_id, int user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data;
    try {
      if (isfromSearch == 1) {
        if (event_id == 0) {
          data = {
            "category": catids.length > 0 ? catids : null,
            "search_string": searchString,
            "page": pageCount,
            "user_id": user_id==0?null:user_id
          };
        } else {
          data = {
            "event_id": event_id,
            "category": catids.length > 0 ? catids : null,
            "search_string": searchString,
            "page": pageCount,
            "user_id": user_id==0?null:user_id
          };
        }
      } else {
        if (event_id == 0) {
          data = {
            "category": catids.length > 0 ? catids : null,
            "search_string": searchString,
            "page": pageCount,
            "shuffled_index1": shuffled_index1,
            "shuffled_index2": shuffled_index2,
            "max_id": max_id,
            "user_id": user_id==0?null:user_id
          };
        } else {
          data = {
            "event_id": event_id,
            "category": catids.length > 0 ? catids : null,
            "search_string": searchString,
            "page": pageCount,
            "shuffled_index1": shuffled_index1,
            "shuffled_index2": shuffled_index2,
            "max_id": max_id,
            "user_id": user_id==0?null:user_id
          };
        }
      }

      var body = json.encode(data);

      final response = await http.post(
          Uri.parse(isfromSearch == 1 ? products : shuffled_products),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetCompaniesByCategoryIdsAndSearchString(
      int isfromSearch,
      int event_id,
      List<int> catids,
      String searchString,
      int pageCount,
      int shuffled_index1,
      int shuffled_index2,
      int max_id,
      int user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data;

    try {
      if (isfromSearch == 1) {
        if (event_id == 0) {
          data = {
            "category": catids.length > 0 ? catids : null,
            "search_string": searchString,
            "page": pageCount,
            "user_id": user_id==0?null:user_id
          };
        } else {
          data = {
            "event_id": event_id,
            "category": catids.length > 0 ? catids : null,
            "search_string": searchString,
            "page": pageCount,
            "user_id": user_id==0?null:user_id
          };
        }
      } else {
        if (event_id == 0) {
          data = {
            "category": catids.length > 0 ? catids : null,
            "search_string": searchString,
            "page": pageCount,
            "shuffled_index1": shuffled_index1,
            "shuffled_index2": shuffled_index2,
            "max_id": max_id,
            "user_id": user_id==0?null:user_id
          };
        } else {
          data = {
            "event_id": event_id,
            "category": catids.length > 0 ? catids : null,
            "search_string": searchString,
            "page": pageCount,
            "shuffled_index1": shuffled_index1,
            "shuffled_index2": shuffled_index2,
            "max_id": max_id,
            "user_id": user_id==0?null:user_id
          };
        }
      }

      var body = json.encode(data);

      final response = await http.post(
          Uri.parse(isfromSearch == 1 ? companies : shuffled_companies),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        print("*******3");
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetOffersBySearchString(String searchString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "search_string": searchString,
        "order_column": "created_date",
        "order_by": "DESC"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(offers),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetDetailedOfProduct(int product_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"product_id": product_id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(get_product_details),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetProductsFromSameCompany(int company_id, skip_product_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "page": 1,
        "search_string": "",
        "user_id": company_id,
        "skip_product_id": skip_product_id,
        "order_column": "created_datetime",
        "order_by": "DESC"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(products),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetSimilarProducts(List<int> catids, skip_product_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "category": catids,
        "search_string": "",
        "page": 1,
        "order_column": "created_datetime",
        "skip_product_id": skip_product_id,
        "order_by": "DESC"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(products),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetDetailedOfCompany(int company_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"company_id": company_id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(get_company),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map data = {"currentpage": 1, "pagesize": 10, "source": "android"};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(getnotifications),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token")
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future Getrepresentative(int company_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map data = {"company_id": company_id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(representative),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token")
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future LikeDislikeProduct(int user_id, int company_id, int product_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "activity_by_user_type": "visitor",
        "activity_by_userid": user_id,
        "activity_code": "like_product",
        "activity_for_item_id": product_id,
        "activity_for_user_type": "visitor",
        "activity_for_userid": company_id,
        "eventcode": "KISAN2020",
        "field1": "",
        "for": "product",
        "source": "android"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future LikeDislikeCompany(int user_id, int company_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "activity_by_user_type": "visitor",
        "activity_by_userid": user_id,
        "activity_code": "like_profile",
        "activity_for_item_id": company_id,
        "activity_for_user_type": "visitor",
        "activity_for_userid": company_id,
        "eventcode": "KISAN2020",
        "field1": "",
        "for": "company",
        "source": "android"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetFavProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "page": 1,
        "order_column": "created_datetime",
        "order_by": "DESC",
        "is_favourite": 1
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(products),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetFavOffers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"page": 1, "is_favourite": 1};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(offers),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token")
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetFavCompanies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"page": 1, "is_favourite": 1};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(companies),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future Getkisannet() async {
    try {
      final response = await http.get(Uri.parse(kisannet));

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future AppStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //TODO: change and clarify with kisan team once
    try {
      Map data = {"event_code": "KISAN2020"};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(api_start),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future InitiateSubscription(String razorpay_plan_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"plan_id": razorpay_plan_id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(subscribe),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future VerifySubscription(String razorpay_payment_id,
      String razorpay_subscription_id, String razorpay_signature) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "razorpay_payment_id": razorpay_payment_id,
        "razorpay_subscription_id": razorpay_subscription_id,
        "razorpay_signature": razorpay_signature,
        "org_logo": "",
        "org_name": "Razorpay Software Private Ltd",
        "checkout_logo":
        "https://dashboard-activation.s3.amazonaws.com/org_100000razorpay/checkout_logo/phpnHMpJe",
        "custom_branding": false
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(verify_subscription_payment),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future FailureSubscription(
      String razorpay_subscription_id, Map errorMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "error": errorMap,
        "razorpay_subscription_id": razorpay_subscription_id
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(verify_subscription_payment),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future connectProductCall(int user_id, int rep_id, int product_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "activity_by_user_type": "visitor",
        "activity_by_userid": user_id,
        "activity_code": "connect_product",
        "activity_for_item_id": product_id,
        "activity_for_user_type": "visitor",
        "activity_for_userid": rep_id,
        "eventcode": "KISAN2020",
        "field1": "call",
        "for": "product",
        "source": "android"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future connectProductWhatsApp(
      int user_id, int rep_id, int product_id, int add_contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "activity_by_user_type": "visitor",
        "activity_by_userid": user_id,
        "activity_code": "connect_product",
        "activity_for_item_id": product_id,
        "activity_for_user_type": "visitor",
        "activity_for_userid": rep_id,
        "eventcode": "KISAN2020",
        "field1": "whatsapp",
        "for": "product",
        "source": "android",
        "add_contact": add_contact
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future connectCompanyCall(int user_id, int rep_id, int company_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "activity_by_user_type": "visitor",
        "activity_by_userid": user_id,
        "activity_code": "connect_profile",
        "activity_for_item_id": company_id,
        "activity_for_user_type": "visitor",
        "activity_for_userid": rep_id,
        "eventcode": "KISAN2020",
        "field1": "call",
        "for": "company",
        "source": "android",
        "add_contact": 0
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future connectCompanyWhatsApp(
      int user_id, int rep_id, int company_id, int add_contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "activity_by_user_type": "visitor",
        "activity_by_userid": user_id,
        "activity_code": "connect_profile",
        "activity_for_item_id": company_id,
        "activity_for_user_type": "visitor",
        "activity_for_userid": rep_id,
        "eventcode": "KISAN2020",
        "field1": "whatsapp",
        "for": "company",
        "source": "android",
        "add_contact": add_contact
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetFromPin(String pin_code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"pin_code": pin_code};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(getdetailsfrompin),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future requestCallMe(int user_id, int company_id, int product_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "activity_by_user_type": "visitor",
        "activity_by_userid": user_id,
        "activity_code": "connect_product",
        "activity_for_item_id": product_id,
        "activity_for_user_type": "visitor",
        "activity_for_userid": company_id,
        "eventcode": "KISAN2020",
        "field1": "request call",
        "source": "android"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future InitiateGreenPass(
      String mobile, String first_name, String last_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "eventcode": "KISAN2020",
        "source": "android",
        "lang": "en",
        "payment_for": "event_register",
        "client_id": client_id,
        "client_secret": client_secret,
        "people": [
          {
            "country_code": "+91",
            "mobile": "9834381642",
            "first_name": first_name,
            "last_name": last_name,
            "type": "green",
            "image_url": "",
            "is_phone_contact": "0"
          }
        ]
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(intiate_greenpass),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future VerifyGreepass(String razorpay_payment_id, String razorpay_order_id,
      String razorpay_signature, int user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "razorpay_payment_id": razorpay_payment_id,
        "razorpay_order_id": razorpay_order_id,
        "razorpay_signature": razorpay_signature,
        "user_id": user_id,
        "event_code": "KISAN2020",
        "client_id": client_id,
        "client_secret": client_secret
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(verify_greenpass),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future FailureGreepass(String razorpay_order_id, int user_id, String code,
      String error_description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "razorpay_payment_id": "",
        "razorpay_order_id": razorpay_order_id,
        "razorpay_signature": "",
        "user_id": user_id,
        "event_code": "KISAN2020",
        "client_id": client_id,
        "client_secret": client_secret,
        "error_code": code,
        "error_description": error_description
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(verify_greenpass),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future visitProduct(int user_id, int company_id, int product_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "activity_by_user_type": "visitor",
        "activity_by_userid": user_id,
        "activity_code": "visit_product",
        "activity_for_item_id": product_id,
        "activity_for_user_type": "visitor",
        "activity_for_userid": company_id,
        "eventcode": "KISAN2020",
        "field1": "",
        "for": "product",
        "source": "android"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future visitCompany(int user_id, int company_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "activity_by_user_type": "visitor",
        "activity_by_userid": user_id,
        "activity_code": "visit_profile",
        "activity_for_item_id": company_id,
        "activity_for_user_type": "visitor",
        "activity_for_userid": company_id,
        "eventcode": "KISAN2020",
        "field1": "",
        "for": "company",
        "source": "android"
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetCallHistory(String search_string, int pageCount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"page": pageCount, "search_string": search_string};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(get_activity),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetEventsDetails(int event_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"event_id": event_id, "source": "Android"};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(get_event_details),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future EventRegister(int event_id, int user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "account_type": 1,
        "event_id": event_id,
        "user_id": user_id
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(eventregister),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future WebinarAttent(int event_id, int user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "source": "android",
        "user_id": user_id,
        "event_id": event_id,
        "joining": 1
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(meetinglog),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future WebinarLeave(int event_id, int user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "source": "android",
        "user_id": user_id,
        "event_id": event_id,
        "ending": 1
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(meetinglog),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetWebinarDetail(int event_id, int user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "source": "android",
        "account_type": 1,
        "event_id": event_id,
        "user_id": user_id,
        "type": "published,live,completed",
        "search_string": ""
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(eventlist),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetLanguageKeys(int lastfetchtime) async {
    print(lastfetchtime);

    try {
      final response = await http.get(
        Uri.parse(getlanguagekeys + lastfetchtime.toString()),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GoogleLogin(var google_id_token, var fcm_id) async {
    /* print("token*****");
    logLongString(google_id_token);*/

    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "source": "android",
        "account_type": 1,
        "google_id_token": google_id_token,
        "fcm_id": fcm_id
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(googlelogin),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future CreateOrder(String user_id, String event_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"user_id": user_id, "event_id": event_id};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(ordercreate),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      print(response.body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future VerifyOrder(String razorpay_payment_id, String razorpay_order_id,
      String razorpay_signature, String user_id, String event_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "razorpay_payment_id": razorpay_payment_id,
        "razorpay_order_id": razorpay_order_id,
        "razorpay_signature": razorpay_signature,
        "user_id": user_id,
        "event_id": event_id,
        "client_id": client_id,
        "client_secret": client_secret
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(verifytransaction),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future OptInOut(String OPT_IN_OUT) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "method": OPT_IN_OUT,
        "source": "android",
        "mode": "whatsapp"
      };

      var body = json.encode(data);

      final response =
      await http.post(Uri.parse(set_unset_notification_consent),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      print(response.body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetEventFilters() async {
    try {
      Map data = {"client_id": client_id, "client_secret": client_secret};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(geteventfilters),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetWebinarList(
      String user_id,
      String search_string,
      String language,
      String min_scheduled_date,
      String max_scheduled_date,
      String category,
      int pageCount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "source": "web/app",
        "account_type": 1,
        "user_id": user_id,
        "type": "published,live",
        "search_string": search_string,
        "page": pageCount,
        "language": language,
        "min_scheduled_date": min_scheduled_date,
        "max_scheduled_date": max_scheduled_date,
        "category": category.length > 0 ? category : null,
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(eventlist),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetMyWebinarList(String user_id, int pageCount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "client_id": client_id,
        "client_secret": client_secret,
        "source": "android",
        "account_type": 1,
        "my_account": 1,
        "user_id": user_id,
        "type": "published,live,completed",
        "search_string": "",
        "page": pageCount
      };

      var body = json.encode(data);

      final response = await http.post(Uri.parse(eventlist),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + prefs.getString("token"),
          },
          body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }
}
