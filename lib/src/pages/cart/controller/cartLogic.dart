import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:MealBook/src/pages/cart/provider/cartList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CartLogic {
  //variables
  bool isUserIsAvailable = false;

  //sending data to firestore
  Future<void> postDataCombo(WidgetRef ref, Combo combo) async {
    isUserIsAvailable = await _seeUserAvaible();
    UserDataManager user = await UserState.getUser();

    // seting daata to variable
    Map<String, dynamic> mapData =
        await _prepareCartDataToSend(isUserIsAvailable, combo);

    // sending data to firestore
    if (isUserIsAvailable) {
      print("User is available");

      accessCartName(ref: ref, typePross: "add", data: combo.items);
      FirebaseFirestore.instance
          .collection("Cartcollection")
          .where("email", isEqualTo: user.email)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          String id = Uuid().v4();
          String docId = snapshot.docs.first.id;
          FirebaseFirestore.instance
              .collection("Cartcollection")
              .doc(docId)
              .update({
            "comboItems": FieldValue.arrayUnion([mapData])
          });
        }
      });
    } else {
      accessCartName(ref: ref, typePross: "add", data: combo.items);
      FirebaseFirestore.instance
          .collection("Cartcollection")
          .doc()
          .set(mapData);
    }
  }

  //checking if user is available
  Future<bool> _seeUserAvaible() async {
    UserDataManager user = await UserState.getUser();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Cartcollection")
        .where("email", isEqualTo: user.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // There is at least one record with the same email
      return true;
    } else {
      // No record found with the same email
      return false;
    }
  }

  //getting user data
  Future<UserDataManager> _getUserData() {
    return UserState.getUser();
  }

  //judging if user is available
  Future<Map<String, dynamic>> _prepareCartDataToSend(
      bool isuserAvail, Combo combo) async {
    if (isuserAvail) {
      return _frameUpdateData(combo);
    } else {
      return _frameNewUserData(combo);
    }
  }

  // preparing data to send to firestore

  Future<Map<String, dynamic>> _frameNewUserData(Combo combo) async {
    UserDataManager _user = await _getUserData();
    return {
      "id": _user.id,
      "email": _user.email,
      "comboItems": [
        {(combo.items): combo.toMap()}
      ],
    };
  }

  Future<Map<String, dynamic>> _frameUpdateData(Combo combo) async {
    return {
      "${combo.items}": combo.toMap(),
    };
  }

  // share preference and local storage
  void accessCartName(
      {required WidgetRef ref,
      required String typePross,
      required String data}) async {
    // Access the provider and read the state

    if (typePross == "add") {
      // ref.watch(dataListProvider.notifier).removeAllItems();
      ref.watch(dataListProvider.notifier).addItem(data);
      print(await loadListFoodCart(ref));
    } else if (typePross == "remove") {
      ref.watch(dataListProvider.notifier).removeItem(data);
      print(await loadListFoodCart(ref));
    } // Use dataList as needed
  }

  List<String> loadListFoodCart(WidgetRef ref) {
    return ref.watch(dataListProvider).dataList;
  }
}
