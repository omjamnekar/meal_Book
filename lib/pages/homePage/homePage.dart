import 'dart:convert';
import 'dart:core';

import 'package:MealBook/Theme/theme_provider.dart';
import 'package:MealBook/controller/homeLogic.dart';
import 'package:MealBook/firebase/image.dart';
import 'package:MealBook/json/combo.dart';
import 'package:MealBook/pages/homePage/comboSlider.dart';
import 'package:MealBook/pages/homePage/footer.dart';
import 'package:MealBook/pages/homePage/menuItem.dart';
import 'package:MealBook/provider/actuatorState.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:http/http.dart' as http;
import 'package:popover/popover.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late ImageListModel imageListModel;
  DatabaseReference references = FirebaseDatabase.instance.ref();
  List<Object?> comboDataManager = [];

  snapshot() async {
    final snapshot = await references.child('combo/').get();
    if (snapshot.exists) {
      comboDataManager.add(snapshot.value);
    } else {
      print('No Data Available');
    }
  }

  @override
  void initState() {
    super.initState();
    snapshot();

    imageListModel = ref.read(imageListProvider.notifier).currentImageState;
  }

  FireStoreDataBase storage = FireStoreDataBase();

//Combo
  final List<String> imageUrls = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GetBuilder<homeController>(
          init: homeController(),
          builder: (ctrl) {
            return SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text(
                                ctrl.user.name ?? "abc@gmail.com",
                                style: GoogleFonts.roboto(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                ),
                              ),
                              const Gap(10),
                              GestureDetector(
                                onTap: () {
                                  showPopover(
                                    direction: PopoverDirection.bottom,
                                    context: context,
                                    width: 400,
                                    height: 300,
                                    backgroundColor:
                                        Theme.of(context).primaryColorLight,
                                    bodyBuilder: (context) => MenuItem(
                                      name: ctrl.user?.name ?? "UserName",
                                      email:
                                          ctrl.user?.email ?? "abc@gmail.com",
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  size: 20.0,
                                  color: Color.fromARGB(221, 76, 76, 76),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.read<ThemeProvider>().toggleTheme();
                                },
                                child: Icon(
                                  Icons.nightlight_outlined,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              Gap(20),
                              GestureDetector(
                                onTap: () {
                                  //  Future<SignUpPlatform> signUpPlatformManager() async {

                                  ctrl.signOut(ref, context);
                                },
                                child: Text(
                                  "List",
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: Color.fromARGB(221, 76, 76, 76),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(43, 103, 103, 103),
                  ),
                  FutureBuilder(
                      future: storage.downloadURLs(),
                      builder: (BuildContext builer,
                          AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          /// return Container();

                          //print(comboDataManager);
                          return ComboSlider(
                            imageListModel: imageListModel,
                            imageUrls: imageUrls,
                            snapshot: snapshot,
                            comboDataManager: comboDataManager,
                          );
                          // return Container();
                        }
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return LoadinAnimation(
                            mainFrame: 240,
                            scale: 0.5,
                            viewportFraction: 0.9,
                          );
                        }

                        if (snapshot.connectionState ==
                                ConnectionState.active ||
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
                        "Om, What do plan for eating?",
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
                              style: GoogleFonts.lilitaOne(
                                  fontSize: 17,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Gap(10),
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
                              style: GoogleFonts.lilitaOne(
                                  fontSize: 17,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
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
                        ElevatedButton(
                            onPressed: () {}, child: Text("Recommended")),
                        Gap(10),
                        TextButton(onPressed: () {}, child: Text("General")),
                      ],
                    ),
                  ),
                  Gap(20),
                  FutureBuilder(
                      future: storage.downloadURLs2(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
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
                      }),
                  Gap(30),
                ],
              ),
            ));
          }),
      bottomNavigationBar: Footer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        onPressed: () {},
        child: Transform.translate(
          offset: Offset(-2, 1),
          child: Center(
            child: Image.asset(
              "assets/image/boat/boat.png",
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
  }
}

class SubRecommed extends StatelessWidget {
  SubRecommed({
    super.key,
    required this.snapshot,
  });

  AsyncSnapshot<List<String>> snapshot;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 200,
      child: Swiper(
        containerHeight: 440,
        itemCount: comboData.length,
        itemBuilder: (context, index) {
          return Transform.translate(
            offset: Offset(-40, 3),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black
                //         .withOpacity(0.2), // Shadow color
                //     spreadRadius: 3, // Spread radius
                //     blurRadius: 10, // Blur radius
                //     offset: Offset(0, 3), // Offset in x and y
                //   ),
                // ],
                border: Border.all(
                    width: 1, color: const Color.fromARGB(137, 39, 39, 39)),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 10, right: 10, child: Icon(Icons.arrow_forward)),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20, left: 10),
                        width: 110,
                        child: Text(
                          comboData[index]!["name"],
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 1,
                              color: Theme.of(context).colorScheme.onTertiary),
                        )),
                  ),
                  Positioned(
                    bottom: -9,
                    right: -10,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, left: 10),
                      width: 150,
                      child: Image.network(
                        snapshot.data![index],
                        width: 110,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        viewportFraction: 0.4,
        scale: 0.5,
      ),
    );
  }
}

class LoadinAnimation extends StatelessWidget {
  LoadinAnimation({
    super.key,
    required this.mainFrame,
    required this.scale,
    required this.viewportFraction,
  });

  final double mainFrame;

//
  final double viewportFraction;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: mainFrame, //200
      child: Swiper(
        duration: 2,
        itemCount: 10,
        curve: Curves.bounceInOut,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 250, //250
                height: 200, //200
                color: Colors.white,
              ),
            ),
          );
        },
        viewportFraction: viewportFraction, //0.9
        scale: scale, //0.5
      ),
    );
  }
}
