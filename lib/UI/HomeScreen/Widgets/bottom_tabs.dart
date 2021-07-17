import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/Tabs/HomeTab.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  BottomTabs({this.selectedTab, this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
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
    _overlayEntry = _overlayEntryBuilder();
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
          top: getProportionateScreenHeight(560),
          width: MediaQuery.of(context).size.width,
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

    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 3));
    overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTabs = widget.selectedTab ?? 0;

    return Container(
        child: Column(
          children: [
            BottomTabBtn(
              svgPath: "assets/icons/home.svg",
              optName: getTranslated(context, 'home'),
              selected: _selectedTabs == 0 ? true : false,
              onPressed: () {
                widget.tabPressed(0);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
            ),
            BottomTabBtn(
              svgPath: "assets/icons/webinarOptIcon.svg",
              optName: "Webinar",
              selected: _selectedTabs == 1 ? true : false,
              onPressed: () {
                //showOverlay(context);
                widget.tabPressed(1);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
            ),
            BottomTabBtn(
              svgPath: "assets/icons/shortlisticon.svg",
              optName: "Shortlisted",
              selected: _selectedTabs == 2 ? true : false,
              onPressed: () {
                widget.tabPressed(2);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(height: 1.5,color: Colors.white.withOpacity(0.3),),
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
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: ListTile(
          visualDensity: VisualDensity(vertical: -1, horizontal: 0),
          title: Row(
            children: [
              SvgPicture.asset(
                svgPath,
                color: _selected ? Colors.white : Colors.white.withOpacity(0.5),
                height: getProportionateScreenHeight(25),
              ),
              SizedBox(width: getProportionateScreenWidth(10),),
              Text(
                optName,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontSize: getProportionateScreenHeight(15),
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
