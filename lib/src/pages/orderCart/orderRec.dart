import 'dart:async';

import 'package:MealBook/src/pages/orderCart/orderContrl.dart';
import 'package:MealBook/src/pages/orderCart/orderDetail.dart';
import 'package:MealBook/src/payments/model/order_Time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class OrderRec extends StatefulWidget {
  const OrderRec({super.key});

  @override
  State<OrderRec> createState() => _OrderRecState();
}

class _OrderRecState extends State<OrderRec>
    with SingleTickerProviderStateMixin {
  OrderController _orderController = OrderController();
  late TabController _tabController;
  String timArrival = "";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Received'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Your Orders'),
              Tab(text: 'All Orders'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            GetBuilder(
              init: _orderController,
              builder: (ctrl) {
                return FutureBuilder<Map<dynamic, dynamic>>(
                  future: _orderController.fetchData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('No data'));
                    }

                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      print(snapshot.data);
                      _timeAdjuster(snapshot.data!["receieveTime"]);
                      return SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                child: Text(""),
                              ),
                              Container(
                                height: 70 * (snapshot.data!.length) / 2,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: GridLeader(
                                              orderController: _orderController,
                                              snapshot: snapshot),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                "${snapshot.data!["totalPrice"]}Rs",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                ),
                                              ),
                                            ),
                                            Gap(10),
                                            Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  10,
                                              child: Text(
                                                (snapshot.data!["combo"]
                                                        .map((item) {
                                                  return "${item["ITEMS"]}\n";
                                                }).toString())
                                                    .replaceAll("(", "")
                                                    .replaceAll(")", "")
                                                    .replaceAll(",", ""),
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            flex: 2,
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text("${timArrival}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.end,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 26,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiary,
                                                      )),
                                                  Gap(5),
                                                  Text(
                                                    "Arrival Time",
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Order ID: ${snapshot.data!["id"]}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                              ),
                                              Text(
                                                "Order Time: ${snapshot.data!["time"]}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetail(
                                                    order: snapshot.data!,
                                                    arrivalTime: timArrival,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Details",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red),
                                            ),
                                            style: ButtonStyle(
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 60)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withOpacity(0.2)),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              "Cancel Order",
                                              style: GoogleFonts.poppins(
                                                  color: const Color.fromARGB(
                                                      255, 168, 168, 168)),
                                            ),
                                            style: ButtonStyle(
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withOpacity(0.2)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Center(child: Text('No data'));
                    }
                    return Center(child: Text('No data'));
                  },
                );
              },
            ),
            Center(child: Text('No Orders')),
          ],
        ));
  }

  void _timeAdjuster(String time) {
    DateTime arrivalTime = DateTime.parse(time);

    int hour = arrivalTime.hour;
    int minute = arrivalTime.minute;

    String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) {
      hour -= 12; // Convert to 12-hour format
    } else if (hour == 0) {
      hour = 12; // Midnight (0) should be represented as 12 AM
    }

    timArrival = '$hour:$minute $period';
  }
}

class GridLeader extends StatelessWidget {
  GridLeader(
      {super.key,
      required OrderController orderController,
      required this.snapshot})
      : _orderController = orderController;

  final OrderController _orderController;
  final AsyncSnapshot<Map<dynamic, dynamic>> snapshot;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.5,
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 1),
        itemCount: snapshot.data!["combo"].length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
              future: _orderController.imageCache(
                  snapshot.data!["combo"][index]["TYPE"],
                  snapshot.data!["combo"][index]["IMAGE"]),
              builder: (context, AsyncSnapshot<String> image) {
                if (image.connectionState == ConnectionState.done &&
                    image.hasData) {
                  return Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image:
                            DecorationImage(image: NetworkImage(image.data!))),
                  );
                }

                return Container(
                  width: double.maxFinite,
                  height: 80,
                  child: Shimmer(
                      child: Container(),
                      gradient: LinearGradient(
                          colors: [Colors.grey, Colors.white, Colors.grey])),
                );
              });
        });
  }
}
