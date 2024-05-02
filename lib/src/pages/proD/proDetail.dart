import 'package:MealBook/controller/comboLogic.dart';
import 'package:MealBook/controller/proDetailLogic.dart';
import 'package:MealBook/respository/json/combo.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key? key, required this.allData, required this.recData})
      : super(key: key);

  List<Combo> allData;
  List<dynamic> recData;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool isVeg = true;
  double opacityLevel = 0.0; // Define opacity variable

  initState() {
    super.initState();
    _proDetail.totalPriceSetter(widget.allData);
    _proDetail.startAutoScroll(widget.allData.length);
    isVeg = true;

    changeOpacity(); // Call the function to start the animation
  }

  void changeOpacity() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        opacityLevel =
            opacityLevel == 0 ? 1.0 : 0.0; // Change the opacity level
      });
    });
  }

  ProDetailLogic _proDetail = ProDetailLogic();

  ComboLogic combo = ComboLogic();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _proDetail.stopAutoScroll();
  }

  List<String> imageList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: SingleChildScrollView(
            child: AnimatedOpacity(
              opacity: opacityLevel, // Use the opacity variable here
              duration:
                  Duration(seconds: 1), // Define the duration of the animation

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                      future: combo.fullDataImage(
                          widget.allData[0].type, widget.allData[0].image),
                      builder: (context, AsyncSnapshot<String> imageProduct) {
                        if (imageProduct.connectionState ==
                                ConnectionState.waiting &&
                            !imageProduct.hasData) {
                          return Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 200,
                          );
                        } else if (imageProduct.connectionState ==
                                ConnectionState.active &&
                            !imageProduct.hasData) {
                          return Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 200,
                          );
                        } else if (imageProduct.connectionState ==
                                ConnectionState.done &&
                            imageProduct.hasData) {
                          imageList.add(imageProduct.data ?? "");
                          return Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 200,
                            child: PageView.builder(
                                controller: _proDetail.pageController,
                                itemCount: 2,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            imageProduct.data ?? ""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        gradient: shadowLayer(context),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(26),
                                        margin: const EdgeInsets.only(top: 20),
                                        width: MediaQuery.sizeOf(context).width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }

                        return Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 200,
                        );
                      }),

                  Gap(20),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 120,
                    child: PageView.builder(
                        controller: _proDetail.pageController,
                        itemCount: widget.allData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: Row(
                              children: [
                                //side heading
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Text(
                                          widget.allData[index].items,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            height: 1.2,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Gap(10),
                                      Container(
                                        width: 200,
                                        child: Text(
                                            widget.allData[index].description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            size: 25,
                                            Icons.arrow_drop_down_sharp,
                                            color: widget.allData[index].isVeg
                                                ? Colors.green
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                          ),
                                          Text(
                                              widget.allData[index].isVeg
                                                  ? "Veg"
                                                  : "Non-Veg",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Spacer(),
                                // side box

                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Gap(10),
                                      Text(
                                        widget.allData[0].rate.toString() +
                                            "Rs",
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      Container(
                                        width: 50,
                                        child: Divider(
                                          color: Color.fromARGB(23, 0, 0, 0),
                                        ),
                                      ),
                                      Text(
                                        "Rating",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.5)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Gap(10),
                  // box for image
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 80,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: ListView.builder(
                      reverse: true,
                      controller: _proDetail.pageController,
                      itemCount: imageList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 70,
                          height: 20,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(imageList[index]),
                                fit: BoxFit.cover),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withOpacity(0.2),
                                width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    ),
                  ),

                  // border
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.sizeOf(context).width,
                    child: const Divider(
                      color: Color.fromARGB(24, 0, 0, 0),
                      height: 1,
                    ),
                  ),
                  const Gap(10),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          child: Row(
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                size: 20,
                              ),
                              Gap(10),
                              Text("${_proDetail.totalPrice}Rs")
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Row(
                            children: [
                              Icon(Icons.timelapse_rounded),
                              Gap(10),
                              Text("15 MIN")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      "Ingredients",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      controller: ScrollController(),
                      itemCount: widget.allData[0].ingredients.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 200,
                          height: 30,
                          margin: const EdgeInsets.only(right: 30),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                    .withOpacity(0.2),
                                width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.energy_savings_leaf_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Gap(10),
                                  Text(widget.allData[0].ingredients[index])
                                ],
                              )),
                        );
                      },
                    ),
                  ),
                  Gap(20),

                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 90,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      transform: GradientRotation(4),
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.1),
                      ],
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("assets/logo/main.png"),
                          width: 29,
                          height: 29,
                        ),
                        Gap(10),
                        Text("Always here to serve you",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ),

                  Gap(20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.sizeOf(context).width,
                    child: const Divider(
                      color: Color.fromARGB(24, 0, 0, 0),
                      height: 1,
                    ),
                  ),
                  Gap(10),

                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Want to Repeat?",
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                  Gap(20),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 120,
                    child: ListView.builder(
                        itemCount: widget.allData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 220,
                            height: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 13),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.4),
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.allData[index].items,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Text(widget.allData[index].rate.toString() +
                                        "Rs"),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _proDetail.totalPrice +=
                                              widget.allData[index].rate;
                                        });
                                        _proDetail.totalAddetSetter(
                                            widget.allData[index].rate);
                                      },
                                      child: Text(
                                        "ADD+",
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),

                  const Gap(50),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Divider(
                      color: Colors.black.withOpacity(0.03),
                      thickness: 20,
                    ),
                  ),

                  Container(
                    height: widget.recData.length > 2
                        ? (widget.recData.length * 230) / 2
                        : (widget.recData.length * 230),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.recData.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: combo.fullDataImage(
                                widget.recData[index]["TYPE"],
                                widget.recData[index]["IMAGE"]),
                            builder:
                                (context, AsyncSnapshot<String> imageProduct) {
                              if (imageProduct.connectionState ==
                                      ConnectionState.waiting &&
                                  !imageProduct.hasData) {
                                return Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                            .withOpacity(0.2),
                                        width: 1),
                                  ),
                                );
                              } else if (imageProduct.connectionState ==
                                      ConnectionState.active &&
                                  !imageProduct.hasData) {
                                return Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                            .withOpacity(0.2),
                                        width: 1),
                                  ),
                                );
                              } else if (imageProduct.connectionState ==
                                      ConnectionState.done &&
                                  imageProduct.hasData) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.darken),
                                        image: NetworkImage(imageProduct.data ??
                                            "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"),
                                        fit: BoxFit.cover),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                            .withOpacity(0.2),
                                        width: 1),
                                  ),
                                  child: Column(
                                    children: [],
                                  ),
                                );
                              } else if (imageProduct.connectionState ==
                                      ConnectionState.done &&
                                  !imageProduct.hasData) {
                                return Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                            .withOpacity(0.2),
                                        width: 1),
                                  ),
                                );
                              }
                              return Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 20,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer
                                          .withOpacity(0.2),
                                      width: 1),
                                ),
                              );
                            });
                      },
                    ),
                  ),

                  Gap(200)
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(1),
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.sizeOf(context).width,
          height: 50,
          child: Center(
              child: Text(
            "Order Now",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
          )),
        ));
  }

  LinearGradient shadowLayer(BuildContext context) {
    return LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      transform: GradientRotation(-20),
      colors: [
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
        Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ],
    );
  }
}
