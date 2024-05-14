import 'package:MealBook/src/Theme/theme_provider.dart';
import 'package:MealBook/controller/homeLogic.dart';
import 'package:MealBook/firebase/image.dart';
import 'package:MealBook/respository/json/combo.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/src/pages/cart/cart.dart';
import 'package:MealBook/src/pages/cart/model/cart.dart';
import 'package:MealBook/src/pages/homePage/homeItem/comboSlider.dart';
import 'package:MealBook/src/pages/homePage/homeItem/general.dart';
import 'package:MealBook/src/pages/homePage/homeItem/recommend.dart';
import 'package:MealBook/src/components/loaderAnimation.dart';
import 'package:MealBook/respository/provider/actuatorState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({
    super.key,
    required this.user,
  });

  final UserDataManager user;

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
                    future: ctrl.fetchComboData(),
                    builder: (BuildContext builer,
                        AsyncSnapshot<List<Map<dynamic, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData &&
                          snapshot.data != null) {
                        /// return Container();

                        return ComboSlider(
                            snapshot:
                                snapshot.data! as List<Map<dynamic, dynamic>>);
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
                const Gap(80),
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
                const Gap(35),
                SizedBox(
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
                          const Gap(9),
                          Text(
                            featuredFoodName1[index],
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
                const Gap(4),
                SizedBox(
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
                          const Gap(9),
                          Text(
                            featureFoodName2[index],
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
                              child: const Text("Recommended"))
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  isRecommend = true;
                                });
                              },
                              child: const Text("Recommended"),
                            ),
                      const Gap(10),
                      isRecommend
                          ? TextButton(
                              onPressed: () {
                                setState(() {
                                  isRecommend = false;
                                });
                              },
                              child: const Text("General"),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isRecommend = false;
                                });
                              },
                              child: const Text("General")),
                    ],
                  ),
                ),
                const Gap(20),
                isRecommend ? Recommed() : GeneralItem(),
                const Gap(30),
              ],
            ),
          );
        });
  }
}
