import 'package:MealBook/controller/comboLogic.dart';
import 'package:MealBook/src/Theme/theme_preference.dart';
import 'package:MealBook/src/components/loaderAnimation.dart';
import 'package:MealBook/src/pages/combo/recommends.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ComboStore extends ConsumerStatefulWidget {
  const ComboStore({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ComboStoreState();
}

class _ComboStoreState extends ConsumerState<ComboStore> {
  int navigatorIndex = 0;
  int isfoodTypeSelect = 0;

  String _selectedFoodCategory = "all";
  PageController _controller = PageController();
  // List<String> catagory = [
  //   "Pizza",
  //   "Burger",
  //   "Pasta",
  //   "Noodles",
  //   "Biryani",
  //   "Fried Rice",
  //   "Bread",
  //   "Sandwich",
  //   "Roll",
  //   "Salad",
  //   "Soup",
  //   "Dessert",
  //   "Beverage",
  //   "Ice Cream",
  //   "Cake",
  //   "Pastry",
  // ];

  final List<String> catagoryList = ["all", "recommend", "achievement", "new"];
  List<String> lottieCategory = [
    "assets/lottie/all.json",
    "assets/lottie/recommend.json",
    "assets/lottie/achieve.json",
    "assets/lottie/new.json",
  ];

  List<String> lottieCategoryDarkTheme = [
    "assets/lottie/darkMode/all.json",
    "assets/lottie/darkMode/recommend.json",
    "assets/lottie/darkMode/achieve.json",
    "assets/lottie/darkMode/new.json",
  ];

  List<String> foodType = [
    "All",
    "Cuisine",
    "Fast Food",
    "Meal",
    "Snacks",
    "Treat",
    "Nourishment",
    "Dish",
  ];
  bool isDarkMode = false;
  themSetter() async {
    isDarkMode = await ThemePreferences.isDarkMode();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    themSetter();
  }

  int selectedCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    themSetter();

    Color theme = Theme.of(context).colorScheme.primaryContainer;

    Color theme2 = Theme.of(context).colorScheme.background;

    return GetBuilder<ComboLogic>(
        init: ComboLogic(),
        builder: (ctrl) {
          ctrl.fetchvariety();
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Gap(20),

                // category
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  padding: const EdgeInsets.only(left: 20),
                  // color: Colors.grey[200],
                  child: FutureBuilder(
                      future: ctrl.fetchvariety(),
                      builder: (context, AsyncSnapshot<List> vername) {
                        if (vername.connectionState ==
                                ConnectionState.waiting &&
                            !vername.hasData) {
                          return Container(
                            height: 70,
                          );
                        } else if (vername.connectionState ==
                                ConnectionState.done &&
                            vername.hasData) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: vername.data!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryIndex = index;

                                      setState(() {
                                        ctrl.selectVariety =
                                            vername.data![index];
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: 70,
                                    alignment: Alignment.center,
                                    height: 40,
                                    margin: const EdgeInsets.only(right: 30),
                                    decoration: BoxDecoration(
                                      color: selectedCategoryIndex == index
                                          ? theme
                                          : theme2,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                        child: Text(
                                      vername.data![index].toLowerCase().trim(),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(),
                                    )),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Container(
                            height: 70,
                          );
                        }
                      }),
                ), // category detail products

                Gap(24),

                // category detail swiper
                FutureBuilder<List<dynamic>>(
                    future: ctrl.fetchvarietyData(ctrl.selectVariety ?? ""),
                    builder: (context, AsyncSnapshot<List> verData) {
                      if (verData.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            LoadinAnimation2(
                              mainFrame: 200,
                              scale: 0.5,
                              viewportFraction: 0.9,
                            ),
                            Gap(20),
                          ],
                        );
                      } else if (verData.connectionState ==
                              ConnectionState.done &&
                          verData.hasData) {
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 700),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                child: FutureBuilder(
                                    future: ctrl.fetchImage(
                                        (ctrl.selectVariety).isEmpty
                                            ? "chat-kamal"
                                            : ctrl.selectVariety
                                                .toLowerCase()
                                                .replaceAll(' ', ''),
                                        verData.data!),
                                    builder: (context,
                                        AsyncSnapshot<List<dynamic>> imageUrl) {
                                      if (imageUrl.connectionState ==
                                              ConnectionState.waiting &&
                                          !imageUrl.hasData) {
                                        return AnimatedSwitcher(
                                          duration: Duration(milliseconds: 500),
                                          child: LoadinAnimation2(
                                            mainFrame: 200,
                                            scale: 0.5,
                                            viewportFraction: 0.9,
                                          ),
                                        );
                                      } else if (imageUrl.connectionState ==
                                              ConnectionState.done &&
                                          imageUrl.hasData) {
                                        return PageView.builder(
                                            controller: _controller,
                                            itemCount: imageUrl.data!.length,
                                            itemBuilder: (context, index) {
                                              print(index);

                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        "${imageUrl.data![index]}"),
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      Colors.black.withOpacity(
                                                          0.5), // Adjust the opacity here
                                                      BlendMode.srcATop,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15, bottom: 15),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 17,
                                                                    top: 17),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .stars_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 18,
                                                                ),
                                                                Text(
                                                                  "${verData.data![index]["OVERALL_RATING"]}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Gap(20),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        child: Text(
                                                          "${verData.data![index]["ITEMS"]}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            wordSpacing:
                                                                0.01, // word spacing
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        ),
                                                      ),
                                                      Gap(10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: 300,
                                                            child: Text(
                                                              "${verData.data![index]["DESCRIPTION"]}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Text(
                                                              "Order Now",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Gap(10),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      } else {
                                        return AnimatedSwitcher(
                                          duration: Duration(milliseconds: 500),
                                          child: LoadinAnimation2(
                                            mainFrame: 200,
                                            scale: 0.5,
                                            viewportFraction: 0.9,
                                          ),
                                        );
                                      }
                                    }),
                              ),
                              Gap(20),

                              // navigator for category detail swiper
                              SmoothPageIndicator(
                                controller: _controller,
                                count: verData.data!.length,
                                effect: ExpandingDotsEffect(
                                  dotColor: Colors.grey,
                                  activeDotColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  dotHeight: 10,
                                  dotWidth: 10,
                                  spacing: 8,
                                  expansionFactor: 4,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            LoadinAnimation2(
                              mainFrame: 200,
                              scale: 0.5,
                              viewportFraction: 0.9,
                            ),
                            Gap(20),
                          ],
                        );
                      }
                    }),

                Gap(40),

                // heading for category detail products
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Category",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  child: ListView.builder(
                      itemCount: lottieCategory.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              margin: const EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: LottieBuilder.asset(
                                  isDarkMode
                                      ? lottieCategoryDarkTheme[index]
                                      : lottieCategory[index],
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                            ),
                            Gap(10),
                            Container(
                              width: 90,
                              margin: const EdgeInsets.only(left: 15),
                              child: Text(
                                textAlign: TextAlign.center,
                                catagoryList[index].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              ),
                            ),
                          ],
                        );
                      }),
                ),

// recommendation section
                Gap(10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.2),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        "Recommendations",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See All",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(10),

                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: foodType.length,
                    padding: const EdgeInsets.only(right: 20),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 1.0),
                        child: TextButton(
                          style: isfoodTypeSelect == index
                              ? TextButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              : TextButton.styleFrom(),
                          onPressed: () {
                            setState(() {
                              _selectedFoodCategory = foodType[index];
                              isfoodTypeSelect = index;
                            });
                          },
                          child: Text(
                            foodType[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                OptionBuilder(
                    ctrl: ctrl, selectedFoodCategory: _selectedFoodCategory),

                Container(
                    child: Text(
                  "see more ->",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer),
                )),

                Gap(20),
              ],
            ),
          );
        });
  }
}
