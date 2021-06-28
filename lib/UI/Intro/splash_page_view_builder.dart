import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/Intro/splash_four.dart';
import 'package:kisanweb/UI/Intro/splash_one.dart';
import 'package:kisanweb/UI/Intro/splash_three.dart';
import 'package:kisanweb/UI/Intro/splash_two.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:provider/provider.dart';

CarouselController buttonCarouselController = CarouselController();

bool showSkip = true;
int current = 0;
List<Widget> list = [
  SplashOne(),
  SplashTwo(),
  SplashThree(),
  SplashFour(),
];

class SplashPageViewBuilder extends StatefulWidget {
  @override
  _SplashPageViewBuilderState createState() => _SplashPageViewBuilderState();
}

class _SplashPageViewBuilderState extends State<SplashPageViewBuilder> {
  List<Slide> slides = new List();

  bool _isloaded = false;

  Future<void> initTask() async {
    setState(() {
      _isloaded = false;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .Getkisannet()
        .then((value) {
      setState(() {
        if (value == "error") {
        } else if (value == "success") {
          _isloaded = true;
        } else {}
      });
    });
  }

  void onDonePress() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTask();
    showSkip = true;
    slides.add(
      new Slide(
        centerWidget: SplashOne(),
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        centerWidget: SplashTwo(),
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        centerWidget: SplashThree(),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isloaded == true
        ? Container(
            height: MediaQuery.of(context).size.height,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: CarouselSlider.builder(
                      itemCount: 4,
                      carouselController: buttonCarouselController,
                      options: CarouselOptions(
                          viewportFraction: 1,
                          height: MediaQuery.of(context).size.height,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
//                    autoPlay: false,
//                    autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 100),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              current = index;
                            });
                            if (index == 2) {
                              setState(() {
                                showSkip = false;
                              });
                            } else if (index == 0 || index == 1) {
                              setState(() {
                                showSkip = true;
                              });
                            }
                          }),
                      itemBuilder: (BuildContext context, int itemIndex) =>
                          itemIndex == 0
                              ? SplashOne()
                              : itemIndex == 1
                                  ? SplashTwo()
                                  : itemIndex == 2
                                      ? SplashThree()
                                      : SplashFour(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: list.map((url) {
                          int index = list.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 3.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: current == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: SizeConfig.screenHeight,
            color: Colors.white,
            child: Center(
              child: new CircularProgressIndicator(
                strokeWidth: 1,
                backgroundColor: Color(COLOR_PRIMARY),
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
              ),
            ),
          );
  }
}
