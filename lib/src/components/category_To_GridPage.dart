import 'package:MealBook/src/components/asynceChecker.dart';
import 'package:MealBook/src/components/gridProductDetail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class CategoryToGrid extends StatefulWidget {
  CategoryToGrid(
      {super.key, required this.lottieImage, required this.categoryName});

  String lottieImage;
  String categoryName;
  @override
  State<CategoryToGrid> createState() => _CategoryToGridState();
}

class _CategoryToGridState extends State<CategoryToGrid> {
  LoadingSpecificData loadingSpecificData = LoadingSpecificData();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName.toUpperCase(),
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: FutureBuilder(
          future: loadingSpecificData.loadingSpecific(widget.categoryName),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<dynamic, dynamic>>> categoryData) {
            if (categoryData == null || categoryData.data == null) {
              return LoadingScreenIconLottie(
                lottieImage: widget.lottieImage,
                categoryName: widget.categoryName,
              );
            }

            if (loadingSpecificData.isData == false) {
              return Center(
                child: Container(
                  child: Column(
                    children: [
                      Gap(80),
                      isDarkMode
                          ? Lottie.asset(
                              "assets/lottie/darkMode/noDataDark.json",
                              height: 200,
                              width: 200,
                              animate: true,
                              repeat: true,
                            )
                          : Lottie.asset(
                              "assets/lottie/noData.json",
                              height: 200,
                              width: 200,
                              animate: true,
                              repeat: true,
                            ),
                      Text("No Data Found",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.3),
                          )),
                    ],
                  ),
                ),
              );
            }
            return AsyncDataChecker().checkWidgetBinding(
              widget: SingleChildScrollView(
                  child: GridProductRecommend(recData: categoryData.data!)),
              loadingWidget: LoadingScreenIconLottie(
                  lottieImage: widget.lottieImage,
                  categoryName: widget.categoryName),
              snapshot: categoryData,
              afterBindingFunction: () {},
            );
          }),
    );
  }
}

class LoadingScreenIconLottie extends StatelessWidget {
  LoadingScreenIconLottie(
      {super.key, required this.lottieImage, required this.categoryName});
  String lottieImage;
  String categoryName;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          children: [
            Lottie.asset(
              lottieImage,
              height: 200,
              width: 200,
              animate: true,
              repeat: true,
            ),
            Text(categoryName),
          ],
        ),
      ),
    );
  }
}

// load data to the main branch
class LoadingSpecificData {
  bool isData = false;
  List<Map<dynamic, dynamic>> _allData = [];
  Future<List<Map<dynamic, dynamic>>> loadingSpecific(String category) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    DataSnapshot snapshot =
        await databaseReference.child("${category.toLowerCase()}/").get();
    if (snapshot.value != null && snapshot.value is List<dynamic>) {
      _allData =
          List<Map<dynamic, dynamic>>.from(snapshot.value as List<dynamic>);
      isData = true;
      return _allData;
    } else {
      print('No data found');
      isData = false;
      return [];
    }
  }
}
