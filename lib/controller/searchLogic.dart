import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SearchLogic extends GetxController {
  DataSnapshot? variety;

  String selectVariety = '';
  List vername = [];

  Future<void> loader() async {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = ref.child('products/');
    variety = await snapshot.get();
  }

  Future<List> fetchvariety() async {
    await loader();
    final value = variety!.value;
    if (value is Map) {
      // print(value.values);
      vername.clear();
      value.forEach((key, value) {
        vername.add(key);
      });
    }

    return vername;
  }

  Future<List> fetchvarietyData(String varietyName) async {
    Map value = variety!.value as Map;
    List? list;
    if (varietyName.isNotEmpty) {
      value.forEach((key, value) {
        if (key == varietyName) {
          list = value;
        }
      });

      return list!;
    } else {
      print("object");
      list = value["CHAT KAMAL"]; // Removed 'await'
      print("data is $list");
      return list!;
    }
  }
}
