import 'package:MealBook/controller/comboLogic.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/components/add_Cart_DownPop.dart';
import 'package:MealBook/src/components/asynceChecker.dart';
import 'package:MealBook/src/components/navigateTodetail.dart';
import 'package:MealBook/src/pages/cart/cartMode.dart';
import 'package:MealBook/src/pages/proD/productDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class GridProductRecommend extends ConsumerStatefulWidget {
  GridProductRecommend({
    super.key,
    required this.recData,
  });

  List<dynamic> recData;

  @override
  ConsumerState<GridProductRecommend> createState() =>
      _GridProductRecommendState();
}

class _GridProductRecommendState extends ConsumerState<GridProductRecommend> {
  ComboLogic combo = ComboLogic();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.recData.length > 2
          ? (widget.recData.length * 230) / 2
          : (widget.recData.length * 230),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        itemCount: widget.recData.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          return FutureBuilder(
              future: combo.fullDataImage(widget.recData[index]["TYPE"],
                  widget.recData[index]["IMAGE"], (image) {}),
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
                                widget.recData[index]["ITEMS"],
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
                                            "${widget.recData[index]["RATE"]}Rs",
                                            style: GoogleFonts.poppins(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                          Spacer(),
                                          Icon(
                                            size: 25,
                                            Icons.arrow_drop_down_sharp,
                                            color: widget.recData[index]
                                                        ["IS_VEG"] ==
                                                    "true"
                                                ? Colors.green
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                          ),
                                          Text(widget.recData[index]
                                                      ["IS_VEG"] ==
                                                  "true"
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
                                              Combo combo =
                                                  _combo(widget.recData, index);
                                              ShowCartMode().showCartMode(
                                                  ref, context, combo);
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
                                                id: widget.recData[index]["ID"],
                                                items: widget.recData[index]
                                                    ["ITEMS"],
                                                rate: widget.recData![index]
                                                    ["RATE"],
                                                description:
                                                    widget.recData[index]
                                                        ["DESCRIPTION"],
                                                category: widget.recData[index]
                                                    ["CATEGORY"],
                                                available: widget.recData[index]
                                                            ["AVAILABLE"] ==
                                                        'true'
                                                    ? true
                                                    : false,
                                                likes: widget.recData[index]
                                                    ["LIKES"],
                                                isPopular: widget.recData[index]
                                                            ["POPULAR"] ==
                                                        'true'
                                                    ? true
                                                    : false,
                                                overallRating:
                                                    widget.recData[index]
                                                        ["OVERALL_RATING"],
                                                image: widget.recData[index]
                                                    ["IMAGE"],
                                                isVeg: widget.recData[index]
                                                            ["IS_VEG"] ==
                                                        'true'
                                                    ? true
                                                    : false,
                                                type: widget.recData[index]
                                                    ["TYPE"],
                                                ingredients: List<String>.from(
                                                    widget.recData[index]
                                                        ["INGREDIENTS"]),
                                              );

                                              NavigatorToDetail()
                                                  .navigatorToProDetail(
                                                      context,
                                                      [_combo],
                                                      widget.recData,
                                                      false);
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

  Combo _combo(List<dynamic> _recData, int index) {
    List<String> _ingredients = [];
    _recData[index]["INGREDIENTS"].forEach((element) {
      _ingredients.add(element);
    });

    return Combo(
        id: _recData[index]["ID"],
        items: _recData[index]["ITEMS"],
        rate: _recData[index]["RATE"],
        description: _recData[index]["DESCRIPTION"],
        category: _recData[index]["CATEGORY"],
        available: _recData[index]["AVAILABLE"] != "true" ? false : true,
        likes: _recData[index]["LIKES"],
        overallRating: _recData[index]["OVERALL_RATING"],
        image: _recData[index]["IMAGE"],
        isPopular: _recData[index]["POPULAR"] != "true" ? false : true,
        isVeg: _recData[index]["IS_VEG"] != "true" ? false : true,
        type: _recData[index]["TYPE"],
        ingredients: _ingredients);
  }
}
