import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/components/navigateTodetail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComboToNavigator {
  late List<Combo> _combo;
  late List<Map<dynamic, dynamic>> _allData;
  Future<void> navigatorToDetailThroughDataSetter(
      List<String> optionFood, BuildContext context) async {
    // set data
    await allDataLoader();
    // filter data
    await filterData(optionFood);
    // navigate to detail
    NavigatorToDetail().navigatorToProDetail(
      context,
      _combo,
      _allData,
      false,
    );
  }

  Future<void> filterData(List<String> optionFood) async {
    // filter data

    optionFood = optionFood.map((e) => e.toLowerCase()).toList();
    List<Map<dynamic, dynamic>> filteredData = _allData
        .where((element) =>
            optionFood.contains((element['ITEMS'] as String).toLowerCase()))
        .toList();

    _combo = filteredData
        .map((e) => Combo(
              id: e['ID'],
              items: e['ITEMS'],
              rate: e['RATE'],
              description: e['DESCRIPTION'],
              category: e['CATEGORY'],
              available: e['AVAILABLE'] == 'true' ? true : false,
              likes: e['LIKES'],
              isPopular: e['POPULAR'] == 'true' ? true : false,
              overallRating: e['OVERALL_RATING'],
              image: e['IMAGE'],
              isVeg: e['IS_VEG'] == 'true' ? true : false,
              type: e['TYPE'],
              ingredients: List<String>.from(e['INGREDIENTS']),
            ))
        .toList();
  }

  Future<void> allDataLoader() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    DataSnapshot snapshot = await databaseReference.child('all/').get();

    if (snapshot.value != null && snapshot.value is List<dynamic>) {
      _allData =
          List<Map<dynamic, dynamic>>.from(snapshot.value as List<dynamic>);
      print(_allData);
    } else {
      print('No data found');
    }
  }
}
