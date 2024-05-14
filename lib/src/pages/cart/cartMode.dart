import 'package:MealBook/controller/comboLogic.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/respository/model/payInfo.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:MealBook/src/components/asynceChecker.dart';
import 'package:MealBook/src/pages/cart/cartLoading.dart';
import 'package:MealBook/src/pages/cart/controller/cartLogic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ShowCartMode {
  showCartMode(
    WidgetRef ref,
    BuildContext context,
    Combo combo,
  ) async {
    await CartLogic().postDataCombo(ref, combo);

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text("Added to Cart",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.tertiary)),
                    Spacer(),
                    Icon(
                      size: 25,
                      Icons.arrow_drop_down_sharp,
                      color: combo.isVeg
                          ? Colors.green
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                    Text(combo.isVeg ? "Veg" : "Non-Veg"),
                    Gap(20),
                  ],
                ),
              ),
              Gap(10),
              // image and info
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          combo.items,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "₹ ${combo.rate}",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Gap(10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FutureBuilder(
                                future: ComboLogic().fullDataImage(
                                    combo.type, combo.image, (imagde) {}),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting &&
                                      !snapshot.hasData) {
                                    return _loadingImage();
                                  } else if (snapshot.connectionState ==
                                          ConnectionState.active &&
                                      !snapshot.hasData) {
                                    return _loadingImage();
                                  } else if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return Container(
                                        width: 60,
                                        height: 60,
                                        margin: EdgeInsets.only(left: 3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                snapshot.data!,
                                              ),
                                              fit: BoxFit.cover,
                                            )));
                                  } else if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      !snapshot.hasData) {
                                    return _loadingImage();
                                  }
                                  return _loadingImage();
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 15,
                  right: 10,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Text(combo.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.tertiary,
                            )),
                      ),
                      Spacer(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: combo.isPopular ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(combo.isPopular ? "Popular" : "Regular",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ]),
              ),

              Spacer(),
              TextButton(
                onPressed: () {
                  // CartLogic/
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartLoading(),
                      ));
                },
                child: Text(
                  "proceed to Cart",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 130, vertical: 10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _loadingImage() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 50, //250
          height: 50, //200
          color: Colors.white,
        ));
  }
}
