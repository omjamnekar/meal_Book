import 'package:MealBook/firebase/auth.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/src/pages/cart/controller/cartControl.dart';
import 'package:MealBook/src/pages/cart/provider/cartList.dart';

import 'package:MealBook/src/pages/loader/actuator.dart';

import 'package:MealBook/src/pages/loader/loading.dart';
import 'package:MealBook/src/pages/registration/register.dart';
import 'package:MealBook/respository/provider/registerState.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class homeController extends GetxController {
  AuthClass _authenticate = AuthClass();

  // UserState userData = UserState();

  Future<String> getImage(String imageUrl) {
    final ref = FirebaseStorage.instance.ref().child('genaral/$imageUrl');
    return ref.getDownloadURL();
  }

  Future<UserDataManager> adder() async =>
      await UserState.getUser().then((value) {
        return value;
      });

  Future<void> signOut(WidgetRef ref, BuildContext context) async {
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

        ref.watch(dataListProvider.notifier).removeAllItems();

        print("done done done");

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

  Future<List<dynamic>> generalLoading() async {
    DataSnapshot _variety;
    final ref = FirebaseDatabase.instance.reference();
    final snapshot = ref.child('general/');
    _variety = await snapshot.get();

    List recData = [];

    for (var i in _variety.value as List<dynamic>) {
      recData.add(i);
    }

    //  print(recData);
    return recData;
  }

  Future<String> listImage(String imageName) async {
    print(imageName);
    final ref = FirebaseStorage.instance.ref().child('genaral/${imageName}');
    String url = await ref.getDownloadURL();

    return url;
  }

  Future<Widget> loadAnimation(String imageNamw) async {
    String sd = await listImage(imageNamw);
    return Image.network(sd);
  }

  Future<String> fetchProductImage(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child('combos/$imageName');
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<List<Map<dynamic, dynamic>>> fetchComboData() async {
    DataSnapshot snapshot;
    final ref = FirebaseDatabase.instance.reference();
    final comboRef = ref.child('combo/');
    snapshot = await comboRef.get();
    List<dynamic> comboData = [];
    if (snapshot.value != null) {
      comboData = snapshot.value as List<dynamic>;
    }
    return comboData.cast<Map<dynamic, dynamic>>();
  }
}
