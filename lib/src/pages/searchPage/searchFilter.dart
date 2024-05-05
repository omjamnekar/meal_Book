import 'package:MealBook/respository/json/combo.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/components/loaderAnimation.dart';
import 'package:MealBook/src/components/navigateTodetail.dart';
import 'package:MealBook/src/pages/searchPage/controller/searchCon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class SearchAndFilterContent extends StatefulWidget {
  SearchAndFilterContent({Key? key, required this.allData}) : super(key: key);

  List<Map<String, dynamic>> allData;

  @override
  State<SearchAndFilterContent> createState() => _SearchAndFilterContentState();
}

class _SearchAndFilterContentState extends State<SearchAndFilterContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    // Start the animation when the page is initialized
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    isDarkMode = brightness == Brightness.dark;
    if (widget.allData.isEmpty) {
      return Center(
          child: Column(children: [
        Gap(100),
        isDarkMode
            ? LottieBuilder.asset('assets/lottie/darkMode/noDataDark.json',
                height: 200, width: 200)
            : LottieBuilder.asset('assets/lottie/noData.json',
                height: 200, width: 200),
        Text(
          "No Data Found",
          style: TextStyle(color: Colors.grey[400], fontSize: 20),
        ),
        Gap(10),
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            "See our Combos and Categories for more options ",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400], fontSize: 15),
          ),
        ),
        Gap(20),
      ]));
    } else {
      return SafeArea(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(bottom: 300),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 690),
              itemCount: widget.allData.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Combo combo = Combo.fromMap(widget.allData[index]);
                    NavigatorToDetail()
                        .navigatorToProDetail(context, [combo], widget.allData);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                            future: SearchPageController.searchImage(
                                widget.allData[index]['TYPE'],
                                widget.allData[index]['IMAGE']),
                            builder:
                                (context, AsyncSnapshot<String> imageSnapShot) {
                              if (imageSnapShot.connectionState ==
                                      ConnectionState.waiting &&
                                  !imageSnapShot.hasData) {
                                return EasyAnimater();
                              } else if (imageSnapShot.connectionState ==
                                      ConnectionState.done &&
                                  imageSnapShot.hasData) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    imageSnapShot.data ?? "",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else if (imageSnapShot.hasError) {
                                return EasyAnimater();
                              } else {
                                return EasyAnimater();
                              }
                            }),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 280,
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.allData[index]['ITEMS'] ?? "No Name",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              width: 280,
                              child: Text(
                                widget.allData[index]['DESCRIPTION'] ??
                                    "No Description",
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Gap(5),
                            Text(
                              "${widget.allData[index]['RATE'].toString()}Rs" ??
                                  "No Price",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }
}

class EasyAnimater extends StatelessWidget {
  const EasyAnimater({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 100, //250
              height: 100, //200
              color: Colors.white,
            )),
      ),
    );
  }
}
