import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

//These are the bottom tabs for the product grid page

class ProductFoundButtonNavBar extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  ProductFoundButtonNavBar({this.selectedTab, this.tabPressed});

  @override
  _ProductFoundButtonNavBarState createState() => _ProductFoundButtonNavBarState();
}

class _ProductFoundButtonNavBarState extends State<ProductFoundButtonNavBar> {
  int _selectedTabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTabs = widget.selectedTab ?? 0;

    return Container(
        height: 55,
        width: 350,
        decoration: BoxDecoration(
            color: Color(COLOR_BACKGROUND),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Color(COLOR_ACCENT).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 2,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomTabBtn(
              svgPath: "assets/icons/products.svg",
              optName: getTranslated(context, 'products'),
              selected: _selectedTabs == 0 ? true : false,
              onPressed: () {
                widget.tabPressed(0);
              },
            ),
            BottomTabBtn(
              svgPath: "assets/icons/companies.svg",
              optName: getTranslated(context, 'companies'),
              selected: _selectedTabs == 1 ? true : false,
              onPressed: () {
                widget.tabPressed(2);
                //widget.tabPressed(3);
              },
            ),
          ],
        ));
  }
}

class ProductFoundMobileButtonNavBar extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  ProductFoundMobileButtonNavBar({this.selectedTab, this.tabPressed});

  @override
  _ProductFoundMobileButtonNavBar createState() => _ProductFoundMobileButtonNavBar();
}

class _ProductFoundMobileButtonNavBar extends State<ProductFoundMobileButtonNavBar> {
  int _selectedTabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTabs = widget.selectedTab ?? 0;

    return Container(
        height: 55,
        width: 350,
        decoration: BoxDecoration(
            color: Color(COLOR_BACKGROUND),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),),
            boxShadow: [
              BoxShadow(
                color: Color(COLOR_ACCENT).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 2,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomTabBtn(
              svgPath: "assets/icons/products.svg",
              optName: getTranslated(context, 'products'),
              selected: _selectedTabs == 0 ? true : false,
              onPressed: () {
                widget.tabPressed(0);
              },
            ),
            BottomTabBtn(
              svgPath: "assets/icons/companies.svg",
              optName: getTranslated(context, 'companies'),
              selected: _selectedTabs == 1 ? true : false,
              onPressed: () {
                widget.tabPressed(2);
                //widget.tabPressed(3);
              },
            ),
          ],
        ));
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
              width: ResponsiveWidget.isSmallScreen(context)? getProportionateMobileScreenWidth(25) : getProportionateScreenWidth(25),
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(
              optName ,
              style: GoogleFonts.poppins(
                  fontWeight: _selected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 15,
                  color: selected ? Colors.white : Colors.white.withOpacity(0.5)),
            )
          ],
        ),
      ),
    );
  }
}
