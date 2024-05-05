import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AddCartDownPop {
  static Future<void> show(BuildContext context, String title, String content,
      Function() onTap) async {
    await _create(context, title, content);
  }

  static Future<void> _create(
      BuildContext context, String title, String content) async {
    final confirmSignOut = await Flushbar<bool>(
      title: title,
      message: content,
      mainButton: TextButton(
        child: const Text(
          "Go to Cart",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          // navogate to the cart page
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
  }
}
