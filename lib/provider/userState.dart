import 'dart:convert';

import 'package:MealBook/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = StateNotifierProvider<UserState, UserDataManager>((ref) {
  return UserState();
});

class UserState extends StateNotifier<UserDataManager> {
  UserState()
      : super(
            UserDataManager()); // Pass a default User instance to the super constructor

  Future<void> insertUser(UserDataManager user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson().toString());
    state = user;
  }

  Future<void> updateUser(UserDataManager user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson().toString());
    state = user;
  }

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    state = UserDataManager();
  }

  Future<UserDataManager?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      Map<String, dynamic> userJson = jsonDecode(userString);
      UserDataManager userData = UserDataManager.fromJson(userJson);
      state = userData;
      return userData;
    }
    return null;
  }
}
