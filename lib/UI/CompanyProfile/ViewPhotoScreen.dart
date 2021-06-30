import 'package:flutter/material.dart';
import 'package:kisanweb/Helpers/helper.dart';
class ViewPhotos extends StatelessWidget {

  final String url;


  ViewPhotos({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BackButton(),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(url),fit: BoxFit.fitWidth
              )
            ),
          ),
        ),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: 55,
        height: 55,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}
