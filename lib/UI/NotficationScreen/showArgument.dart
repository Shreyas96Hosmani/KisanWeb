import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:kisanweb/Helpers/constants.dart';

class ShowArgument extends StatelessWidget {
  final ReceivedAction receivedAction;

  const ShowArgument({Key key, this.receivedAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(COLOR_BACKGROUND),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: BackButton(),
            title: Text(
              "Payload",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins Bold',
                  color: Colors.black),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'buttonKeyPressed=>${receivedAction.buttonKeyPressed}',
              style: TextStyle(fontSize: 25),
            ),
            Text('title=>${receivedAction.title}'),
            Text('body=>${receivedAction.body}'),
            Text('actionDate=>${receivedAction.actionDate}'),
            Text('id=>${receivedAction.id}'),
            Text('payLoad=>${receivedAction.payload}'),
            Text('summary=>${receivedAction.summary}'),
            Text('bigPicture=>${receivedAction.bigPicture}'),
          ],

        ),
      ),
    );
  }
}
