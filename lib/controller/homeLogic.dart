import 'package:MealBook/firebase/auth.dart';
import 'package:MealBook/respository/model/user.dart';

import 'package:MealBook/src/pages/loader/actuator.dart';

import 'package:MealBook/src/pages/loader/loading.dart';
import 'package:MealBook/src/pages/registration/register.dart';
import 'package:MealBook/respository/provider/registerState.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class homeController extends GetxController {
  AuthClass _authenticate = AuthClass();

  // UserState userData = UserState();

  Future<UserDataManager> adder() async =>
      await UserState.getUser().then((value) {
        return value;
      });

  Future<void> signOut(WidgetRef ref, BuildContext context) async {
    print("Coming signout");
    final confirmSignOut = await Flushbar<bool>(
      title: "Sign Out",
      message: "Do you want to sign out?",
      mainButton: TextButton(
        child: const Text(
          "Sign Out",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
      duration: const Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      leftBarIndicatorColor: Theme.of(context).colorScheme.primaryContainer,
    ).show(context);

    if (confirmSignOut == true) {
      try {
        _authenticate.signOut(context);

        UserState().deleteUser();
        ref.read(booleanProvider.notifier).update(false);

        snackbarCon(context, "Sign out successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Actuator(
              child: IntroPage(),
              Register: RegisterPage(),
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        snackbarCon(context, "Sign out failed");
      }
    }
  }

  // Future<List<String>> getUserData(WidgetRef ref) async {
  //   user = await UserState.getUser();
  //   return [user.name!, user.email!];
  //   //nikename = extractFirstWord(user.name!);
  //   //print(user.name);
  // }

  String extractFirstWord(String input) {
    // Split the input string by spaces
    List<String> words = input.split(' ');

    // Take the first word (if any)
    if (words.isNotEmpty) {
      return words.first;
    } else {
      // If the input string is empty, return an empty string
      return '';
    }
  }

  snackbarCon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }
}
