import 'package:flutter/material.dart';
import 'package:kisanweb/Helpers/size_config.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    Key key, this.iconData, this.title,
  }) : super(key: key);

  final IconData iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          radius: getProportionateScreenHeight(30),
          child: Icon(
            iconData,
            color: Colors.white,
            size: getProportionateScreenWidth(25),
          ),
        ),
        SizedBox(width: getProportionateScreenWidth(16),),
        Text(title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenHeight(20)
          ),
        )
      ],
    );
  }
}