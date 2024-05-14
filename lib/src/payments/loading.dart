import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TimeLoading extends StatefulWidget {
  TimeLoading({super.key, required this.child});
  Widget child;

  @override
  State<TimeLoading> createState() => _TimeLoadingState();
}

class _TimeLoadingState extends State<TimeLoading> {
  bool isTimeOut = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // Code to execute after the delay'
      setState(() {
        isTimeOut = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isTimeOut) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: widget.child,
      );
    } else {
      return Scaffold(
        body: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isTimeOut ? 0 : 1,
          child: Center(
            child: Lottie.asset("assets/lottie/time.json"),
          ),
        ),
      );
    }
  }
}
