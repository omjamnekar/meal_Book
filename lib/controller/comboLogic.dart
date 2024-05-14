import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ComboLogic extends GetxController {
  DataSnapshot? _variety;

  DataSnapshot? _recommend;
  String selectVariety = '';
  List vername = [];
  List recData = [];

  Future<void> loader() async {
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = ref.child('variety/');
    _variety = await snapshot.get();
  }

  List<dynamic> imageUrlCombo = [];

  Future<List<dynamic>> fetchImage(
      String variety, List<dynamic> verData) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("products/${variety}/");
      ListResult result = await storageReference.listAll();
      imageUrlCombo.clear();

      for (var element in verData) {
        String imageName = element["IMAGE"];

        for (Reference ref in result.items) {
          if (ref.name == imageName) {
            String url = await ref.getDownloadURL();
            imageUrlCombo.add(url);

            break;
          }
        }
      }

      return imageUrlCombo;
    } catch (e, stackTrace) {
      print("Error getting image URL: $e");
      print("Stack Trace: $stackTrace");
      return [];
    }
  }

  Future<List> fetchvariety() async {
    await loader();
    final value = _variety!.value;
    if (value is Map) {
      vername.clear();
      value.forEach((key, value) {
        vername.add(key);
      });
    }

    return vername;
  }

  Future<List> fetchvarietyData(String varietyName) async {
    await loader(); // Move loader outside the try block
    await fetchImage("CHAT KAMAL", vername);
    try {
      Map value = _variety!.value as Map;
      List? list;

      if (varietyName.isNotEmpty) {
        value.forEach((key, value) {
          if (key == varietyName) {
            list = value;
          }
        });

        return list!;
      } else {
        list = value["CHAT KAMAL"];

        return list!;
      }
    } catch (e, stackTrace) {
      print("Error: $e");
      print("Stack Trace: $stackTrace");
      throw e;
    }
  }

  Future<List<dynamic>> fullData(String _selectFoodType) async {
    final ref = FirebaseDatabase.instance.reference();

    final snapshot =
        ref.child('${_selectFoodType.toLowerCase().replaceAll(" ", "")}/');
    _recommend = await snapshot.get();

    final value = _recommend!.value;

    if (value is List) {
      // Assuming value is a List<dynamic>
      recData = List.from(value);
    } else {}

    return recData;
  }

  Future<String> fullDataImage(
      String category, String foodname, Function(String) image) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(
          "products/${category.toLowerCase().replaceAll(" ", "")}/${foodname}");
      String url = await storageReference.getDownloadURL();
      image(url);
      return url;
    } catch (e, stackTrace) {
      print("Error getting image URL: $e");
      print("Stack Trace: $stackTrace");
      return "";
    }
  }
}
