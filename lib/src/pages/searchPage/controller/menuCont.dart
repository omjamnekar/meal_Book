import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MenuFoodController extends GetxController {
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
    print(imageName);
    final ref = FirebaseStorage.instance.ref().child('foodmenu/${imageName}');
    String url = await ref.getDownloadURL();

    return url;
  }
}
