import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/UI/Categories/components/productFoundBottombar.dart';
import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/UI/SearchScreen/SearchScreen.dart';
import 'package:kisanweb/UI/Tabs/HomeTab.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';

class productsFound extends StatefulWidget {
  final title, searchString;

  List<int> ids;

  productsFound(this.title, this.ids, this.searchString);

  @override
  _productsFoundState createState() => _productsFoundState();
}

class _productsFoundState extends State<productsFound> {
  bool _isProductLoaded = false;
  bool _isCompaniesLoaded = false;

  PageController _tabPageController;
  int _selectedTab = 0;

  Future<void> initTask() async {
    Provider.of<CustomViewModel>(context, listen: false)
        .GetProductsByCategoryIdsAndSearchString(
            widget.ids, widget.searchString)
        .then((value) {
      setState(() {
        _isProductLoaded = true;
      });

      Provider.of<CustomViewModel>(context, listen: false)
          .GetCompaniesByCategoryIdsAndSearchString(
              widget.ids, widget.searchString)
          .then((value) {
        setState(() {
          _isCompaniesLoaded = true;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabPageController = PageController();
    initTask();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final providerListener = Provider.of<CustomViewModel>(context);
    return _isProductLoaded == true
        ? Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 200),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BackButton(),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: getProportionateScreenWidth(240),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            (providerListener.productsCouts.products ?? 0)
                                    .toString() +
                                "  " +
                                getTranslated(context, 'products')
                                    .toString() +
                                " | " +
                                (providerListener.productsCouts.companies ??
                                        0)
                                    .toString() +
                                " " +
                                getTranslated(context, 'companies')
                                    .toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      color: Colors.white,
                      child: ProductFoundButtonNavBar(
                        selectedTab: _selectedTab,
                        tabPressed: (num) {
                          _tabPageController.animateToPage(num,
                              duration: Duration(
                                  milliseconds: ANIMATION_DURATION),
                              curve: Curves.easeOutCubic);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            /*bottomNavigationBar: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ProductFoundButtonNavBar(
                  selectedTab: _selectedTab,
                  tabPressed: (num) {
                    _tabPageController.animateToPage(num,
                        duration: Duration(milliseconds: ANIMATION_DURATION),
                        curve: Curves.easeOutCubic);
                  },
                ),
              ),
            ),*/
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 200),
              child: PageView(
                controller: _tabPageController,
                onPageChanged: (num) {
                  setState(() {
                    _selectedTab = num;
                  });
                },
                children: [
                  providerListener.productsListbycatidsandsearchstring.length >
                          0
                      ? Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: (providerListener
                                  .productsListbycatidsandsearchstring.length /
                              2.ceil() *
                              210),
                          child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: providerListener
                                  .productsListbycatidsandsearchstring.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 40,
                                      childAspectRatio: 0.9,
                                      mainAxisSpacing: 40),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[200],
                                          blurRadius: 1,
                                          spreadRadius: 1)
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      push(
                                          context,
                                          DetailedProducts(
                                              providerListener
                                                  .productsListbycatidsandsearchstring[
                                                      index]
                                                  .id,
                                              providerListener
                                                  .productsListbycatidsandsearchstring[
                                                      index]
                                                  .user_id));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              color: Colors.green[700],
                                              image: DecorationImage(
                                                image: providerListener
                                                            .productsListbycatidsandsearchstring[
                                                                index]
                                                            .media_url ==
                                                        null
                                                    ? AssetImage(
                                                        "assets/images/product_placeholder.png")
                                                    : NetworkImage(
                                                        providerListener
                                                            .productsListbycatidsandsearchstring[
                                                                index]
                                                            .media_url),
                                                fit: BoxFit.cover,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey[200],
                                                    blurRadius: 1,
                                                    spreadRadius: 1)
                                              ],
                                            ),
                                            height: getProportionateScreenHeight(200),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          height: getProportionateScreenHeight(90),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                providerListener
                                                    .productsListbycatidsandsearchstring[
                                                        index]
                                                    .title_english,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                parseHtmlString(providerListener
                                                    .productsListbycatidsandsearchstring[
                                                        index]
                                                    .organisation_name),
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.grey[700],
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  /* CallHistory(),*/
                  providerListener
                              .companiessListbycatidsandsearchstring.length >
                          0
                      ? Container(
                          height: (providerListener
                                  .companiessListbycatidsandsearchstring.length
                                  .toDouble() *
                              120),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 40,
                                  childAspectRatio: 466/121,
                                  mainAxisSpacing: 40),
                              itemCount: providerListener
                                  .companiessListbycatidsandsearchstring.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: Container(
                                    width: screenWidth,
                                    height: getProportionateScreenHeight(100),
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[200],
                                            blurRadius: 2,
                                            spreadRadius: 1)
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height:
                                              getProportionateScreenHeight(100),
                                          width:
                                              getProportionateScreenWidth(115),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(providerListener
                                                        .companiessListbycatidsandsearchstring[
                                                            index]
                                                        .image_bigthumb_url ??
                                                    ""),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  getProportionateScreenWidth(
                                                      221),
                                              child: Text(
                                                providerListener
                                                    .companiessListbycatidsandsearchstring[
                                                        index]
                                                    .organisation_name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image,
                                                  size: 15,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  providerListener
                                                      .companiessListbycatidsandsearchstring[
                                                          index]
                                                      .products
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    push(
                                        context,
                                        CompanyDetails(providerListener
                                            .companiessListbycatidsandsearchstring[
                                                index]
                                            .user_id));
                                  },
                                );
                              }),
                        )
                      : SizedBox(
                          height: 10,
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

class ShareButton extends StatelessWidget {
  const ShareButton({
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
            //padding: EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          push(context, SearchScreen());
        },
        child: Icon(
          Icons.search,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
                onPageChanged: (index, onTap) {
                  setState(() {
                    currentS = index;
                  });
                  print(currentS.toString());
                },
                height: 200,
                autoPlay: true,
                viewportFraction: 1,
                autoPlayAnimationDuration: Duration(milliseconds: 700)),
            items: providerListener.productsImages.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: getProportionateScreenWidth(378),
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: NetworkImage(item), fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[200],
                              offset: const Offset(
                                2.0,
                                3.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            )
                          ],
                          color: Colors.amber),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: providerListener.productsImages.map((url) {
                  int index = providerListener.productsImages.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentS == index
                          ? Colors.grey[700]
                          : Colors.grey[300],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
