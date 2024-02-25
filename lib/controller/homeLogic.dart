import 'package:MealBook/firebase/auth.dart';
import 'package:MealBook/model/user.dart';
import 'package:MealBook/pages/actuator.dart';
import 'package:MealBook/pages/auth.dart';
import 'package:MealBook/pages/loading.dart';
import 'package:MealBook/pages/register/register.dart';
import 'package:MealBook/provider/registerState.dart';
import 'package:MealBook/provider/userState.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class homeController extends GetxController {
  AuthClass _authenticate = AuthClass();
  UserDataManager user = UserDataManager(
    email: "abc@gmail.com",
    name: "abc",
    password: "12345568",
    phone: "3456789",
  );

  Future<void> signOut(WidgetRef ref, BuildContext context) async {
    print("Coming signout");
    final confirmSignOut = await Flushbar<bool>(
      title: "Sign Out",
      message: "Do you want to sign out?",
      mainButton: TextButton(
        child: Text(
          "Sign Out",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
      duration: Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.all(Radius.circular(8)),
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
        ref.read(userProvider.notifier).deleteUser();
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

  Future<void> getUserData(WidgetRef ref) async {
    user = (await ref.read(userProvider.notifier).getUser()) ??
        UserDataManager(
          email: "abc@gmail.com",
          name: "abc",
          password: "12345568",
          phone: "3456789",
        );
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
