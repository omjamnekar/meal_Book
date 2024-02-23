import 'package:MealBook/firebase/auth.dart';
import 'package:MealBook/provider/registerState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:provider/provider.dart';

class AuthController extends GetxController {
  bool isOpen = true;
  bool isOpen1 = true;
  AuthClass auth = AuthClass();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isLogin = false;
  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value!))
      return 'Enter Valid Email';
    else
      return null;
  }

// Function to validate password
  void validatePassword(BuildContext context, String? value) {
    if (value!.isEmpty) {
      snackbarCon(context, "Password cannot be empty");
    } else if (value.length < 8) {
      snackbarCon(context, "Password must be at least 8 characters");
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      snackbarCon(
          context, "Password must contain at least one uppercase letter");
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      snackbarCon(
          context, "Password must contain at least one lowercase letter");
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      snackbarCon(context, "Password must contain at least one numbe");
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      snackbarCon(
          context, "Password must contain at least one special character");
    } else if (passwordController.text != confirmPassword.text) {
      snackbarCon(context, "Passwords do not match");
    } else {
      // all is good
      if (isLogin) {
        snackbarCon(context, "Signing In...");
      } else {
        snackbarCon(context, "Registering...");
      }
    }
  }

  void onMainButtonPress(BuildContext context) {
    if (!isLogin) {
      validatePassword(context, confirmPassword.text);
      validateEmail(emailController.text);
      validatePassword(context, passwordController.text);
    } else {
      validateEmail(emailController.text);
      confirmPassword = TextEditingController(text: passwordController.text);
      validatePassword(context, passwordController.text);
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
    UserCredential? sd = await auth.signInWithGoogle();
    if (sd != null) {
      snackbarCon(context, "Signed in with Google");
    }
  }

  Future<void> gitSignIn(
    BuildContext context,
    WidgetRef ref,
  ) async {
    UserCredential? sd = await auth.signInWithGitHub();
    if (sd != null) {
      await snackbarCon(context, "Signed in with GitHub");
      final booleanState = ref.watch(booleanProvider);
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
