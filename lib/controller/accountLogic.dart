import 'package:MealBook/controller/homeLogic.dart';

import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/respository/provider/userState.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AccountLogic extends GetxController {
  homeController home = homeController();

  Future<UserDataManager> getUser() async {
    UserDataManager user = await UserState.getUser();
    return user;
  }

  Future<void> signOut(BuildContext context, WidgetRef ref) async {
    await UserState().deleteUser();

    // deleting cart data

    home.signOut(ref, context);
  }
}
