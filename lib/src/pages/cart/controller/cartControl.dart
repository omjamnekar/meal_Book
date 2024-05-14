import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/src/pages/cart/model/cart.dart';
import 'package:MealBook/src/pages/cart/provider/cartList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../respository/provider/userState.dart';

class CartController extends GetxController {
  //variables
  late Cart cartList;
  //getting data from firestore
  Future<Cart> getCartData() async {
    try {
      UserDataManager user = await UserState.getUser();
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Cartcollection")
          .where("email", isEqualTo: user.email)
          .get();

      snapshot.docs.forEach((element) {
        Map<String, dynamic> data = {
          "id": (element.data() as Map<String, dynamic>)["id"],
          "email": (element.data() as Map<String, dynamic>)["email"],
          "comboItems": (element.data() as Map<String, dynamic>)["comboItems"],
        };

        cartList = Cart.fromMap(data);
      });

      return cartList;
    } on FirebaseException catch (e) {
      print(e);
    }

    return cartList;
  }

  Future<int> totalPriceCount(List<String> item, Cart _cart) async {
    int index = 0;
    int totalPrice = 0;

    _cart.comboItems.forEach((element) {
      totalPrice += int.parse(element[item[index]]["RATE"].toString());
      index++;
    });

    return totalPrice.toInt();
  }

  //deleting data from firestore
  Future<void> deleteCartData(
      WidgetRef ref, Map<String, dynamic> cartItem, Function() refresh) async {
    Get.snackbar("${cartItem["ITEMS"]}", "do you want to delete this item?",
        onTap: (val) {});
    UserDataManager user = await UserState.getUser();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Cartcollection")
        .where("email", isEqualTo: user.email)
        .get();

    Map<String, dynamic> data = {cartItem["ITEMS"]: cartItem};
    try {
      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;

        ref.watch(dataListProvider.notifier).removeItem(cartItem["ITEMS"]);

        await FirebaseFirestore.instance
            .collection("Cartcollection")
            .doc(docId)
            .update({
          "comboItems":
              FieldValue.arrayRemove([data]) // Remove the item from array
        });
      }
    } on FirebaseException catch (e) {
      print("Error deleting cart item: $e");
    }
  }

  Future<void> deleteCartDataPermant() async {
    UserDataManager user = await UserState.getUser();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Cartcollection")
        .where("email", isEqualTo: user.email)
        .get();

    print("process");
    try {
      // if (snapshot.docs.isNotEmpty) {
      //   String docId = snapshot.docs.first.id;
      //   print(docId);
      //   await FirebaseFirestore.instance
      //       .collection("Cartcollection")
      //       .doc(docId)
      //       .update({
      //     "comboItems": FieldValue.delete() // Remove the item from array,
      //   });
      // }
    } on FirebaseException catch (e) {
      print("Error deleting cart item: $e");
    }
  }
}
