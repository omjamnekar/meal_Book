import 'package:MealBook/respository/json/combo.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/respository/model/filter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  SearchPageController({Key? key}) {
    searchController.addListener(() {
      search();
    });
  }

  @override
  void onInit() {
    super.onInit();
    loader();
  }

  List<dynamic> allData = [];
  List<Map<String, dynamic>> mainData = [];
  List<Map<String, dynamic>> searchfilteredData = [];
  bool isSearchFilter = false;
  TextEditingController searchController = TextEditingController();

  Future<void> search() async {
    searchfilteredData.clear(); // Clear previous search results

    if (!searchController.text.isNotEmpty) {
      searchfilteredData
          .addAll(mainData); // Cast each item to Map<String, dynamic>
    } else {
      String searchText = searchController.text.toLowerCase();

      //  print(mainData);
      for (var item in mainData) {
        if (item['ITEMS'].toLowerCase().contains(searchText) ||
            item['CATEGORY'].toLowerCase().contains(searchText) ||
            item['DESCRIPTION'].toLowerCase().contains(searchText) ||
            item['TYPE'].toLowerCase().contains(searchText) ||
            (item['INGREDIENTS'] as List<String>).any((ingredient) =>
                ingredient.toLowerCase().contains(searchText))) {
          isSearchFilter = true;
          searchfilteredData.add(item);
        }
      }

      //  print(searchfilteredData);
    }
  }

  static Future<String> searchImage(String category, String imageName) async {
    final ref = FirebaseStorage.instance.ref().child(
        'products/${category.replaceAll(" ", "").toLowerCase()}/${imageName}');
    String url = await ref.getDownloadURL();

    return url;
  }

  Future<void> filterCategory(
    FilterManager filter,
  ) async {
    if (searchfilteredData.isEmpty) {
      await loader();

      searchfilteredData.addAll(mainData);
    }
    print(searchfilteredData);
    searchfilteredData = searchfilteredData
        .where((element) =>
            element['RATE'] <= filter.maxPrice! &&
            element['RATE'] >= filter.minPrice!)
        .toList();
  }

  Future<List<dynamic>> loader() async {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = ref.child('all/');

    DataSnapshot _all = await snapshot.get();
    allData.clear();
    mainData.clear();

    for (var i in _all.value as List<dynamic>) {
      allData.add(i);
    }

    for (var item in allData) {
      List<String> indegre = [];

      for (var i in item['INGREDIENTS']) {
        String str = i.toString();
        indegre.add(str);
      }

      Combo d = Combo(
        id: item['ID'] ?? 0,
        items: item['ITEMS'] ?? '',
        rate: item['RATE'] ?? 0.0,
        description: item['DESCRIPTION'] ?? '',
        category: item['CATEGORY'] ?? '',
        available: item['AVAILABLE'] == "false" ? false : true,
        likes: item['LIKES'] ?? 0.0,
        isPopular: item['POPULAR'] == "false" ? false : true,
        overallRating: item['OVERALL_RATING'] ?? 0.0,
        image: item['IMAGE'] ?? '',
        isVeg: item['IS_VEG'] == "false" ? false : true,
        type: item['TYPE'] ?? '',
        ingredients: indegre ?? [],
      );
      mainData.add(d.toMap());
    }
    return allData;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  void deleter() {
    mainData.clear();
    searchfilteredData.clear();
  }
}
