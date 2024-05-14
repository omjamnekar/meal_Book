import 'dart:core';
import 'package:uuid/uuid.dart';
import 'package:MealBook/respository/model/combo.dart';

class PayRazorUser {
  String id;
  String name;
  String email;
  int contect;
  int amount;
  Food? food;

  PayRazorUser({
    required this.name,
    required this.email,
    required this.contect,
    required this.amount,
    this.food,
  }) : id = Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contect': contect,
      'amount': amount,
      'food': food,
    };
  }

  // Rest of the code...
  factory PayRazorUser.fromJson(Map<String, dynamic> json) {
    return PayRazorUser(
      name: json['name'],
      email: json['email'],
      contect: json['contect'],
      amount: json['amount'],
      food: json['food'],
    );
  }
}

class Food {
  String id;
  List<Combo> combo;
  Map<String, int> quantity;

  Food({
    required this.combo,
    required this.quantity,
  }) : id = Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'combo': combo,
      'quantity': quantity,
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      combo: json['combo'],
      quantity: json['quantity'],
    );
  }
}
