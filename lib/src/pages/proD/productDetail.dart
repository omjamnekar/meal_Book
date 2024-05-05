import 'package:MealBook/controller/comboLogic.dart';
import 'package:MealBook/payments/payOp.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/respository/model/payInfo.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:MealBook/src/components/asynceChecker.dart';
import 'package:MealBook/src/components/gridProductDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
  double opacityLevel = 0.0; // Define opacity Variable
  late PageController pageController = PageController(initialPage: 0);

  ScrollController scrollController = ScrollController();
  PaymentGateWay _payment = PaymentGateWay();
  late PayRazorUser payRazorUser;
  num totalPrice = 0;
  late Food food;
  _payprocess() async {
    _payment.init();
    await _userInfoProvide();

    await _payment.openCheckout(_payment.frameDataToCheck(payRazorUser));
  }

  void totalPriceSetter(List<Combo> allData) {
    totalPrice = 0;
    allData.forEach((element) {
      totalPrice += element.rate;
    });
  }

  void totalAddetSetter(num price) {
    setState(() {
      totalPrice += price;
    });
  }

  _createInstancefood() {
    setState(() {
      food = Food(
          combo: widget.allData,
          quantity: widget.allData
              .asMap()
              .map((key, value) => MapEntry(key.toString(), 1)));
    });
  }

  _userInfoProvide() async {
    String name;
    String email;
    int contect;

    try {
      if (await FirebaseAuth.instance.currentUser!.displayName == null) {
        name = await UserState.getUser().then((value) {
          return value.name ?? "";
        });
        email = await UserState.getUser().then((value) {
          return value.email ?? "";
        });
      } else {
        name = FirebaseAuth.instance.currentUser!.displayName!;
        email = FirebaseAuth.instance.currentUser!.email!;
      }
      UserDataManager connect = await UserState.getUser();

      if (connect.phone!.isEmpty) {
        contect = 8888888888;
      } else {
        contect = int.parse(connect.phone!);
      }

      setState(() {
        payRazorUser = PayRazorUser(
          name: name,
          email: email,
          contect: contect,
          amount: totalPrice.round(),
          food: food,
        );
      });
    } on FirebaseException catch (e) {
      print("something went wrong" + e.toString());
    }
  }

  initState() {
    super.initState();
    totalPriceSetter(widget.allData);

    isVeg = true;

    _createInstancefood();

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

  ComboLogic combo = ComboLogic();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
    _payment.dispose();
  }

  List<String> imageList = [];
  int indexProduct = 0;

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
                  // small image aside
                  Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 200,
                      child: PageView.builder(
                          controller: pageController,
                          itemCount: widget.allData.length,
                          onPageChanged: (value) {},
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder<String>(
                                future: combo.fullDataImage(
                                    widget.allData[index].type,
                                    widget.allData[index].image),
                                builder: (context,
                                    AsyncSnapshot<String> imageProduct) {
                                  return AsyncDataChecker().checkWidgetBinding(
                                      widget: Container(
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
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            gradient: shadowLayer(context),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(26),
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: MediaQuery.sizeOf(context)
                                                .width,
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
                                      ),
                                      loadingWidget: Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        height: 200,
                                      ),
                                      snapshot: imageProduct,
                                      afterBindingFunction: () {
                                        imageList.add(imageProduct.data ?? "");
                                      });
                                });
                          })),

                  Gap(20),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 120,
                    child: PageView.builder(
                        controller: pageController,
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
                      padding: EdgeInsets.only(right: 20),
                      controller: scrollController,
                      itemCount: widget.allData.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: combo.fullDataImage(
                                widget.allData[index].type,
                                widget.allData[index].image),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> imageProduct) {
                              return AsyncDataChecker().checkWidgetBinding(
                                  widget: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        indexProduct = index;
                                      });
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 20,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                imageProduct.data ?? ""),
                                            fit: BoxFit.cover),
                                        border: indexProduct == index
                                            ? Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                width: 3)
                                            : Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer
                                                    .withOpacity(0.0),
                                                width: 3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  loadingWidget: Container(
                                    width: 70,
                                    height: 20,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                              .withOpacity(0.2),
                                          width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  snapshot: imageProduct,
                                  afterBindingFunction: () {});
                            });
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
                              Text("${totalPrice}Rs")
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
                                          totalPrice +=
                                              widget.allData[index].rate;
                                        });
                                        totalAddetSetter(
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

                  const Gap(40),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Looking for similar",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
// options
                  GridProductRecommend(recData: widget.recData),

                  Gap(200)
                ],
              ),
            ),
          ),
        ),
        bottomSheet: GestureDetector(
          onTap: _payprocess,
          child: Container(
            margin:
                const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
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
          ),
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
