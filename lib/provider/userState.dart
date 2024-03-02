import 'dart:convert';

import 'package:MealBook/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserState {
  static Future<void> insertUser({required UserDataManager userData}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(userData.toJson()));
  }

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  static Future<UserDataManager> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      Map<String, dynamic> userJson = jsonDecode(userString);
      return UserDataManager(
        Uuid().v4(),
        email: userJson["email"] ?? '',
        password: userJson["password"] ?? '',
        name: userJson["name"] ?? '',
        phone: userJson["phone"] ?? '',
        image: userJson["image"] ?? "",
      );
    }
    return UserDataManager(
      Uuid().v4(),
      email: '',
      password: '',
      name: '',
      phone: '',
      image: null,
    );
  }
}
