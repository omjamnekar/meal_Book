import 'package:MealBook/respository/provider/userState.dart';
import 'package:MealBook/src/payments/model/order_Time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
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

  Future<OrderFrame> fetchData() async {
    String email = "";
    UserState.getUser().then((value) {
      email = value.email!;
    });
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
      DatabaseEvent snapshot = await databaseRef
          .child('orderSet')
          .child(email.replaceAll(".", "dot"))
          .once();

      print(snapshot.snapshot.value);
      if (snapshot.snapshot.value != null) {
        // Convert data to Map<String, dynamic>
        Map<Object?, Object?>? rawData =
            snapshot.snapshot.value as Map<Object?, Object?>?;
        if (rawData != null) {
          Map<String, dynamic> orderData =
              rawData.map((key, value) => MapEntry(key.toString(), value));
          // Use the orderData map as needed
          order = OrderFrame.fromMap(orderData, orderData['id']);
        } else {
          print("Data is null or not found.");
        }
      } else {
        print("Data is null or not found.");
      }
    } on FirebaseException catch (e) {
      print("Firebase Exception: $e");
    } catch (e) {
      print("Error: $e");
    }
    return order;
  }
}
