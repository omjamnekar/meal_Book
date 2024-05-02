import 'package:MealBook/respository/model/filter.dart';
import 'package:MealBook/src/pages/searchPage/category.dart';
import 'package:MealBook/src/pages/searchPage/controller/searchCon.dart';
import 'package:MealBook/src/pages/searchPage/filter.dart';
import 'package:MealBook/src/pages/searchPage/foodMenu.dart';
import 'package:MealBook/src/pages/searchPage/searchFilter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  SearchPageController searchPageController = SearchPageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sd();
  }

  List<Map<String, dynamic>> filterpattern = [];
  bool isSearchClick = false;
  List<dynamic> filterData = [];

  Future<void> sd() async {
    searchPageController.search();
  }

  bool isFrontFilter = false;
  String _selectedItem = 'All';
  bool isSearch = false;
  FilterManager? filter;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchPageController>(
        init: SearchPageController(),
        builder: (ctrl) {
          return SingleChildScrollView(
            child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          isSearchClick == true ? const Gap(20) : const Gap(50),

                          //  Search bar

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width / 1.4,
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        isSearchClick = true;
                                      });
                                    },
                                    onTapOutside: (value) {
                                      if (value.isBlank == true) {
                                        setState(() {
                                          isSearchClick = false;
                                        });
                                      } else {
                                        //   ctrl.deleter();
                                      }
                                    },
                                    onSubmitted: (value) {
                                      if (!isSearch) {
                                        setState(() {
                                          isSearchClick = false;
                                        });
                                      }

                                      if (value.isEmpty) {
                                        setState(() {
                                          isSearch = false;
                                          isSearchClick = false;
                                        });
                                        //  ctrl.deleter();
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        isSearch = true;
                                        ctrl.searchController.text = value;
                                      });
                                      //  ctrl.search();
                                      if (value.isEmpty) {
                                        setState(() {
                                          isSearch = false;
                                        });
                                      }
                                    },
                                    controller: ctrl.searchController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer
                                          .withOpacity(0.1),
                                      hintText: "Search",
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                // Filter
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      // scrollControlDisabledMaxHeightRatio: 0.01,
                                      //   isScrollControlled: true,
                                      builder: (context) {
                                        return FilterDialog(callback: (value) {
                                          setState(() {
                                            filter = value;
                                          });

                                          ctrl
                                              .filterCategory(value)
                                              .then((value) => setState(() {
                                                    isFrontFilter = true;
                                                  }));
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.dashboard_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Gap(10),
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
                                    });
                                    ctrl
                                        .categoryFilter(_selectedItem)
                                        .then((value) {
                                      setState(() {
                                        isFrontFilter = true;
                                      });
                                    });
                                  },
                                  child: CategorySearch(
                                    icon: Icons.emoji_food_beverage,
                                    title: "Breakfast",
                                    isSelected: _selectedItem == "Breakfast",
                                  ),
                                ),
                                const Gap(20),
                                // Dessert
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedItem = "Dessert";
                                    });
                                    ctrl
                                        .categoryFilter(_selectedItem)
                                        .then((value) {
                                      setState(() {
                                        isFrontFilter = true;
                                      });
                                    });
                                  },
                                  child: CategorySearch(
                                    icon: Icons.icecream,
                                    title: "Dessert",
                                    isSelected: _selectedItem == "Dessert",
                                  ),
                                ),

                                const Gap(20),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedItem = "Meal";
                                    });
                                    ctrl
                                        .categoryFilter(_selectedItem)
                                        .then((value) {
                                      setState(() {
                                        isFrontFilter = true;
                                      });
                                    });
                                  },
                                  child: CategorySearch(
                                    icon: Icons.fastfood_rounded,
                                    title: "Meal",
                                    isSelected: _selectedItem == "Meal",
                                  ),
                                ),

                                const Gap(20),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                              });

                                              ctrl
                                                  .categoryFilter(_selectedItem)
                                                  .then((value) => setState(() {
                                                        isFrontFilter = true;
                                                      }));

                                              // ctrl.
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
                                                ctrl.deleter();
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
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "$_selectedItem",
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                          Gap(20),
                        ],
                      ),
                    ),
                    // Content from here
                    // will get changed

                    isSearch == true || isFrontFilter == true
                        ?
                        // search Content or Filter Content
                        SearchAndFilterContent(
                            allData: ctrl.searchfilteredData,
                          )
                        : FoodMenu(),
                  ],
                )),
          );
        });
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
