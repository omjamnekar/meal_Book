import 'dart:async';

import 'package:MealBook/src/Theme/theme_preference.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class ConnectionPage extends ConsumerStatefulWidget {
  const ConnectionPage({Key? key, required this.widget}) : super(key: key);

  final Widget widget;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends ConsumerState<ConnectionPage> {
  late final Connectivity _connectivity;
  late Timer _timer;
  bool isConnected = true;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => _checkInternetConnection());
  }

  darkSetter() async {
    bool sd = await ThemePreferences.isDarkMode();
    setState(() {
      isDarkMode = sd;
    });
  }

  Future<void> _checkInternetConnection() async {
    try {
      darkSetter();

      var connectivityResult = await _connectivity.checkConnectivity();
      setState(() {
        isConnected = connectivityResult != ConnectivityResult.none;
      });
    } catch (e) {
      print("Error checking internet connection: $e");
    }
  }

  retry() {
    _checkInternetConnection();
    if (!isConnected) {
      SnackBar snackBar = SnackBar(
        content: Text('Still No internet connection!'),
        action: SnackBarAction(
          label: 'cancel',
          textColor: Theme.of(context).cardColor,
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnected) {
      darkSetter();
      return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            await _checkInternetConnection();
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        alignment: Alignment.topLeft,
                        child: AnimatedTextKit(
                          isRepeatingAnimation: true,
                          repeatForever: true,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'No internet connection!',
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              speed: const Duration(milliseconds: 200),
                            ),
                          ],
                          totalRepeatCount: 4,
                          pause: const Duration(milliseconds: 1000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      ),
                      Gap(200),
                      Container(
                        width: 200,
                        height: 200,
                        child: Lottie.asset(
                          isDarkMode
                              ? 'assets/lottie/darkMode/noConnectionDark.json'
                              : 'assets/lottie/noConnection.json',
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        alignment: Alignment.center,
                        child: Text(
                          'Please wait while we check your internet connection',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Gap(30),
                      TextButton.icon(
                          onPressed: () {
                            retry();
                          },
                          label: Text(
                            "Retry",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .cardColor, // Change this to your desired color
                            ),
                          ),
                          icon: Icon(
                            Icons.refresh,
                            color: Theme.of(context)
                                .cardColor, // Change this to your desired color
                          )),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return widget.widget;
  }
}
