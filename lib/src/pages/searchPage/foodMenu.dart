import 'dart:ffi';

import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/components/comboToNavigator.dart';
import 'package:MealBook/src/components/loaderAnimation.dart';
import 'package:MealBook/src/components/navigateTodetail.dart';
import 'package:MealBook/src/pages/searchPage/controller/MenuCont.dart';
import 'package:MealBook/src/pages/searchPage/otherConnections/foodMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodMenu extends StatelessWidget {
  const FoodMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuFoodController>(
        init: MenuFoodController(),
        builder: (ctrl) {
          return Column(
            children: [
              const Gap(50),
              Container(
                margin: const EdgeInsets.only(left: 27, right: 27),
                width: MediaQuery.sizeOf(context).width,
                child: Text(
                  "FOOD MENU",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(1),
                  ),
                ),
              ),
              Gap(20),
              FutureBuilder(
                  future: ctrl.fetchMenu(),
                  builder: (context, AsyncSnapshot<List<dynamic>> foodmenu) {
                    if (foodmenu.connectionState == ConnectionState.waiting &&
                        !foodmenu.hasData) {
                    } else if (foodmenu.connectionState ==
                            ConnectionState.active &&
                        !foodmenu.hasData) {
                      return Container(
                        child: LoadinAnimation2(
                          mainFrame: 150,
                          scale: 0.4,
                          viewportFraction: .3,
                        ),
                      );
                    } else if (foodmenu.connectionState ==
                            ConnectionState.done &&
                        foodmenu.hasData) {
                      return Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 150,
                        alignment: Alignment.center,
                        child: ListView.builder(
                          itemCount: foodmenu.data!.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 35),
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: ctrl.listImage(
                                  foodmenu.data![index]['IMAGE'],
                                ),
                                builder:
                                    (context, AsyncSnapshot<String> menuImage) {
                                  if (menuImage.connectionState ==
                                          ConnectionState.waiting &&
                                      menuImage.hasData) {
                                    return Container();
                                  } else if (menuImage.connectionState ==
                                          ConnectionState.done &&
                                      menuImage.hasData) {
                                    return GestureDetector(
                                      onTap: () {
                                        List<String> optionFoodVer = foodmenu
                                            .data!
                                            .map<String>(
                                                (e) => e['TYPE'] as String)
                                            .toList();

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FoodMenuShower(
                                                      title: foodmenu
                                                          .data![index]['TYPE'],
                                                      items: optionFoodVer,
                                                    )));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: 130,
                                          height: 110,
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer
                                                .withOpacity(0.03),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 70,
                                                        child: Text(
                                                          "${foodmenu.data![index]['TYPE']}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onBackground
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Icon(
                                                        Icons.favorite_border,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground
                                                            .withOpacity(0.6),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Positioned(
                                                bottom: -50,
                                                right: -50,
                                                child: Image.network(
                                                  menuImage.data!,
                                                  width: 150,
                                                  height: 150,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          },
                        ),
                      );
                    }
                    return Container(
                      child: LoadinAnimation2(
                        mainFrame: 150,
                        scale: 0.4,
                        viewportFraction: .3,
                      ),
                    );
                  }),
              Gap(40),
              Container(
                margin: const EdgeInsets.only(left: 27, right: 27),
                width: MediaQuery.sizeOf(context).width,
                alignment: Alignment.centerLeft,
                child: Text("Populars Entries",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(.8),
                    )),
              ),
              Gap(20),
              FutureBuilder(
                  future: ctrl.search(),
                  builder: (context,
                      AsyncSnapshot<List<Map<String, dynamic>>> foodmenu) {
                    if (foodmenu.connectionState == ConnectionState.waiting &&
                        !foodmenu.hasData) {
                      return const Default();
                    } else if (foodmenu.connectionState ==
                            ConnectionState.active &&
                        !foodmenu.hasData) {
                      return const Default();
                    } else if (foodmenu.connectionState ==
                            ConnectionState.done &&
                        foodmenu.hasData) {
                      return SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 100,
                        child: ListView.builder(
                          itemCount: foodmenu.data!.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 35),
                          itemBuilder: (context, index) {
                            if (index > 1) {
                              return FutureBuilder(
                                  future: ctrl.searchImage(
                                      foodmenu.data![index]['TYPE'],
                                      foodmenu.data![index]['IMAGE']),
                                  builder: (context,
                                      AsyncSnapshot<String> menuImage) {
                                    if (menuImage.connectionState ==
                                            ConnectionState.waiting &&
                                        menuImage.hasData) {
                                      return Container();
                                    } else if (menuImage.connectionState ==
                                            ConnectionState.done &&
                                        menuImage.hasData) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: GestureDetector(
                                          onTap: () {
                                            Combo _combo = Combo.fromMap(
                                                foodmenu.data![index]);

                                            NavigatorToDetail()
                                                .navigatorToProDetail(context,
                                                    [_combo], foodmenu.data!);
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    menuImage.data!),
                                                fit: BoxFit.cover,
                                                filterQuality:
                                                    FilterQuality.high,
                                                colorFilter: ColorFilter.mode(
                                                    Colors.black
                                                        .withOpacity(0.2),
                                                    BlendMode.darken),
                                              ),
                                            ),
                                            child: Stack(children: [
                                              Positioned(
                                                bottom: 10,
                                                left: 10,
                                                child: SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    "${foodmenu.data![index]['ITEMS']}",
                                                    maxLines: 1,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  });
                            }
                            return Container();
                          },
                        ),
                      );
                    }

                    return const Default();
                  }),
              // const Gap(30),
              // Container(
              //   width: MediaQuery.sizeOf(context).width,
              //   height: 240,
              //   child: ListView.builder(
              //     padding: const EdgeInsets.only(left: 15),
              //     itemCount: 10,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       return Column(
              //         children: [
              //           Container(
              //             width: 350,
              //             height: 100,
              //             margin: const EdgeInsets.only(right: 20),
              //             decoration: BoxDecoration(
              //               color: Theme.of(context)
              //                   .colorScheme
              //                   .onSecondaryContainer
              //                   .withOpacity(0.1),
              //               borderRadius: BorderRadius.circular(20),
              //             ),
              //           ),
              //           Gap(20),
              //           Container(
              //             width: 350,
              //             height: 100,
              //             margin: const EdgeInsets.only(right: 20),
              //             decoration: BoxDecoration(
              //               color: Theme.of(context)
              //                   .colorScheme
              //                   .onSecondaryContainer
              //                   .withOpacity(0.1),
              //               borderRadius: BorderRadius.circular(20),
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // )
            ],
          );
        });
  }
}

class Default extends StatelessWidget {
  const Default({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 100,
      child: ListView.builder(
        itemCount: 20,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 35),
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            height: 20,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}
