import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:kisanweb/Helpers/constants.dart' as constants;
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
//import 'package:kisanweb/UI/Auth/SuccessOTP.dart';
import 'package:kisanweb/UI/HomeScreen/HomeScreen.dart';
import 'package:kisanweb/UI/HomeScreen/Widgets/bottom_tabs.dart';
//import 'package:kisanweb/UI/Widgets/jumping_dots.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:location/location.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:permission_handler/permission_handler.dart' as permisson;
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kisanweb/Models/GetDetailsFromPin.dart';

File imageOne;
bool fetched = false;

class BasicProfile extends StatefulWidget {
  String first_name, last_name, email, image_url, state, city;

  BasicProfile(this.first_name, this.last_name, this.email, this.image_url,
      this.state, this.city);

  @override
  _BasicProfileState createState() => _BasicProfileState();
}

class _BasicProfileState extends State<BasicProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  int filtersState = -1;
  int filtersDistrict = -1;
  List<String> DistrictList;

  Location location = new Location();
  LocationData _locationData;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  var addresses;
  var first;
  var lat = "";
  var long = "";
  var city = "";
  var state = "";

  bool permission = true;
  final picker = ImagePicker();

  Future Register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("asd");
    print(prefs.getString("token"));

    setState(() {
      if (long == null || long == "") {
        long = "0.000000";
        lat = "0.000000";
      }
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .Register(
            firstNameController.text,
            lastNameController.text,
            city,
            state,
            long.toString(),
            lat.toString(),
            "otp",
            emailController.text,
            "manual",
            false,
            "mobile")
        .then((value) {
      setState(() {
        if (value == "error") {
          toastCommon(context, getTranslated(context, 'no_data_tv'));
        } else if (value == "success") {
          if (imageOne != null) {
            Provider.of<CustomViewModel>(context, listen: false)
                .ImageUpload(imageOne)
                .then((value) async {
              setState(() {
                if (value == "error") {
                  toastCommon(context, getTranslated(context, 'no_data_tv'));
                } else if (value == "success") {
                  pushReplacement(context, HomeScreen("HomeScreen", 0, 0));
                } else {
                  toastCommon(context, value);
                }
              });
            });
          } else {
            pushReplacement(context, HomeScreen("HomeScreen", 0, 0));
          }
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  Future RegisterGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("asd");
    print(prefs.getString("token"));

    setState(() {
      if (long == null || long == "") {
        long = "0.000000";
        lat = "0.000000";
      }
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .RegisterGoogle(
            firstNameController.text,
            lastNameController.text,
            city,
            state,
            long.toString(),
            lat.toString(),
            "otp",
            widget.image_url,
            emailController.text,
            "google",
            true,
            "google")
        .then((value) {
      setState(() {
        if (value == "error") {
          toastCommon(context, getTranslated(context, 'no_data_tv'));
        } else if (value == "success") {
          if (imageOne != null) {
            Provider.of<CustomViewModel>(context, listen: false)
                .ImageUpload(imageOne)
                .then((value) async {
              setState(() {
                if (value == "error") {
                  toastCommon(context, getTranslated(context, 'no_data_tv'));
                } else if (value == "success") {
                  pushReplacement(context, HomeScreen("HomeScreen", 0, 0));
                } else {
                  toastCommon(context, value);
                }
              });
            });
          } else {
            pushReplacement(context, HomeScreen("HomeScreen", 0, 0));
          }
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  Future UpdateProfileData() {
    setState(() {
      if (long == null || long == "") {
        long = "0.000000";
        lat = "0.000000";
      }
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .UpdateProfileData(
      firstNameController.text,
      lastNameController.text,
      "otp",
      emailController.text,
      "manual",
      false,
      city,
      state,
      long,
      lat,
    )
        .then((value) {
      setState(() {
        if (value == "error") {
          toastCommon(context, getTranslated(context, 'no_data_tv'));
        } else if (value == "success") {
          if (imageOne != null) {
            Provider.of<CustomViewModel>(context, listen: false)
                .ImageUpload(imageOne)
                .then((value) async {
              setState(() {
                if (value == "error") {
                  toastCommon(context, getTranslated(context, 'no_data_tv'));
                } else if (value == "success") {
                  Provider.of<CustomViewModel>(context, listen: false)
                      .GetProfileData();
                  toastCommon(context, "Profile Updated");
                  pop(context);
                  pop(context);
                } else {
                  toastCommon(context, value);
                }
              });
            });
          } else {
            Provider.of<CustomViewModel>(context, listen: false)
                .GetProfileData();
            toastCommon(context, "Profile Updated");
            pop(context);
            pop(context);
          }
        } else {
          toastCommon(context, value);
        }
      });
    });
  }

  Future getImageOne() async {
    /*
     Navigator.of(context).pop();
    var pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );
    setState(() {
      imageOne = File(pickedFile.path);
      //enableSave = true;
      widget.image_url = "";
    });
*/

    try {
      List<Media> _listImagePaths = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          selectCount: 1,
          showGif: false,
          showCamera: true,
          compressSize: 500,
          uiConfig: UIConfig(uiThemeColor: Color(0xff007105)),
          cropConfig: CropConfig(enableCrop: true));

      _listImagePaths.forEach((media) {
        print(media.path.toString());
        setState(() {
          imageOne = File(media.path);
          widget.image_url = "";
        });
      });
    } on PlatformException {}
  }

  Future getImageOneGallery() async {
    Navigator.of(context).pop();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    setState(() {
      imageOne = File(pickedFile.path);
      //enableSave = true;
      widget.image_url = "";
    });
  }

  /*
  void _settingModalBottomSheetOne(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        getImageOne();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              //width: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Color(0xff007105),
                                )),
                          ),
                          Container(
                              width: 150,
                              child: Text(
                                "Open using camera",
                                style:
                                GoogleFonts.nunitoSans(letterSpacing: 0.5),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: InkWell(
                      onTap: () {
                        getImageOneGallery();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              //width: 100,
                                child: Icon(
                                  Icons.image,
                                  color: Color(0xff007105),
                                )),
                          ),
                          Container(
                              width: 150,
                              child: Text(
                                "Open using gallery",
                                style:
                                GoogleFonts.nunitoSans(letterSpacing: 0.5),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("88888888");
    print(widget.image_url);
    setState(() {
      imageOne = null;
      if (widget.city != null) {
        fetched = true;
        city = widget.city;
        state = widget.state;
      } else {
        fetched = false;
        city = null;
        state = null;
      }

      firstNameController.text = widget.first_name;
      lastNameController.text = widget.last_name;
      emailController.text = widget.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);

    buildTopWidget(BuildContext context) {
      return Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: getProportionateScreenWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: getProportionateScreenWidth(50),
                        width: getProportionateScreenWidth(50),
                      ),
                      child: ElevatedButton(
                          onPressed: () {
                            pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff1F8F4E),
                              padding: EdgeInsets.all(0),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              )),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Color(COLOR_WHITE),
                            ),
                          )),
                    ),
                    /*SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Container(
                      height: getProportionateScreenWidth(50),
                      width: getProportionateScreenWidth(50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color(0xff1F8F4E),
                      ),
                      child: Center(
                          child: Icon(
                        Icons.person,
                        color: Color(COLOR_WHITE),
                      )),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),*/
                    Text(
                      getTranslated(context, 'your_details'),
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Color(COLOR_BACKGROUND),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap:
                    () => /*_settingModalBottomSheetOne(context)*/ getImageOne(),
                child: Stack(
                  children: [
                    Container(
                      child: CircleAvatar(
                        radius: getProportionateScreenWidth(62),
                        backgroundColor: Colors.transparent,
                        backgroundImage: imageOne == null
                            ? widget.image_url != "" && widget.image_url != null
                                ? NetworkImage(widget.image_url)
                                : AssetImage('assets/images/defaultProfile.png')
                            : FileImage(imageOne),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.yellow,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child:
                                Icon(Icons.edit, color: Colors.black, size: 15),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ));
    }

    buildProfileForm(BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: getProportionateScreenWidth(170),
                  child: Theme(
                    data: ThemeData(primaryColor: Color(0xff08763F)),
                    child: TextFormField(
                      controller: firstNameController,
                      maxLength: 30,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\u0090-\u097F]')),
                        FilteringTextInputFormatter.deny(RegExp('[\u00A9,\u00AE,\u00A3]'))
                      ],
                      decoration: InputDecoration(
                          hintText: getTranslated(context, 'first_name_new'),
                          counterText: "",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1,
                            fontSize: 14,
                          )),
                      style: GoogleFonts.poppins(
                          color: Color(0xff08763F),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: getProportionateScreenWidth(170),
                  child: Theme(
                    data: ThemeData(primaryColor: Color(0xff08763F)),
                    child: TextFormField(
                      controller: lastNameController,
                      maxLength: 30,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\u0090-\u097F]')),
                        FilteringTextInputFormatter.deny(RegExp('[\u00A9,\u00AE,\u00A3]'))
                      ],
                      decoration: InputDecoration(
                          hintText: getTranslated(context, 'last_name_new'),
                          counterText: "",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          )),
                      style: GoogleFonts.poppins(
                          color: Color(0xff08763F),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            widget.email != "" && widget.state == null
                ? Container(
              width: double.infinity,
                  child: Theme(
                    data: ThemeData(primaryColor: Color(0xff08763F)),
                    child: TextFormField(
                      enabled: false,
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: getTranslated(context, 'email'),
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          )),
                      style: GoogleFonts.poppins(
                          color: Color(0xff08763F),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                : Container(
              width: double.infinity,
                  child: Theme(
                    data: ThemeData(primaryColor: Color(0xff08763F)),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: getTranslated(context, 'email'),
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          )),
                      style: GoogleFonts.poppins(
                          color: Color(0xff08763F),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getTranslated(context, 'location_address'),
                    style: GoogleFonts.poppins(
                      fontSize: getProportionateScreenHeight(18),
                      color: Color(0xff696969),
                    ),
                  ),
                  fetched == true
                      ? InkWell(
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                border: Border.all(color: Color(0xffCCCCCC))),
                            child: Center(
                              child: Icon(
                                Icons.edit,
                                color: Color(0xff696969),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              fetched = false;
                              filtersState = -1;
                              filtersDistrict = -1;
                              city = null;
                              state = null;
                            });
                          },
                        )
                      : Container(),
                ],
              ),
            ),
            fetched == true
                ? Container()
                : SizedBox(
                    height: 30,
                  ),
            fetched == true
                ? Container()
                : InkWell(
                    onTap: () async {
                      _permissionGranted = await location.hasPermission();
                      if (_permissionGranted == PermissionStatus.denied) {
                        _permissionGranted = await location.requestPermission();
                        if (_permissionGranted != PermissionStatus.granted) {
                          toastCommon(context,
                              getTranslated(context, 'location_permission'));
                          permisson.openAppSettings();
                        } else if (_permissionGranted ==
                            PermissionStatus.granted) {
                          showAlertDialog(context);
                        }
                      } else if (_permissionGranted ==
                          PermissionStatus.granted) {
                        showAlertDialog(context);
                      }
                    },
                    child: Center(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xffEBEBEB),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_searching,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              getTranslated(context, 'use_my_device_location'),
                              style: GoogleFonts.poppins(
                                fontSize: getProportionateScreenHeight(18),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            /*    fetched == true
                ? Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: screenWidth / 15, right: screenWidth / 15),
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff007105)),
                        color: Color(0xff60C164),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Location fetched successfully",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),*/
            fetched == false
                ? SizedBox(
                    height: 20,
                  )
                : SizedBox(
                    height: 1,
                  ),
            fetched == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: getProportionateScreenWidth(65),
                        height: 1,
                        color: Color(0xff08763F),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'or'),
                        style: GoogleFonts.poppins(color: Color(0xff08763F)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: getProportionateScreenWidth(65),
                        height: 1,
                        color: Color(0xff08763F),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 1,
                  ),
            fetched == false
                ? SizedBox(
                    height: 20,
                  )
                : SizedBox(
                    height: 1,
                  ),
            fetched == false
                ? Center(
                    child: Text(
                      getTranslated(context, 'enter_manually'),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 1,
                  ),
            SizedBox(
              height: 3,
            ),
            fetched == false
                ? Center(
                    child: Text(
                      getTranslated(context, 'applicable_for_india_only'),
                      style: GoogleFonts.poppins(
                        color: Color(0xffBCBCBC),
                        fontSize: 10,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 1,
                  ),
            fetched == false
                ? SizedBox(
                    height: 10,
                  )
                : SizedBox(
                    height: 1,
                  ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Material(
                  color: Colors.white,
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.grey, width: 1),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              fetched == true
                                  ? Text(
                                      state,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    )
                                  : Text(
                                      filtersState == -1
                                          ? "Select State"
                                          : StatesListTitles.elementAt(
                                              filtersState),
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                            ],
                          ),
                          fetched == true
                              ? SizedBox(
                                  width: 1,
                                )
                              : Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.grey.shade600,
                                  size: 25,
                                ),
                        ],
                      )),
                ),
              ),
              onTap: () {
                fetched == false ? _showListState(context) : print("feched");
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Material(
                  color: Colors.white,
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.grey, width: 1),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              fetched == true
                                  ? Text(
                                      city,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    )
                                  : Text(
                                      filtersDistrict == -1
                                          ? "Select District"
                                          : DistrictList.elementAt(
                                              filtersDistrict),
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                            ],
                          ),
                          fetched == true
                              ? SizedBox(
                                  width: 1,
                                )
                              : Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.grey.shade600,
                                  size: 25,
                                ),
                        ],
                      )),
                ),
              ),
              onTap: () {
                fetched == false ? _showListDistrict(context) : print("feched");
              },
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: getProportionateScreenWidth(258), height: 55),
                child: ElevatedButton(
                  onPressed: () {
                    if (firstNameController.text.length > 0 &&
                        lastNameController.text.length >
                            0 /* &&
                        emailController.text.length > 0*/
                        &&
                        state != null &&
                        state != "" &&
                        city != null &&
                        city != "") {
                      widget.city == null
                          ? widget.image_url == ""
                              ? Register()
                              : RegisterGoogle()
                          : UpdateProfileData();
                    } else {
                      toastCommon(context,
                          getTranslated(context, 'All_fields_are_mandatory'));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF008940),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    getTranslated(context, 'submit'),
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff08763F),
      body: /*Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: buildTopWidget(context),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight / 3 + 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35),
                      topLeft: Radius.circular(35)),
                  color: Colors.white),
              child: buildProfileForm(context),
            ),
          ),
        ],
      )*/Container(
        color: Color(0xFFF3FFF0),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset("assets/icons/greenKisan_Logo.svg",height: getProportionateScreenHeight(80),),
              Container(
                height: 600,
                width: getProportionateScreenWidth(486),
                padding: EdgeInsets.all(getProportionateScreenWidth(32)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1
                    )
                  ]
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildTopWidget(context),
                      buildProfileForm(context)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    fetchLocation() async {
      try {
        _locationData = await location.getLocation();
        print(_locationData.toString());
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          setState(() {
            permission = false;
          });
          print("permission value : " + permission.toString());
        } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          setState(() {
            permission = false;
          });
          print("permission value : " + permission.toString());
        } else {
          print("code : " + e.code);
        }
      }

      setState(() {
        lat = _locationData.latitude.toString();
        long = _locationData.longitude.toString();
      });

      final coordinates =
          new Coordinates(double.parse(lat), double.parse(long));
      addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      first = addresses.first;

      setState(() {
        String pincode =
            first.addressLine.substring(first.addressLine.length - 13);
        pincode = pincode.replaceAll(", India", "");

        if (pincode == "null" || pincode == null) {
          fetched = false;
          filtersState = -1;
          filtersDistrict = -1;
          toastCommon(context, getTranslated(context, 'enter_manually'));
        } else {
          print("pincode" + pincode);
          Provider.of<CustomViewModel>(context, listen: false)
              .GetFromPin(pincode)
              .then((value) async {
            setState(() {
              if (value == "error") {
                fetched = false;
                filtersState = -1;
                filtersDistrict = -1;
                toastCommon(
                  context,
                  getTranslated(context, 'enter_manually'),
                );
              } else {
                GetDetailsFromPin getDetailsFromPin = value;

                if (getDetailsFromPin == null) {
                  city = null;
                  state = null;
                } else {
                  city = getDetailsFromPin.city;
                  state = getDetailsFromPin.state;
                }

                if (city == "null" ||
                    city == null ||
                    state == "null" ||
                    state == null) {
                  fetched = false;
                  filtersState = -1;
                  filtersDistrict = -1;
                  toastCommon(
                    context,
                    getTranslated(context, 'enter_manually'),
                  );
                } else {
                  fetched = true;
                  toastCommon(context,
                      getTranslated(context, 'Location_fetched_successfully'));
                }
              }
            });
          });
        }
      });

      //print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');

      Navigator.of(context).pop();
    }

    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
          child: Container(
              height: 50,
              width: 50,
              child: Center(
                child: /*Image.asset("assets/images/loader.png")*/ NutsActivityIndicator(
                  radius: 20,
                  activeColor: Color(constants.COLOR_BACKGROUND),
                  inactiveColor: Colors.grey,
                  tickCount: 11,
                  startRatio: 0.55,
                  animationDuration: Duration(milliseconds: 2000),
                ),
              ))),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.location_on, color: Color(0xff08763F), size: 15),
          Text(
            getTranslated(context, 'fetch_location'),
            style: GoogleFonts.poppins(
              color: Color(0xff08763F),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        fetchLocation();
        return alert;
      },
    );
  }

  _showListState(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select State',
              style: TextStyle(color: Colors.black),
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: StatesListTitles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      StatesListTitles[index],
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        filtersState = index;
                        state = StatesListTitles[index];
                        DistrictList = distList.elementAt(filtersState);
                        filtersDistrict = -1;
                        city = null;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  _showListDistrict(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select District',
              style: TextStyle(color: Colors.black),
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: DistrictList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      DistrictList[index],
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        filtersDistrict = index;
                        city = DistrictList[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        });
  }
}
