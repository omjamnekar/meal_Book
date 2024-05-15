import 'package:MealBook/src/pages/orderCart/orderContrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail(
      {super.key, required this.order, required this.arrivalTime});
  final Map<dynamic, dynamic> order;
  final String arrivalTime;
  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final OrderController orderController = OrderController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    "${widget.arrivalTime}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ":Arrival Time",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: widget.order["combo"].length,
          itemBuilder: (context, index) {
            return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8.0),
                height: 120,
                child: Column(
                  children: [
                    Row(
                      children: [
                        FutureBuilder<String>(
                            future: orderController.imageCache(
                                widget.order["combo"][index]["TYPE"],
                                widget.order["combo"][index]["IMAGE"]),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data.toString()),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 100,
                                  height: 100,
                                );
                              }
                            }),
                        Gap(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    widget.order["combo"][index]["ITEMS"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: widget.order["combo"][index]
                                                  ["IS_VEG"] !=
                                              "true"
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    Gap(5),
                                    Text(
                                      widget.order["combo"][index]["IS_VEG"] ==
                                              "true"
                                          ? "V"
                                          : "N-V",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Gap(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${widget.order["combo"][index]["RATE"].toString()}Rs",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Gap(10),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                      "${widget.order["combo"][index]["DESCRIPTION"]}"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ));
          },
        ),
      ),
      bottomSheet: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Total: ${widget.order["totalPrice"]}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: ListView.builder(
                              padding: EdgeInsets.all(10.0),
                              itemCount: widget.order.length,
                              itemBuilder: (context, index) {
                                if (widget.order.keys.elementAt(index) !=
                                    "combo") {
                                  return ListTile(
                                    title: Text(
                                        widget.order.keys.elementAt(index)),
                                    subtitle: Text(widget.order.values
                                        .elementAt(index)
                                        .toString()),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Detail",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
