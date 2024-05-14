import 'package:MealBook/respository/provider/userState.dart';
import 'package:MealBook/src/payments/model/order_Time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class OrderTimeControl extends GetxController {
  OrderFrame orderTime = OrderFrame();

  OrderTimeControl() {
    UserState.getUser().then((value) {
      orderTime.userid = value!.id;
      orderTime.email = value.email;
      orderTime.name = value.name;
    });
  }

// after time setting page
  Future<void> setValue(
    Timestamp currentTime,
    Timestamp receieveTime,
  ) async {
    orderTime.currenttime = currentTime;
    orderTime.receieveTime = receieveTime;
  }

// final after payment
  void setDataToCanteenSet() {
    DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
    databaseRef.child('orderSet').child(orderTime.email!).set({
      // user specific data
      'id': orderTime.id,
      'name': orderTime.name,
      'email': orderTime.email,
      'userid': orderTime.userid,

      // time specific data
      'combo': orderTime.combo!.map((e) => e.toMap()).toList(),
      'receieveTime': orderTime.receieveTime,
      'time': orderTime.currenttime,

      // payment after data

      'paymentId': orderTime.paymentId,
    });
  }

  // realtime data
  // user data
  Future<void> setDataOrderSetValueToRealTime(OrderFrame orderTime) async {
    //  UserDataManager user = await UserState.getUser();
    DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
    print(orderTime.email!);
    databaseRef
        .child('orderSet')
        .child(orderTime.email!.replaceAll(".", "dot"))
        .set(
      {
        'id': orderTime.id,
        'name': orderTime.name,
        'email': orderTime.email,
        'userid': orderTime.userid,
        'combo': orderTime.combo!.map((e) => e.toMap()).toList(),
        'totalPrice': orderTime.totalPrice,
        'receieveTime': orderTime.receieveTime!.millisecondsSinceEpoch,
        'time': orderTime.currenttime!.millisecondsSinceEpoch,
        'paymentId': orderTime.paymentId,
      },
    );
  }
}
