import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisanweb/Helpers/constants.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/Helpers/size_config.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/Categories/components/productFoundBottombar.dart';
import 'package:kisanweb/UI/CompanyProfile/CompanyProfile.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:kisanweb/localization/language_constants.dart';
import 'package:provider/provider.dart';

class productsFound extends StatefulWidget {
  final event_id, title, company_id;

  List<int> ids;

  productsFound(this.event_id, this.title, this.ids, this.company_id);

  @override
  _productsFoundState createState() => _productsFoundState();
}

class _productsFoundState extends State<productsFound> {
  bool _isProductLoaded = false;
  bool _isCompaniesLoaded = false;

  PageController _tabPageController;
  int _selectedTab = 0;

  bool _isSearchBarOpen = false;
  TextEditingController searchTextController = new TextEditingController();

  FocusNode focusSearch = FocusNode();

  int pageCount = 1;
  bool isLoading = false;

  int pageCountC = 1;
  bool isLoadingC = false;

  Future<void> initTask() async {
    setState(() {
      _isProductLoaded = false;
    });
    Provider.of<CustomViewModel>(context, listen: false)
        .GetProductsByCategoryIdsAndSearchString(0, widget.event_id, widget.ids,
            searchTextController.text ?? "", widget.company_id)
        .then((value) {
      setState(() {
        _isProductLoaded = true;
      });

      Provider.of<CustomViewModel>(context, listen: false)
          .GetCompaniesByCategoryIdsAndSearchString(0, widget.event_id,
              widget.ids, searchTextController.text ?? "", widget.company_id)
          .then((value) {
        setState(() {
          _isCompaniesLoaded = true;
        });
      });
    });
  }

  Future<bool> _loadProducts() async {
    setState(() {
      isLoading = true;
      pageCount = pageCount + 1;
    });

    print("AppendProductsForSearch");
    Provider.of<CustomViewModel>(context, listen: false)
        .AppendProductsForSearch(widget.event_id, widget.ids,
            (searchTextController.text ?? ""), pageCount, widget.company_id)
        .then((value) {
      setState(() {
        isLoading = false;
        /*if (value == "No more items") {
          toastCommon(context, "No more items!");
        }*/
      });
    });
  }

  Future<bool> _loadCompanies() async {
    setState(() {
      isLoadingC = true;
      pageCountC = pageCountC + 1;
    });

    print("AppendCompaniesForSearch");
    Provider.of<CustomViewModel>(context, listen: false)
        .AppendCompaniesForSearch(widget.event_id, widget.ids,
            (searchTextController.text ?? ""), pageCountC, widget.company_id)
        .then((value) {
      setState(() {
        isLoadingC = false;
        /*if (value == "No more items") {
          toastCommon(context, "No more items!");
        }*/
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
            appBar:ResponsiveWidget.isSmallScreen(context) ?
            PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: _isSearchBarOpen == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BackButton(),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: getProportionateMobileScreenWidth(240),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.company_id==0?widget.title:_selectedTab==0?widget.title:getTranslated(context, 'companies'),
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    (providerListener.productsCouts.products ??
                                                0)
                                            .toString() +
                                        "  " +
                                        getTranslated(context, 'products')
                                            .toString() +
                                        " | " +
                                        (providerListener
                                                    .productsCouts.companies ??
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
                            ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                width: 55,
                                height: 55,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    //padding: EdgeInsets.symmetric(horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: () {
                                  setState(() {
                                    _isSearchBarOpen = true;
                                    focusSearch.requestFocus();
                                  });
                                },
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                focusNode: focusSearch,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 14),
                                decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  fillColor: Colors.grey.shade100,
                                  prefixIcon: InkWell(
                                    onTap: () {
                                      if (_isSearchBarOpen == true) {
                                        setState(() {
                                          _isSearchBarOpen = false;
                                          searchTextController.clear();
                                        });
                                        // searchResults("");
                                        initTask();
                                      } else {
                                        pop(context);
                                      }
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ),
                                  suffixIconConstraints:
                                      BoxConstraints.tightFor(height: 50),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        searchTextController.clear();
                                      });
                                      //searchResults("");
                                      // initTask();
                                    },
                                    child: Padding(
                                        padding:
                                            EdgeInsetsDirectional.only(end: 10),
                                        child: Icon(
                                          Icons.clear,
                                          size: 30,
                                        )),
                                  ),
                                ),
                                /*onChanged: (value) {

                                },*/
                                onEditingComplete: () {
                                  /*searchResults(
                                      searchTextController.text.toString());*/
                                  initTask();
                                  focusSearch.unfocus();
                                },
                                controller: searchTextController,
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ) : PreferredSize(
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
            floatingActionButton: _selectedTab == 0
                ? providerListener.canLoadMoreProducts == true
                    ? Container(
                        margin: EdgeInsets.only(left: 20),
                        padding: EdgeInsets.only(bottom: 10.0, right: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              _loadProducts();
                            },
                            backgroundColor: Color(COLOR_BACKGROUND),
                            label: Text(isLoading == false
                                ? "Load more"
                                : "Loading..."),
                          ),
                        ),
                      )
                    : null
                : providerListener.canLoadMoreCompanies == true
                    ? Container(
                        margin: EdgeInsets.only(left: 20),
                        padding: EdgeInsets.only(bottom: 10.0, left: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              _loadCompanies();
                            },
                            backgroundColor: Color(COLOR_BACKGROUND),
                            label: Text(isLoadingC == false
                                ? "Load more"
                                : "Loading..."),
                          ),
                        ),
                      )
                    : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: ResponsiveWidget.isSmallScreen(context) ?
             Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ProductFoundMobileButtonNavBar(
                  selectedTab: _selectedTab,
                  tabPressed: (num) {
                    _tabPageController.animateToPage(num,
                        duration: Duration(milliseconds: ANIMATION_DURATION),
                        curve: Curves.easeOutCubic);
                  },
                ),
              ),
            ) :
            null,
            body: Container(
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
                      ? ResponsiveWidget.isSmallScreen(context) ? Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: (providerListener
                                  .productsListbycatidsandsearchstring.length /
                              2.ceil() *
                              200),
                          child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: providerListener
                                  .productsListbycatidsandsearchstring.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 30,
                                      mainAxisSpacing: 20),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      width: 150,
                                      height: 200,
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
                                            Container(
                                              height: 110,
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
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
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
                                                      fontSize: 14,
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
                                    ));
                              }),
                        ) :
                        Container(
                    padding: const EdgeInsets.only(left: 200, right: 200),
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
                          padding: ResponsiveWidget.isSmallScreen(context) ? EdgeInsets.symmetric(horizontal: 20) : EdgeInsets.symmetric(horizontal: 200),
                          child: ResponsiveWidget.isSmallScreen(context) ?
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              primary: false,
                              shrinkWrap: true,
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
                                              getProportionateMobileScreenWidth(115),
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
                                                  getProportionateMobileScreenWidth(
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
                              }) : GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  primary: false,
                                  shrinkWrap: true,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 466/121,
                                      mainAxisSpacing: 20),
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
