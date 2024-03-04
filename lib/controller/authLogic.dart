import 'dart:io';

import 'package:MealBook/firebase/auth.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/src/pages/loader/featureIntro.dart';

import 'package:MealBook/src/pages/registration/verification.dart';
import 'package:MealBook/respository/provider/registerState.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  bool isOpen = true;
  bool isOpen1 = true;
  AuthClass auth = AuthClass();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
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
  ) async {
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
        int i = 0;

        auth
            .signInWithEmailAndPassword(
                emailController.text, passwordController.text, context)
            .then((value) async {
          if (value != null) {
            UserDataManager? user = UserDataManager(
              Uuid().v4(),
              name: usernameController.text,
              email: emailController.text,
              password: passwordController.text,
              phone: "",
              image: "",
            );

            UserState.insertUser(userData: user);
            ref.watch(booleanProvider.notifier).update(true);

            // if (i < 1) {
            //   Flushbar(
            //     title: "Hey avafffffff ${user.name}",
            //     message:
            //         "SignIn...${user.name} is now signed in with Firebase Authentication.",
            //     backgroundGradient: const LinearGradient(colors: [
            //       Color.fromARGB(255, 255, 149, 0),
            //       Color.fromARGB(255, 255, 162, 87)
            //     ]),
            //     backgroundColor: const Color.fromARGB(255, 247, 177, 0),
            //     boxShadows: const [
            //       BoxShadow(
            //         color: Color.fromARGB(255, 255, 196, 0),
            //         offset: Offset(0.0, 2.0),
            //         blurRadius: 3.0,
            //       )
            //     ],
            //   ).show(context);
            // }
            // Store user data in Firestore
            CollectionReference usersFire =
                FirebaseFirestore.instance.collection('users');

// Check if the email already exists
            QuerySnapshot emailCheck =
                await usersFire.where('email', isEqualTo: user.email).get();

            if (emailCheck.docs.isNotEmpty) {
              // Email already exists, handle accordingly (e.g., show an error message)
              print("Email already exists in Firestore");
            } else {
              // Email does not exist, proceed to add the new user
              await usersFire.doc(user.id).set({
                'id': user.id,
                'name': user.name,
                'email': user.email,
                'phone': user.phone,
                'image': user.image,
                'password': user.password,
                "date": DateTime.now().toUtc(),
                "male": user.male,
              }).then((_) {
                print("User added to Firestore");
              }).catchError((error) {
                print("Failed to add user: $error");
              });
            }

            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const FeatureStep(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
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
                    Verification(
                        user: UserDataManager(Uuid().v4(),
                            name: usernameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            phone: "",
                            image: "")),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
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

  var i = 0;
  Future<void> googleSignIn(BuildContext context, WidgetRef ref) async {
    UserCredential? sd = await auth.signInWithGoogle();

    if (sd != null) {
      UserDataManager user = UserDataManager(
        Uuid().v4(),
        name: sd.user!.displayName,
        email: sd.user!.email,
        password: "",
        phone: sd.user!.phoneNumber ?? "",
        image: sd.user!.photoURL!,
      );

      // Use a singleton instance of UserState
      UserState.insertUser(
        userData: user,
      );

      // Store user data in Firestore
      CollectionReference usersFire =
          FirebaseFirestore.instance.collection('users');

// Check if the email already exists
      QuerySnapshot emailCheck =
          await usersFire.where('email', isEqualTo: user.email).get();

      if (emailCheck.docs.isNotEmpty) {
        // Email already exists, handle accordingly (e.g., show an error message)
        print("Email already exists in Firestore");
      } else {
        // Email does not exist, proceed to add the new user
        await usersFire.doc(user.id).set({
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
          'image': user.image,
          'password': user.password,
          "date": DateTime.now().toUtc(),
          "male": user.male,
        }).then((_) {
          print("User added to Firestore");
        }).catchError((error) {
          print("Failed to add user: $error");
        });
      }

      snackbarCon(context, "Signed in with Google");
      ref.watch(booleanProvider.notifier).update(true);

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FeatureStep(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
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
