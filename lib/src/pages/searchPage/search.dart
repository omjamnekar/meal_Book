import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  bool isFrontFilter = false;
  String _selectedItem = 'All';
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Gap(50),

                    //  Search bar
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width / 1.4,
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                    .withOpacity(0.1),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          Gap(10),
                          // Filter
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.dashboard_outlined),
                          ),
                        ],
                      ),
                    ),
                    Gap(10),
                    Container(
                      margin: const EdgeInsets.only(left: 27, right: 27),
                      width: MediaQuery.sizeOf(context).width,
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedItem = "Breakfast";
                                isFrontFilter = true;
                              });
                            },
                            child: CategorySearch(
                              icon: Icons.emoji_food_beverage,
                              title: "Breakfast",
                              isSelected: _selectedItem == "Breakfast",
                            ),
                          ),
                          Gap(20),
                          // Dessert
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedItem = "Dessert";
                                isFrontFilter = true;
                              });
                            },
                            child: CategorySearch(
                              icon: Icons.icecream,
                              title: "Dessert",
                              isSelected: _selectedItem == "Dessert",
                            ),
                          ),

                          Gap(20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedItem = "Meal";
                                isFrontFilter = true;
                              });
                            },
                            child: CategorySearch(
                              icon: Icons.fastfood_rounded,
                              title: "Meal",
                              isSelected: _selectedItem == "Meal",
                            ),
                          ),

                          Gap(20),
                          Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35, vertical: 20),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer
                                          .withOpacity(0.7),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (isFrontFilter == true) {
                                        setState(() {
                                          isFrontFilter = false;
                                        });
                                      }

                                      filterDialog(context, (value) {
                                        setState(() {
                                          _selectedItem = value;
                                          isFrontFilter = true;
                                        });
                                      });
                                    },
                                    child: Text(
                                      "More",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                      ),
                                    )),
                              ),
                              isFrontFilter == true
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isFrontFilter = false;

                                          _selectedItem = "All";
                                        });
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20))),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "$_selectedItem",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Icon(Icons.cancel,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer
                                                    .withOpacity(0.7),
                                                size: 20),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //heading
                  ],
                ),
              ),
              // Content from here
              // will get changed

              isSearch == true || isFrontFilter == true
                  ?
                  // search Content or Filter Content
                  Container()
                  : Column(
                      children: [
                        Gap(50),
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
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 150,
                          alignment: Alignment.center,
                          child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 35),
                            itemBuilder: (context, index) {
                              return Container(
                                width: 130,
                                height: 110,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "PAV BHAJI",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
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
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
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
                    ),
            ],
          )),
    );
  }

  Future<dynamic> filterDialog(
      BuildContext context, Function(String) seleBack) {
    bool isExtraFilter = false;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: StatefulBuilder(// Add this
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: MediaQuery.sizeOf(context).width / 1.5,
              height: MediaQuery.sizeOf(context).height / 3.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = "All";
                          });
                          isExtraFilter = true;
                          isFrontFilter = true;
                        },
                        child: CategorySearch(
                          icon: Icons.food_bank_rounded,
                          title: "All",
                          isSelected: _selectedItem == "All",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = "Cuisine";
                          });
                          isExtraFilter = true;
                          isFrontFilter = true;
                        },
                        child: CategorySearch(
                          icon: Icons.dining_sharp,
                          title: "Cuisine",
                          isSelected: _selectedItem == "Cuisine",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = "FastFood";
                          });
                          isExtraFilter = true;
                          isFrontFilter = true;
                        },
                        child: CategorySearch(
                          icon: Icons.restaurant,
                          title: "FastFood",
                          isSelected: _selectedItem == "FastFood",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = "Nourish";
                          });

                          isExtraFilter = true;
                          isFrontFilter = true;
                        },
                        child: CategorySearch(
                          icon: Icons.grass,
                          title: "Nourish",
                          isSelected: _selectedItem == "Nourish",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = "Dish";
                          });
                          isExtraFilter = true;
                          isFrontFilter = true;
                        },
                        child: CategorySearch(
                          icon: Icons.verified,
                          title: "Dish",
                          isSelected: _selectedItem == "Dish",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItem = "Treat";
                          });

                          isExtraFilter = true;
                          isFrontFilter = true;
                        },
                        child: CategorySearch(
                          icon: Icons.cookie,
                          title: "Treat",
                          isSelected: _selectedItem == "Treat",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                if (isFrontFilter == true && isExtraFilter == true) {
                  seleBack(_selectedItem);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CategorySearch extends StatefulWidget {
  CategorySearch({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
  });

  IconData icon;
  String title;
  bool isSelected;

  @override
  State<CategorySearch> createState() => _CategorySearchState();
}

class _CategorySearchState extends State<CategorySearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: !widget.isSelected
                ? Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withOpacity(0.1)
                : Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            widget.icon,
            color: !widget.isSelected
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}
