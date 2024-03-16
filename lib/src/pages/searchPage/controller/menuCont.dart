import 'dart:async';

import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/respository/model/filter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MenuFoodController extends GetxController {
  MenuFoodController({Key? key}) {
    loader();
  }

  @override
  void onInit() {
    super.onInit();
    loader();
  }

  Future<List<dynamic>> fetchMenu() async {
    DataSnapshot _variety;
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = ref.child('foodmenu/');
    _variety = await snapshot.get();

    List recData = [];

    for (var i in _variety.value as List<dynamic>) {
      recData.add(i);
    }

    //  print(recData);
    return recData;
  }

  Future<String> listImage(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child('foodmenu/${imageName}');
    String url = await ref.getDownloadURL();

    return url;
  }

  Future<List<dynamic>> fetchCombo(String type, String imageName) async {
    DataSnapshot _combo;
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = ref.child('combo/');
    _combo = await snapshot.get();

    List recData = [];

    for (var i in _combo.value as List<dynamic>) {
      recData.add(i);
    }

    //  print(recData);
    return recData;
  }

  List allData = [];
  List<Map<String, dynamic>> mainData = [];

  Future<void> loader() async {
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
        overallRating: item['OVERALL_RATING'] ?? 0.0,
        image: item['IMAGE'] ?? '',
        isPopular: item['POPULAR'] == "false" ? false : true,
        isVeg: item['IS_VEG'] == "false" ? false : true,
        type: item['TYPE'] ?? '',
        ingredients: indegre ?? [],
      );
      mainData.add(d.toMap());
    }
  }

  List<Map<String, dynamic>> searchfilteredData = [];

  Future<List<Map<String, dynamic>>> search() async {
    await loader();

    searchfilteredData.clear();

    for (var item in mainData) {
      if (item['POPULAR'] == true) {
        searchfilteredData.add(item);
      }
    }

    return searchfilteredData;
  }

  Future<String> searchImage(String category, String imageName) async {
    final ref = FirebaseStorage.instance.ref().child(
        'products/${category.replaceAll(" ", "").toLowerCase()}/${imageName}');
    String url = await ref.getDownloadURL();

    return url;
  }

  void deleter() {
    searchfilteredData.clear();
    allData.clear();
    mainData.clear();
  }
}
