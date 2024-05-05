import 'dart:async';

import 'package:MealBook/respository/json/combo.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/components/asynceChecker.dart';
import 'package:MealBook/src/components/gridProductDetail.dart';
import 'package:MealBook/src/components/loaderAnimation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class FoodMenuShower extends StatelessWidget {
  const FoodMenuShower({super.key, required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Menu'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<List<dynamic>>(
              future: FoodVerity()._loadVerity(title),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> veridata) {
                return AsyncDataChecker().checkWidgetBinding(
                  widget: FoodMainMenu(
                      title: title, items: items, veridata: veridata),
                  loadingWidget: LoadingGrid(),
                  snapshot: veridata,
                  afterBindingFunction: () {},
                );
              }),
        ),
      ),
    );
  }
}

class FoodMainMenu extends StatelessWidget {
  const FoodMainMenu({
    super.key,
    required this.title,
    required this.items,
    required this.veridata,
  });

  final String title;
  final List<String> items;
  final AsyncSnapshot<List<dynamic>> veridata;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          margin: const EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 19, color: Theme.of(context).colorScheme.primary),
              ),
              IconButton(
                  onPressed: () {
                    _choosDataBeviour(context);
                  },
                  icon: Icon(Icons.splitscreen_outlined,
                      color: Theme.of(context).colorScheme.tertiary))
            ],
          ),
        ),
        Gap(10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        Gap(10),
        SingleChildScrollView(
          child: GridProductRecommend(
            recData: veridata.data ?? [],
          ),
        ),
      ],
    );
  }

  _choosDataBeviour(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUp(
              items: items,
              onTap: (choosenItem) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodMenuShower(
                      title: choosenItem,
                      items: items,
                    ),
                  ),
                );
              });
        });
  }
}

class LoadingGrid extends StatelessWidget {
  const LoadingGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  color: Colors.white,
                ),
              ),
            );
          }),
    );
  }
}

class FoodVerity {
  DataSnapshot? _variety;

  List<dynamic> dataList = [];
  Future<List<dynamic>> _loadVerity(String variety) async {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = await ref.child('variety').child(variety).once();
    _variety = await snapshot.snapshot;

    // Check if _variety!.value is a List
    if (_variety!.value is List) {
      dataList = _variety!.value as List<dynamic>;

      // Assuming each item in the list is a Map<dynamic, dynamic> containing combo data
      return dataList;
    } else {
      // Handle the case where _variety!.value is not a List
      print("Error: _variety!.value is not a List");
      return [];
    }
  }
}

class PopUp extends StatelessWidget {
  PopUp({super.key, required this.items, required this.onTap});
  final List<String> items;
  final Function(String) onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              height: 40,
              child: Text(
                'other Options',
                style: GoogleFonts.poppins(
                    fontSize: 23, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Gap(8),
            Container(
              height: MediaQuery.of(context).size.height / 2 - 100,
              width: MediaQuery.of(context).size.width - 60,
              color: Theme.of(context).colorScheme.background,
              child: Scrollbar(
                trackVisibility: true,
                showTrackOnHover: true,
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        onTap(items[index]);
                      },
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.circle_outlined,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              Text(
                                items[index],
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                              const Spacer(),
                            ],
                          )),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChooseOptionGridChanger {}
