import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/localization/language_constants.dart';

class SearchTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  SearchTabs({this.selectedTab, this.tabPressed});

  @override
  _SearchTabsState createState() => _SearchTabsState();
}

class _SearchTabsState extends State<SearchTabs> {
  int _selectedTabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTabs = widget.selectedTab ?? 0;

    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SearchTabsBtn(
          optName: getTranslated(context, 'products'),
          selected: _selectedTabs == 0 ? true : false,
          onPressed: () {
            widget.tabPressed(0);
          },
        ),
        SizedBox(
          width: getProportionateMobileScreenWidth(50),
        ),
        SearchTabsBtn(
          optName: getTranslated(context, 'companies'),
          selected: _selectedTabs == 1 ? true : false,
          onPressed: () {
            widget.tabPressed(1);
          },
        ),
      ],
    ));
  }
}

class SearchTabsBtn extends StatelessWidget {
  final bool selected;
  final Function onPressed;
  final String optName;

  SearchTabsBtn({this.selected, this.onPressed, this.optName});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: Text(
          optName,
          style: GoogleFonts.poppins(
              fontSize: 16,
              color:_selected? Colors.green:Colors.grey,
              fontWeight: _selected ? FontWeight.bold : FontWeight.w500),
        ),
      ),
    );
  }
}
