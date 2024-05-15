import 'package:MealBook/respository/model/combo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class OrderFrame {
  String? id;
  List<Combo>? combo;
  String? name;
  String? email;
  String? userid;
  String? totalPrice;

  String? paymentId;
  DateTime? receieveTime;

  DateTime? currenttime;

  OrderFrame({
    this.combo,
    this.name,
    this.email,
    String? id,
    this.userid,
    this.totalPrice,
    this.paymentId,
    this.receieveTime,
    this.currenttime,
  }) : id = id ?? Uuid().v4();

  factory OrderFrame.fromMap(Map<String, dynamic> data) {
    final List<Combo> combo =
        (data['combo'] as List).map((e) => Combo.fromMap(e)).toList();
    DateTime revc = data['receieveTime'].toDate();
    DateTime time = data['time'].toDate();

    return OrderFrame(
      id: data['id'],
      combo: combo,
      name: data['name'],
      email: data['email'],
      userid: data['userid'],
      totalPrice: data['totalPrice'],
      paymentId: data['paymentId'],
      receieveTime: revc,
      currenttime: time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'combo': combo!.map((e) => e.toMap()).toList(),
      'name': name,
      'email': email,
      'userid': userid,
      'paymentId': paymentId,
      'totalPrice': totalPrice,
      'receieveTime': receieveTime,
      'time': currenttime,
    };
  }
}
