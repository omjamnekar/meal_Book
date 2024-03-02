import 'package:MealBook/pages/homePage/homeItem/comboSlider.dart';
import 'package:MealBook/pages/homePage/loaderAnimation.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
  PageController _controller = PageController();
  List<String> catagory = [
    "Pizza",
    "Burger",
    "Pasta",
    "Noodles",
    "Biryani",
    "Fried Rice",
    "Bread",
    "Sandwich",
    "Roll",
    "Salad",
    "Soup",
    "Dessert",
    "Beverage",
    "Ice Cream",
    "Cake",
    "Pastry",
  ];

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access inherited widget (e.g., MediaQuery) here
    final brightness = MediaQuery.of(context).platformBrightness;

    // Update state based on inherited widget
    setState(() {
      isDarkMode = brightness == Brightness.dark;
    });
  }

  int selectedCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    Color theme = Theme.of(context).colorScheme.primaryContainer;

    Color theme2 = Theme.of(context).colorScheme.background;

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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: catagory.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    width: 70,
                    alignment: Alignment.center,
                    height: 40,
                    margin: const EdgeInsets.only(right: 30),
                    decoration: BoxDecoration(
                      color: selectedCategoryIndex == index ? theme : theme2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      catagory[index],
                      style: TextStyle(),
                    )),
                  ),
                );
              },
            ),
          ), // category detail products

          Gap(24),

          // category detail swiper
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: PageView.builder(
              controller: _controller,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/image/productsALL/category/maisure_dosa.jpg"),
                      colorFilter: ColorFilter.mode(
                        Colors.black
                            .withOpacity(0.5), // Adjust the opacity here
                        BlendMode.srcATop,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 17, top: 17),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.stars_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  Text(
                                    "4.5",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
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
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            "Cheese Pizza",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 30,
                              wordSpacing: 0.01, // word spacing
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Gap(10),
                        Row(
                          children: [
                            Text(
                              "Pizza is a savory dish of Italian origin",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Order Now",
                                style: TextStyle(
                                  color: Colors.black,
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
              },
            ),
          ),

          Gap(20),

          // navigator for category detail swiper
          SmoothPageIndicator(
            controller: _controller,
            count: 4,
            effect: ExpandingDotsEffect(
              dotColor: Colors.grey,
              activeDotColor: Theme.of(context).colorScheme.primaryContainer,
              dotHeight: 10,
              dotWidth: 10,
              spacing: 8,
              expansionFactor: 4,
            ),
          ),

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
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      ),
                    ],
                  );
                }),
          ),

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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "See All",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer),
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
                            primary: Theme.of(context).colorScheme.secondary,
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

          Container(
            width: MediaQuery.of(context).size.width,
            height: 179 * 20,
            child: ListView.builder(
              itemCount: 20,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/image/productsALL/category/maisure_dosa.jpg"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      //Details
                      Container(
                        margin: const EdgeInsets.only(
                          left: 15,
                          top: 13,
                          bottom: 13,
                        ),
                        width: 230,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Maisur Dosa",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Mysore masala dosa is a spicy dosa made with a batter that includes onion, red chili, tomato paste, and coconut.",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ),
                            Gap(4),
                            Row(
                              children: [
                                Text(
                                  "50.Rs",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Text(
                                  " / 1 Piece",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Text(
                                  " | 101 likes",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                ),
                              ],
                            ),
                            Container(
                              width: 230,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.1),
                              height: 1,
                              margin: const EdgeInsets.only(top: 3, bottom: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Order",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                        )),
                                    Gap(6),
                                    TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Add",
                                          style: GoogleFonts.poppins(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                          ),
                                        )),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.star,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5)),
                                Gap(2),
                                Text("4.8"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
  }
}
