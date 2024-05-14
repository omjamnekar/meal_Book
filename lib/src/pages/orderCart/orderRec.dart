import 'package:MealBook/src/pages/orderCart/orderContrl.dart';
import 'package:MealBook/src/payments/model/order_Time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRec extends StatefulWidget {
  const OrderRec({super.key});

  @override
  State<OrderRec> createState() => _OrderRecState();
}

class _OrderRecState extends State<OrderRec>
    with SingleTickerProviderStateMixin {
  OrderController _orderController = OrderController();
  late TabController _tabController;

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
                return FutureBuilder<OrderFrame>(
                  future: _orderController.fetchData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<OrderFrame> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('No data'));
                    }
                    if (snapshot.hasData) {
                      return Center(child: Text('Data: ${snapshot.data}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Center(child: Text('No data'));
                    }
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Center(child: Text('Data: ${snapshot.data!.id}'));
                    }
                    return Center(child: Text('No data'));
                  },
                );
              },
            ),
            Center(child: Text('All Orders')),
          ],
        )
        // body: GetBuilder(
        //   init: _orderController,
        //   builder: (ctrl) {
        //     return FutureBuilder<OrderFrame>(
        //       future: _orderController.fetchData(),
        //       builder:
        //           (BuildContext context, AsyncSnapshot<OrderFrame> snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return Center(child: CircularProgressIndicator());
        //         }
        //         if (snapshot.hasError) {
        //           return Center(child: Text('Error: ${snapshot.error}'));
        //         }
        //         if (snapshot.hasData) {
        //           return Center(child: Text('Data: ${snapshot.data}'));
        //         }

        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return Center(child: CircularProgressIndicator());
        //         }
        //         if (snapshot.connectionState == ConnectionState.none) {
        //           return Center(child: Text('No data'));
        //         }
        //         if (snapshot.connectionState == ConnectionState.done &&
        //             snapshot.hasData) {
        //           return Center(child: Text('Data: ${snapshot.data}'));
        //         }
        //         return Center(child: Text('No data'));
        //       },
        //     );
        //   },
        // ),
        );
  }
}
