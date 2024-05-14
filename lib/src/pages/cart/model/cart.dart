import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/respository/model/user.dart';

// model
class Cart {
  String id;
  List<Map<String, dynamic>> comboItems;
  String email;

  Cart({
    required this.id,
    required this.comboItems,
    required this.email,
  });

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'],
      comboItems: List<Map<String, dynamic>>.from(map['comboItems']),
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comboItems': comboItems,
      'email': email,
    };
  }
}
