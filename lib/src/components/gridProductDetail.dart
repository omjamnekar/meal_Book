import 'package:MealBook/controller/comboLogic.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/components/addCartDownPop.dart';
import 'package:MealBook/src/components/asynceChecker.dart';
import 'package:MealBook/src/components/navigateTodetail.dart';
import 'package:MealBook/src/pages/proD/productDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class GridProductRecommend extends StatelessWidget {
  GridProductRecommend({
    super.key,
    required this.recData,
  });

  List<dynamic> recData;

  ComboLogic combo = ComboLogic();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: recData.length > 2
          ? (recData.length * 230) / 2
          : (recData.length * 230),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        itemCount: recData.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          return FutureBuilder(
              future: combo.fullDataImage(
                  recData[index]["TYPE"], recData[index]["IMAGE"]),
              builder:
                  (BuildContext context, AsyncSnapshot<String> imageProduct) {
                return AsyncDataChecker().checkWidgetBinding(
                    widget: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken),
                            image: NetworkImage(imageProduct.data ??
                                "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
                            fit: BoxFit.cover),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer
                                .withOpacity(0.1),
                            width: 0.3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                recData[index]["ITEMS"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                                width: double.maxFinite,
                                height: 94,
                                color: Theme.of(context).colorScheme.background,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${recData[index]["RATE"]}Rs",
                                            style: GoogleFonts.poppins(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                          Spacer(),
                                          Icon(
                                            size: 25,
                                            Icons.arrow_drop_down_sharp,
                                            color: recData[index]["IS_VEG"] ==
                                                    "true"
                                                ? Colors.green
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                          ),
                                          Text(
                                              recData[index]["IS_VEG"] == "true"
                                                  ? "Veg"
                                                  : "Non-Veg")
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.maxFinite,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await AddCartDownPop.show(
                                                  context,
                                                  recData[index]["ITEMS"],
                                                  recData[index]["DESCRIPTION"],
                                                  () => {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 20),
                                              child: Text(
                                                "Add+ ",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Combo _combo = Combo(
                                                id: recData[index]["ID"],
                                                items: recData[index]["ITEMS"],
                                                rate: recData![index]["RATE"],
                                                description: recData[index]
                                                    ["DESCRIPTION"],
                                                category: recData[index]
                                                    ["CATEGORY"],
                                                available: recData[index]
                                                            ["AVAILABLE"] ==
                                                        'true'
                                                    ? true
                                                    : false,
                                                likes: recData[index]["LIKES"],
                                                isPopular: recData[index]
                                                            ["POPULAR"] ==
                                                        'true'
                                                    ? true
                                                    : false,
                                                overallRating: recData[index]
                                                    ["OVERALL_RATING"],
                                                image: recData[index]["IMAGE"],
                                                isVeg: recData[index]
                                                            ["IS_VEG"] ==
                                                        'true'
                                                    ? true
                                                    : false,
                                                type: recData[index]["TYPE"],
                                                ingredients: List<String>.from(
                                                    recData[index]
                                                        ["INGREDIENTS"]),
                                              );

                                              NavigatorToDetail()
                                                  .navigatorToProDetail(context,
                                                      [_combo], recData);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 20),
                                              child: Text("Order"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    loadingWidget: Container(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer
                                .withOpacity(0.2),
                            width: 1),
                      ),
                    ),
                    snapshot: imageProduct,
                    afterBindingFunction: () {});
              });
        },
      ),
    );
  }
}
