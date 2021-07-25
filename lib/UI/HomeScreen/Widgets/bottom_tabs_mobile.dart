import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../HomeScreen.dart';

class BottomTabsMobile extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  BottomTabsMobile({this.selectedTab, this.tabPressed});

  @override
  _BottomTabsMobileState createState() => _BottomTabsMobileState();
}

class _BottomTabsMobileState extends State<BottomTabsMobile> {
  int _selectedTabs;

  @override
  void initState() {
    super.initState();
  }

  OverlayEntry _overlayEntry;
  bool isMenuOpen = false;
  AnimationController _animationController;

  /*void closeMenu() {
    _overlayEntry.remove();
    _animationController.reverse();
    print("Entry Closed");
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    _animationController.forward();
    overlayEntry = overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    print("Entry Opened");
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: getProportionateScreenHeight(560),
          left: 20,
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.3))
                ]),
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: GridView.count(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2,
                mainAxisSpacing: getProportionateScreenHeight(10),
                children: [
                  OptionButton(
                    imgPath: "assets/icons/Offers.svg",
                    onPressed: () {
                      print("Offer");
                    },
                  ),
                  OptionButton(
                    imgPath: "assets/icons/Webinar.svg",
                    onPressed: () {
                      print("Webinar");
                    },
                  ),
                  OptionButton(
                    imgPath: "assets/icons/Demo.svg",
                    onPressed: () {
                      print("Demos");
                    },
                  ),
                  OptionButton(
                    imgPath: "assets/icons/Launch.svg",
                    onPressed: () {
                      print("Launch");
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }*/

  showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: getProportionateMobileScreenHeight(560),
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(
                horizontal: getProportionateMobileScreenWidth(20)),
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.3))
                ]),
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: GridView.count(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2,
                mainAxisSpacing: getProportionateScreenHeight(10),
                children: [
                  OptionButton(
                    imgPath: "assets/icons/Offers.svg",
                    onPressed: () {
                      print("Offer");
                    },
                  ),
                  OptionButton(
                    imgPath: "assets/icons/Webinar.svg",
                    onPressed: () {
                      print("Webinar");
                    },
                  ),
                  OptionButton(
                    imgPath: "assets/icons/Demo.svg",
                    onPressed: () {
                      print("Demos");
                    },
                  ),
                  OptionButton(
                    imgPath: "assets/icons/Launch.svg",
                    onPressed: () {
                      print("Launch");
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 3));
    overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTabs = widget.selectedTab ?? 0;

    final providerListener = Provider.of<CustomViewModel>(context);

    return Container(
        height:getProportionateMobileScreenHeight(65),
        width: getProportionateMobileScreenWidth(370),
        margin: EdgeInsets.only(
            left: getProportionateMobileScreenWidth(20),
            right: getProportionateMobileScreenWidth(20),
            bottom: getProportionateMobileScreenWidth(20)),
        decoration: BoxDecoration(
            color: Color(COLOR_BACKGROUND),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color(COLOR_ACCENT).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 1,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomTabBtn(
              svgPath: "assets/icons/home.svg",
              optName: getTranslated(context, 'home'),
              selected: _selectedTabs == 0 ? true : false,
              onPressed: () {
                widget.tabPressed(0);
                Provider.of<CustomViewModel>(context, listen: false)
                    .GetFeaturedProducts();
                Provider.of<CustomViewModel>(context, listen: false)
                    .GetFeaturedCompanies();
              },
            ),
            BottomTabBtn(
              svgPath: "assets/icons/webinarOptIcon.svg",
              optName: getTranslated(context, 'webinar'),
              selected: _selectedTabs == 1 ? true : false,
              onPressed: () {
                //showOverlay(context);
                widget.tabPressed(1);
                //push(context, ViewAllWebinars(false, providerListener.userprofileData.user.toString()));
              },
            ),
            BottomTabBtn(
              svgPath: "assets/icons/shortlisticon.svg",
              optName: "Shortlisted",
              selected: _selectedTabs == 2 ? true : false,
              onPressed: () {
                widget.tabPressed(2);
              },
            ),
            BottomTabBtn(
              svgPath: "assets/icons/callHistoryIcon.svg",
              optName: "History",
              selected: _selectedTabs == 3 ? true : false,
              onPressed: () {
                widget.tabPressed(3);
                //widget.tabPressed(3);
              },
            ),
          ],
        ));
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({
    Key key,
    this.logoColor,
    this.backColor,
    this.text,
    this.imgPath,
    this.onPressed,
  }) : super(key: key);

  final Color logoColor, backColor;
  final String text, imgPath;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imgPath,
              width: 55,
              color: logoColor,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final bool selected;
  final Function onPressed;
  final String optName;
  final String svgPath;

  BottomTabBtn({this.selected, this.onPressed, this.optName, this.svgPath});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              color: _selected ? Colors.white : Colors.white.withOpacity(0.5),
              width: getProportionateMobileScreenWidth(25),
            ),
            SizedBox(

              width: getProportionateMobileScreenWidth(8),
            ),
            Text(
              _selected ? optName : "",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: getProportionateMobileScreenHeight(15),
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}