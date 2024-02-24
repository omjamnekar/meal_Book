import 'package:MealBook/firebase/auth.dart';
import 'package:MealBook/pages/featureIntro.dart';

import 'package:MealBook/pages/register/verification.dart';
import 'package:MealBook/provider/registerState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
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

  PageController pageController = PageController(initialPage: 0);

  void changepassword(BuildContext context) {
    // String dd = validateEmail(emailController.text);
    if (emailController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      try {
        print(emailController.text);
        auth.sendPasswordResetEmail(emailController.text, context, () {
          pageController.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        });
        snackbarCon(context, "Password reset email sent");
      } catch (e) {
        snackbarCon(context, e.toString());
      }
    } else {
      snackbarCon(context, "Enter valid email");
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value!))
      return 'Enter Valid Email';
    else
      return "";
  }

// Function to validate password
  void validatePassword(
    BuildContext context,
    String? value,
    WidgetRef ref,
  ) {
    if (value!.isEmpty) {
      snackbarCon(context, "Password cannot be empty");
      return;
    } else if (value.length < 8) {
      snackbarCon(context, "Password must be at least 8 characters");

      return;
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      snackbarCon(
          context, "Password must contain at least one uppercase letter");

      return;
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      snackbarCon(
          context, "Password must contain at least one lowercase letter");

      return;
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      snackbarCon(context, "Password must contain at least one numbe");

      return;
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      snackbarCon(
          context, "Password must contain at least one special character");

      return;
    } else if (passwordController.text != confirmPassword.text) {
      snackbarCon(context, "Passwords do not match");

      return;
    } else {
      // all is good
      if (isLogin) {
        snackbarCon(context, "Signing In...");
        auth
            .signInWithEmailAndPassword(
                emailController.text, passwordController.text, context)
            .then((value) {
          if (value != null) {
            ref.watch(booleanProvider.notifier).update(true);
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    FeatureStep(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          }
        });
      } else {
        snackbarCon(context, "Registering...");
        auth
            .isEmailAvailable(emailController.text, passwordController.text)
            .then((value) {
          if (value) {
            auth.registerWithEmailPassword(
                emailController.text, passwordController.text);
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Verification(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          } else {
            snackbarCon(context, "Email already in use");
          }
        });
      }
    }
  }

  void onMainButtonPress(BuildContext context, WidgetRef ref) {
    if (!isLogin) {
      validatePassword(context, confirmPassword.text, ref);
      validateEmail(emailController.text);
    } else {
      validateEmail(emailController.text);
      confirmPassword = TextEditingController(text: passwordController.text);
      validatePassword(context, passwordController.text, ref);
    }
  }

  Future<void> googleSignIn(BuildContext context, WidgetRef ref) async {
    UserCredential? sd = await auth.signInWithGoogle();
    if (sd != null) {
      snackbarCon(context, "Signed in with Google");
    }

    ref.watch(booleanProvider.notifier).update(true);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FeatureStep(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Future<void> googleSignOut(BuildContext context) async {
    googleSignOut(context);
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

class Add {
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value!))
      return 'Enter Valid Email';
    else
      return "";
  }
}
