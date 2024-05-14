import 'dart:math';

import 'package:MealBook/controller/comboLogic.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/respository/model/payInfo.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:MealBook/src/pages/cart/controller/cartLogic.dart';
import 'package:MealBook/src/pages/cart/provider/cartList.dart';
import 'package:MealBook/src/payments/loading.dart';
import 'package:MealBook/src/payments/model/order_Time.dart';
import 'package:MealBook/src/payments/pay_Op.dart';
import 'package:MealBook/src/payments/stepControl/Time_Con.dart';
import 'package:MealBook/src/payments/timeSetting/timeSetter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'controller/cartControl.dart';
import 'model/cart.dart';

class CartProssToOrder extends ConsumerStatefulWidget {
  const CartProssToOrder({super.key});

  @override
  ConsumerState<CartProssToOrder> createState() => _CartProssToOrderState();
}

class _CartProssToOrderState extends ConsumerState<CartProssToOrder> {
  int totalPrice = 0;
  CartController cartController = CartController();
  List<String> itemList = [];
  late PaymentGateWay _payment;
  bool isDarkTheme = false;
  List<List<String>> keyFromGlobal = [];
  late OrderFrame orderFrame = OrderFrame();

  late PayRazorUser payRazorUser;

  _payprocess(OrderTimeControl ord) async {
    ord.orderTime.combo = combo;
    ord.orderTime.totalPrice = totalPrice.toString();
    await _userInfoProvide();
    await _payment.openCheckout(
        _payment.frameDataToCheck(payRazorUser), ord.orderTime);
    if (_payment.isPayDone) {
      print(_payment.paymentId);
      print(_payment.orderId);
      print("Payment is done");
    } else {
      print("Payment is not done");
    }
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
        );
      });
    } on FirebaseException catch (e) {
      print("something went wrong" + e.toString());
    }
  }

  initState() {
    super.initState();
    _payment = PaymentGateWay(
      context: context,
      isCART: false,
    );
  }

  _setTotalPrice(Cart _combo) async {
    // setState(() {
    //   totalPrice = 0;
    // });

    List<String> listString = keyFromGlobal
        .map((element) => element.map((e) => e.toString()).toList())
        .toList()
        .expand((element) => element)
        .toList();

    cartController.totalPriceCount(listString, _combo).then((value) {
      setState(() {
        totalPrice = value;
      });
    });
  }

  List<Combo> combo = [];

  int qty = 1;

  CartLogic cartLogic = CartLogic();

  @override
  Widget build(BuildContext context) {
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        primary: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        title: Text(
          'Cart',
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        surfaceTintColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      body: GetBuilder<CartController>(
        init: CartController(),
        builder: (ctrl) {
          return FutureBuilder<Cart>(
              future: cartController.getCartData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _loadingImage();
                } else if (snapshot.hasError) {
                  return noDataItems(context);
                } else if (snapshot.hasData) {
                  if (snapshot.data!.comboItems.length != 0) {
                    return ListView.builder(
                      itemCount: snapshot.data!.comboItems.length,
                      padding: EdgeInsets.only(bottom: 100),
                      itemBuilder: (context, index) {
                        if (keyFromGlobal.isEmpty) {
                          print(true);
                          keyFromGlobal = snapshot.data!.comboItems
                              .map((element) => element.keys.toList())
                              .toList();

                          _setTotalPrice(snapshot.data!);
                        }

                        List<String> ingredients = snapshot
                            .data!
                            .comboItems[index][keyFromGlobal[index][0]]
                                ["INGREDIENTS"]
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', '')
                            .split(",");
                        ingredients.insert(0, "Ingredients");
                        addingComboData(snapshot);

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.15),
                                blurRadius: 50,
                                spreadRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          child: Column(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: FutureBuilder(
                                      future: ComboLogic().fullDataImage(
                                          snapshot.data!.comboItems[index]
                                              [keyFromGlobal[index][0]]["TYPE"],
                                          snapshot.data!.comboItems[index]
                                                  [keyFromGlobal[index][0]]
                                              ["IMAGE"],
                                          (imagde) {}),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> imageSnapshot) {
                                        if (imageSnapshot.connectionState ==
                                                ConnectionState.waiting &&
                                            !imageSnapshot.hasData) {
                                          return _loadingImage();
                                        } else if (imageSnapshot
                                                    .connectionState ==
                                                ConnectionState.active &&
                                            !imageSnapshot.hasData) {
                                          return _loadingImage();
                                        } else if (imageSnapshot
                                                    .connectionState ==
                                                ConnectionState.done &&
                                            imageSnapshot.hasData) {
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            margin: EdgeInsets.only(left: 3),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  imageSnapshot.data!,
                                                ),
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.3),
                                                  BlendMode.darken,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                // popular
                                                Transform.translate(
                                                  offset: Offset(-5, -5),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: snapshot.data!.comboItems[
                                                                        index][
                                                                    keyFromGlobal[
                                                                        index][0]]
                                                                ["POPULAR"] ==
                                                            true
                                                        ? containerCre(
                                                            "Popular", true)
                                                        : containerCre(
                                                            "Regular", false),
                                                  ),
                                                ),

                                                Spacer(),
                                                Container(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  padding: EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        flex: 4,
                                                        child: Text(
                                                          snapshot
                                                              .data!
                                                              .comboItems[index]
                                                                  [
                                                                  keyFromGlobal[
                                                                      index][0]]
                                                                  ["ITEMS"]
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              size: 25,
                                                              Icons
                                                                  .arrow_drop_down_sharp,
                                                              color: snapshot.data!.comboItems[index]
                                                                              [
                                                                              keyFromGlobal[index][0]]
                                                                          [
                                                                          "IS_VEG"] ==
                                                                      true
                                                                  ? Colors.green
                                                                  : Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary,
                                                            ),
                                                            Text(
                                                              snapshot.data!.comboItems[
                                                                          index][keyFromGlobal[
                                                                              index]
                                                                          [
                                                                          0]]["IS_VEG"] ==
                                                                      true
                                                                  ? "Veg"
                                                                  : "Non-Veg",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            !snapshot.hasData) {
                                          return _loadingImage();
                                        }
                                        return _loadingImage();
                                      }),
                                ),
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(
                                          right: 5,
                                          left: 5,
                                          top: 10,
                                          bottom: 10),
                                      child: Column(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                      flex: 7,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                        ),
                                                        child: Text(
                                                          "${snapshot.data!.comboItems[index][keyFromGlobal[index][0]]["DESCRIPTION"]}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      )),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "${snapshot.data!.comboItems[index][keyFromGlobal[index][0]]["RATE"]}Rs",
                                                              style: GoogleFonts.poppins(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary),
                                                            ),
                                                            Gap(10),
                                                            Text(
                                                              "Qty: $qty",
                                                              style: GoogleFonts.poppins(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .tertiary),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex: 3,
                                                  child: Container(
                                                    width: 220,
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),
                                                    child:
                                                        DropdownButton<String>(
                                                      elevation: 12,
                                                      focusColor: Colors.white,
                                                      value: "Ingredients",
                                                      //elevation: 5,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      iconEnabledColor:
                                                          Colors.black,
                                                      items: ingredients.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(
                                                            value,
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      hint: const Text(
                                                        "Please choose a food",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      onChanged:
                                                          (String? value) {},
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Row(
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              //  _payprocess();
                                                            },
                                                            child:
                                                                Text("Repeat"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              // ctrl.deleteCartData(
                                                              //     ref,
                                                              //     snapshot.data!
                                                              //             .comboItems[
                                                              //         index][keyFromGlobal[
                                                              //             index]
                                                              //         [0]], () {
                                                              //   setState(() {
                                                              //     _setTotalPrice(
                                                              //         snapshot
                                                              //             .data!);
                                                              //   });
                                                              // });
                                                            },
                                                            child:
                                                                Text("Remove"),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))),
                            ],
                          ),

                          // child: Text(snapshot
                          //     .data!.comboItems[index]["comboItems"][0]["ITEMS"]
                          //     .toString()),
                        );
                      },
                    );
                  } else {
                    return noDataItems(context);
                  }
                } else {
                  return _loadingImage();
                }
              });
        },
      ),
      bottomSheet: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              blurRadius: 40,
              spreadRadius: 0.5,
            ),
          ],
          color: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: $totalPrice Rs',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimeLoading(
                      child: TimeSetter(
                        isCart: false,
                        combo: combo,
                        onTimeSetted: (orderTimeControl) async {
                          setState(() {
                            orderFrame = orderTimeControl.orderTime;
                          });

                          await _payprocess(
                              orderTimeControl as OrderTimeControl);
                        },
                      ),
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              child: Text(
                'Proceed to Order',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center noDataItems(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Gap(250),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(130),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.04)),
          child: Lottie.asset(
            isDarkTheme
                ? 'assets/lottie/darkMode/noItemCart_Dark.json'
                : 'assets/lottie/noItemCart.json',
            width: 100,
            height: 100,
          ),
        ),
        Gap(40),
        Text(
          'yet to add items to cart!\nLet\'s and have good food!',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ));
  }

  Widget _loadingImage() {
    return Shimmer(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
        ),
        gradient: LinearGradient(colors: [
          Colors.grey.withOpacity(0.5),
          Colors.grey.withOpacity(0.3),
          Colors.grey.withOpacity(0.1),
        ]));
  }

  Widget loadingS(AsyncSnapshot<Cart> snapshot, Widget widget) {
    if (snapshot.connectionState == ConnectionState.waiting &&
        !snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.connectionState == ConnectionState.active &&
        !snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.connectionState == ConnectionState.none &&
        !snapshot.hasData) {
    } else if (snapshot.connectionState == ConnectionState.done &&
        !snapshot.hasData) {
      return widget;
    }

    return Container();
  }

  Widget containerCre(String text, bool isPopular) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isPopular == true
            ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
            : Colors.blueAccent.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  addingComboData(AsyncSnapshot<Cart> snapshot) {
    combo.clear();
    snapshot.data!.comboItems.forEach((item) {
      item.forEach((key, value) {
        combo.add(Combo(
          id: value["ID"],
          items: value["ITEMS"],
          rate: value["RATE"],
          type: value["TYPE"],
          image: value["IMAGE"],
          isVeg: value["IS_VEG"],
          description: value["DESCRIPTION"],
          ingredients: List<String>.from(value["INGREDIENTS"]),
          category: value["CATEGORY"],
          available: value["AVAILABLE"],
          likes: value["LIKES"],
          overallRating: value["OVERALL_RATING"],
          isPopular: value["POPULAR"],
        ));
      });
    });
  }
}
