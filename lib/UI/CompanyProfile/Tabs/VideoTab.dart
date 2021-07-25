import 'package:flutter/material.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/DetailedScreens/VideoScreen.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:provider/provider.dart';

class VideosTab extends StatelessWidget {
  const VideosTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return ResponsiveWidget.isSmallScreen(context) ?  Container(
        height: (providerListener.companyDetailsVideos.length *
            300).toDouble() + 100,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
              itemCount: providerListener.companyDetailsVideos.length,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    push(context, SamplePlayer(null, providerListener.companyDetailsVideos[index].media_url));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                    height: getProportionateScreenHeight(300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 6)
                        ]),
                    child: Stack(
                      children: [
                        Container(
                          width: getProportionateMobileScreenWidth(378),
                          margin:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          decoration: BoxDecoration(
                            /*boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200],
                            offset: const Offset(
                              2.0,
                              3.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          )
                        ],*/
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green[700],
                            image: DecorationImage(
                                image: NetworkImage(providerListener
                                    .companyDetailsVideos[index]
                                    .bigthumb_url ??
                                    ""),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Center(
                          child: Opacity(
                            opacity: 0.7,
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        )) :
    Container(
        height: (providerListener.companyDetailsVideos.length *
            300).toDouble() + 100,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: (355 / 270),
              ),
              itemCount: providerListener.companyDetailsVideos.length,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    push(context, SamplePlayer(null, providerListener.companyDetailsVideos[index].media_url));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                    height: getProportionateScreenHeight(300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 6)
                        ]),
                    child: Stack(
                      children: [
                        Container(
                          width: getProportionateScreenWidth(378),
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          decoration: BoxDecoration(
                            /*boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200],
                            offset: const Offset(
                              2.0,
                              3.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          )
                        ],*/
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green[700],
                            image: DecorationImage(
                                image: NetworkImage(providerListener
                                        .companyDetailsVideos[index]
                                        .bigthumb_url ??
                                    ""),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Center(
                          child: Opacity(
                            opacity: 0.7,
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
