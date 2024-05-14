import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lottie/lottie.dart';

class OrdLoading extends StatefulWidget {
  OrdLoading({super.key, required this.child});

  Widget child;

  @override
  State<OrdLoading> createState() => _OrdLoadingState();
}

class _OrdLoadingState extends State<OrdLoading> {
  bool isLoading = false;
  bool isDark = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = true;
      });
    });
  }

  _dark() {
    setState(() {
      isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    _dark();
    return isLoading
        ? widget.child
        : Scaffold(
            body: AnimatedOpacity(
              opacity: isLoading ? 0.0 : 1.0,
              duration: Duration(seconds: 1),
              child: Scaffold(
                body: Center(
                  child: isDark
                      ? Lottie.asset(
                          "assets/lottie/darkMode/orderRec_dark.json")
                      : Lottie.asset("assets/lottie/orderRec.json"),
                ),
              ),
            ),
          );
  }
}
