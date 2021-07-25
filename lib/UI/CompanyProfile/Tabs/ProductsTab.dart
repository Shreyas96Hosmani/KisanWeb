import 'package:flutter/material.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:kisanweb/ResponsivenessHelper/responsive.dart';
import 'package:kisanweb/UI/DetailedScreens/DetailedProducts.dart';
import 'package:kisanweb/View%20Models/CustomViewModel.dart';
import 'package:provider/provider.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    return ResponsiveWidget.isSmallScreen(context) ?
    Container(
        height: ((providerListener.companyDetailsProductsList.length/2).ceil().toDouble() * 220)+120,
        padding: EdgeInsets.all(20),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: (170 / 190),
            ),
            itemCount: providerListener.companyDetailsProductsList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GridProds(
                name: providerListener
                    .companyDetailsProductsList[index].title_english,
                desc: parseHtmlString(/*providerListener
                    .companyDetailsProductsList[index].desc_english*/
                    providerListener.companyDetails.organisation_name??""),
                imgPath: providerListener
                    .companyDetailsProductsList[index].bigthumb_url,
                onPressed: () {
                  push(context, DetailedProducts(providerListener
                      .companyDetailsProductsList[index].id, providerListener
                      .companyDetailsProductsList[index].user_id));
                },
              );
            },
          ),
        )) :
    Container(
        height: ((providerListener.companyDetailsProductsList.length/4).ceil().toDouble() * 220)+120,
        padding: EdgeInsets.all(20),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: (170 / 190),
            ),
            itemCount: providerListener.companyDetailsProductsList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GridProds(
                name: providerListener
                    .companyDetailsProductsList[index].title_english,
                desc: parseHtmlString(/*providerListener
                    .companyDetailsProductsList[index].desc_english*/
                    providerListener.companyDetails.organisation_name??""),
                imgPath: providerListener
                    .companyDetailsProductsList[index].bigthumb_url,
                onPressed: () {
                  /*push(context, DetailedProducts(providerListener
                      .companyDetailsProductsList[index].id, providerListener
                      .companyDetailsProductsList[index].user_id));*/
                },
              );
            },
          ),
        ));
  }
}
