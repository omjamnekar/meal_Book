import 'dart:convert';

import 'package:MealBook/Theme/theme_provider.dart';
import 'package:MealBook/firebase/image.dart';
import 'package:MealBook/json/combo.dart';
import 'package:MealBook/provider/actuatorState.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    bootState();
  }

  bootState() {
    // final imageList = context.read(rec);
  }

  // Moved the initialization to initState or build method
  List<String> foodName = [
    "Cheese Masala Dosa",
    "Cheese Onion Uttapam",
    "Cheese Toast Sandwich",
    "Banana Milk Shake",
  ];

  List<String> featuredFood1 = [
    "chaas.png",
    "francky.png",
    "rice.png",
    "uttapam.png",
    "chai.png",
    "noodles.png",
    "chikoo-milkshake.png",
  ];

  List<String> featureFood2 = [
    "omlette.png",
    "sev-puri.png",
    "juice.png",
    "dosa.png",
    "golgappe.png",
    "milkshake.png",
    "pizza.png",
    "sandwich.png"
  ];

  List<String> featuredFoodName1 = [
    "chass",
    "frankie",
    "rice",
    "uttapam",
    "chai",
    "noodles",
    "chikoo milkshake",
  ];

  List<String> featureFoodName2 = [
    "omelette",
    "sev puri",
    "juices",
    "dosa",
    "golgappe",
    "milkshake",
    "pizza",
    "sandwich"
  ];

  FireStoreDataBase storage = FireStoreDataBase();

//Combo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          "Om jamnekar",
                          style: GoogleFonts.roboto(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                        const Gap(10),
                        const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          size: 20.0,
                          color: Color.fromARGB(221, 76, 76, 76),
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
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme();
                          },
                          child: Icon(
                            Icons.nightlight_outlined,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        Gap(20),
                        const Icon(
                          Icons.notes,
                          color: Color.fromARGB(221, 76, 76, 76),
                        ),
                        Text(
                          "List",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: Color.fromARGB(221, 76, 76, 76),
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
                    return Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 230,
                      child: Swiper(
                        duration: 2,
                        curve: Curves.bounceInOut,
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 200,
                              width: 250,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    HexColor(combo[index]!["containerColor"]),
                                    HexColor("ffffff")
                                  ],
                                ),
                                color:
                                    HexColor(combo[index]!["containerColor"]),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: -70,
                                    right: -60,
                                    child: Container(
                                      width: 260,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            snapshot.data![index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    left: 15,
                                    child: Container(
                                      width: 260,
                                      child: Text(
                                        "${combo[index]!["name"]}",
                                        style: GoogleFonts.passionOne(
                                          color: HexColor(
                                              combo[index]!["headerColor"]),
                                          fontSize: 29,
                                          height: 1,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 90,
                                    left: 20,
                                    child: Container(
                                        width: 205,
                                        height: 80,
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              combo[index]!["dish"].length,
                                          itemBuilder: (context, i) {
                                            return Text(
                                              "${combo[index]!["dish"][i]}",
                                              style: GoogleFonts.passionOne(
                                                color: HexColor(
                                                        combo[index]!["text"])
                                                    .withOpacity(0.5),
                                                fontSize: 15,
                                                height: 1,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            );
                                          },
                                        )),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 20,
                                    child: Container(
                                      width: 105,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Order",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  221, 55, 55, 55)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: combo.length,
                        viewportFraction: 0.95,
                        scale: 0.2,
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.connectionState == ConnectionState.waiting ||
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
                            color: Theme.of(context).colorScheme.onSecondary),
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
                            color: Theme.of(context).colorScheme.onSecondary),
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
                  ElevatedButton(onPressed: () {}, child: Text("Recommended")),
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
                                    width: 1,
                                    color:
                                        const Color.fromARGB(137, 39, 39, 39)),
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Icon(Icons.arrow_forward)),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 20, left: 10),
                                        width: 110,
                                        child: Text(
                                          comboData[index]!["name"],
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              height: 1,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onTertiary),
                                        )),
                                  ),
                                  Positioned(
                                    bottom: -9,
                                    right: -10,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, left: 10),
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
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  return const CircularProgressIndicator();
                }),
            Gap(30),
          ],
        ),
      )),
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

class Footer extends StatelessWidget {
  const Footer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      width: MediaQuery.sizeOf(context).width,
      height: 60,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromARGB(19, 0, 0, 0)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.fastfood,
                size: 27,
              ),
              Text(
                "FOOD",
                style: GoogleFonts.roboto(
                    fontSize: 12, fontWeight: FontWeight.w800),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 27,
                fill: 0.1,
              ),
              Text(
                "COMBO",
                style: GoogleFonts.roboto(
                    fontSize: 12, fontWeight: FontWeight.w800),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 27,
                weight: 10,
              ),
              Text(
                "SEARCH",
                style: GoogleFonts.roboto(
                    fontSize: 12, fontWeight: FontWeight.w800),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 27,
              ),
              Text(
                "ACCOUNT",
                style: GoogleFonts.roboto(
                    fontSize: 12, fontWeight: FontWeight.w800),
              )
            ],
          )
        ],
      ),
    );
  }
}
