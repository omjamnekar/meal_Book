import 'package:MealBook/src/Theme/theme_provider.dart';
import 'package:MealBook/controller/homeLogic.dart';
import 'package:MealBook/firebase/image.dart';
import 'package:MealBook/respository/json/combo.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/src/pages/homePage/homeItem/comboSlider.dart';
import 'package:MealBook/src/pages/homePage/homeItem/general.dart';
import 'package:MealBook/src/pages/homePage/homeItem/recommend.dart';
import 'package:MealBook/src/components/loaderAnimation.dart';
import 'package:MealBook/src/pages/mainPage.dart';
import 'package:MealBook/respository/provider/actuatorState.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({
    super.key,
    required this.user,
    required this.ref,
    required this.storage,
    required this.imageListModel,
    required this.imageUrls,
    required this.comboDataManager,
  });

  final UserDataManager user;
  final WidgetRef ref;
  final FireStoreDataBase storage;
  final ImageListModel imageListModel;
  final List<String> imageUrls;
  final List<Object?> comboDataManager;

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  bool isRecommend = true;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<homeController>(
        init: homeController(),
        builder: (ctrl) {
          return SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: widget.storage.downloadURLs(),
                    builder: (BuildContext builer,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        /// return Container();

                        return ComboSlider(
                          imageListModel: widget.imageListModel,
                          imageUrls: widget.imageUrls,
                          snapshot: snapshot,
                          comboDataManager: widget.comboDataManager,
                        );
                        // return Container();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData) {
                        return LoadinAnimation(
                          mainFrame: 240,
                          scale: 0.5,
                          viewportFraction: 0.9,
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.active ||
                          !snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      return const CircularProgressIndicator();
                    }),
                Gap(80),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${ctrl.extractFirstWord(widget.user.name ?? "Username")}, What do plan for eating?",
                      style: GoogleFonts.poppins(
                          letterSpacing: 0.7,
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 17,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Gap(35),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredFoodName1.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Image.asset(
                              width: 120,
                              height: 100,
                              "assets/image/productsALL/${featuredFood1[index]}"),
                          Gap(9),
                          Text(
                            "${featuredFoodName1[index]}",
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Gap(4),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featureFood2.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Image.asset(
                              width: 120,
                              height: 100,
                              "assets/image/productsALL/${featureFood2[index]}"),
                          Gap(9),
                          Text(
                            "${featureFoodName2[index]}",
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 40, left: 20),
                  height: 100,
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    children: [
                      isRecommend
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isRecommend = true;
                                });
                              },
                              child: Text("Recommended"))
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  isRecommend = true;
                                });
                              },
                              child: Text("Recommended"),
                            ),
                      Gap(10),
                      isRecommend
                          ? TextButton(
                              onPressed: () {
                                setState(() {
                                  isRecommend = false;
                                });
                              },
                              child: Text("General"),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isRecommend = false;
                                });
                              },
                              child: Text("General")),
                    ],
                  ),
                ),
                Gap(20),
                isRecommend
                    ? FutureBuilder(
                        future: widget.storage.downloadURLs2(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return SubRecommed(
                              snapshot: snapshot,
                            );
                          }
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return LoadinAnimation(
                              mainFrame: 200,
                              scale: 0.5,
                              viewportFraction: 0.4,
                            );
                          }

                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          return const CircularProgressIndicator();
                        })
                    : GeneralItem(
                        cntr: ctrl,
                      ),
                Gap(30),
              ],
            ),
          );
        });
  }
}
