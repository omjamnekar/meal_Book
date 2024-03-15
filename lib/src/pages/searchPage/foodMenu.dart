import 'package:MealBook/src/pages/searchPage/controller/MenuCont.dart';
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
                        .withOpacity(0.5),
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
                                future: ctrl
                                    .listImage(foodmenu.data![index]['IMAGE']),
                                builder:
                                    (context, AsyncSnapshot<String> menuImage) {
                                  if (menuImage.connectionState ==
                                          ConnectionState.waiting &&
                                      menuImage.hasData) {
                                    return Container();
                                  } else if (menuImage.connectionState ==
                                          ConnectionState.done &&
                                      menuImage.hasData) {
                                    return ClipRRect(
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
                                                    Text(
                                                      "${foodmenu.data![index]['TYPE']}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Icon(
                                                      Icons.favorite_border,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
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
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          },
                        ),
                      );
                    }
                    return Container();
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
                          .withOpacity(0.5),
                    )),
              ),
              Gap(20),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 100,
                child: ListView.builder(
                  itemCount: 10,
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
              ),
              Gap(30),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 240,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 15),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: 350,
                          height: 100,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Gap(20),
                        Container(
                          width: 350,
                          height: 100,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          );
        });
  }
}
