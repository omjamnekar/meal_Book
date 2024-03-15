import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountInfo extends GetxController {
  UserState user = UserState();

  Future<void> deleteUser() async {
    await user.deleteUser();
  }

  Future<void> insertUser({required UserDataManager userData}) async {
    await UserState.insertUser(userData: userData);
  }
}
