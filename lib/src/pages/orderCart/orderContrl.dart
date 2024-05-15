import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:MealBook/src/payments/model/order_Time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  OrderFrame order = OrderFrame();

  OrderController() {
    UserState.getUser().then((value) {
      order.userid = value!.id;
      order.email = value.email;
      order.name = value.name;
    });
  }

  Future<Map<dynamic, dynamic>> fetchData() async {
    String email = "";
    DataSnapshot? _variety;
    UserDataManager user = await UserState.getUser();
    try {
      final ref = FirebaseDatabase.instance.reference();
      final snapshot =
          ref.child('orderSet/').child("${email.replaceAll(".", "dot")}/");
      _variety = await snapshot.get();

      if (_variety!.value != null) {
        if (_variety!.value is Map<dynamic, dynamic>) {
          final Map<dynamic, dynamic> data =
              _variety!.value as Map<dynamic, dynamic>;
          final Map<String, dynamic> resultMap = {};

          // Manually check and convert each key and value
          data.forEach((key, value) {
            if (key is String) {
              resultMap[key] = value;
            }
          });

          email = user.email!;
          late List<Combo> _combo = [];
          // if (resultMap[email.replaceAll(".", "dot")]["combo"] != null) {
          //  List path = resultMap[email.replaceAll(".", "dot")]["combo"];

          //   path.forEach((element) {
          //     List ingriendents = [];
          //     element["INGREDIENTS"].forEach((item) {
          //       ingriendents.add(item);
          //     });

          //     //print(num.tryParse(element["OVERALL_RATING"]));

          //     _combo.add(
          //       Combo(
          //         id: int.parse(element["ID"]),
          //         items: element["ITEMS"],
          //         rate: num.parse(element["RATE"]),
          //         description: element["DESCRIPTION"],
          //         category: element["CATEGORY"],
          //         available: element["AVAILABLE"] == "true" ? true : false,
          //         likes: num.parse(element["LIKES"]),
          //         overallRating: num.parse(element["OVERALL_RATING"]),
          //         image: element["IMAGE"],
          //         isPopular: element["POPULAR"] == "true" ? true : false,
          //         isVeg: element["IS_VEG"] == "true" ? true : false,
          //         type: element["TYPE"],
          //         ingredients: ingriendents as List<String>,
          //       ),
          //     );
          //   });

          //   print(_combo[0].id);
          // }

          // Map<String, dynamic> dataMap =
          //     resultMap[email.replaceAll(".", "dot")];
          // DateTime time =
          //     DateTime.parse(resultMap[email.replaceAll(".", "dot")]['time']);
          // DateTime current = DateTime.parse(resultMap[email]['receieveTime']);
          // order = OrderFrame(
          //   id: resultMap[email]['id'],
          //   combo: (resultMap[email]['combo'] as List)
          //       .map((e) => Combo.fromMap(e))
          //       .toList(),
          //   name: resultMap[email]['name'],
          //   email: resultMap[email]['email'],
          //   userid: resultMap[email]['userid'],
          //   totalPrice: resultMap[email]['totalPrice'],
          //   paymentId: resultMap[email]['paymentId'],
          //   receieveTime: current,
          //   currenttime: time,
          // );
          return resultMap[user.email!.replaceAll(".", "dot")];
        } else {
          print("Data is not a Map<String, dynamic>");
          // Handle this case accordingly, maybe by throwing an exception or returning null.
        }
      }
    } on FirebaseDatabase catch (e) {
      print(e);
    }
    return {}; // Return an empty map if no data is found or if there's an error
  }

  Future<String> imageCache(String veriety, String urlImage) async {
    print("products/${veriety}/${urlImage}");
    final ref = FirebaseStorage.instance
        .ref()
        .child("products/${veriety.toLowerCase()}/${urlImage}");
    String url = await ref.getDownloadURL();
    return url;
  }
}
