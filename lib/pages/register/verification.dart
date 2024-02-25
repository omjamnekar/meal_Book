import 'dart:async';
import 'dart:io';

import 'package:MealBook/pages/auth.dart';
import 'package:MealBook/pages/featureIntro.dart';
import 'package:MealBook/provider/registerState.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../firebase/auth.dart';

class Verification extends ConsumerStatefulWidget {
  const Verification({super.key});

  @override
  ConsumerState<Verification> createState() => _VerificationState();
}

class _VerificationState extends ConsumerState<Verification> {
  bool isVerify = false;
  bool isTimeOff = false;
  int _start = 60;

  bool isOverloadResend = false;
  late bool isVerified = false;
  int loadingEmail = 0;

  AuthClass auth = AuthClass();
  late Timer _timer;

  void saveData() {
    ref.watch(booleanProvider.notifier).update(isVerified);
    print("done");
  }

  Future<bool> verificationSending() async {
    isVerified = await auth.sendVerification(context).then((value) {
      User? user = FirebaseAuth.instance.currentUser;

      auth.waitForEmailVerification(user!, context);
      if (value == true && user.emailVerified == true)
        Flushbar(
          title: "Hey Ninja",
          message:
              "SignIn...${user?.displayName} is now signed in with Firebase Authentication.",
          backgroundGradient: LinearGradient(colors: [
            Color.fromARGB(255, 255, 106, 0),
            Color.fromARGB(255, 240, 108, 0)
          ]),
          backgroundColor: Color.fromARGB(255, 247, 177, 0),
          boxShadows: [
            BoxShadow(
              color: Color.fromARGB(255, 255, 196, 0),
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
        )..show(context);
      return value;
    });

    return isVerify;
  }

  void startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            isTimeOff = true;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void overLoadVanish() {
    Timer _overLoadVanish = Timer.periodic(
      Duration(seconds: 7),
      (Timer timer) => setState(
        () {
          isOverloadResend = false;
        },
      ),
    );
  }

  Future<void> deleteUser(AboutDialog aboutDialog) async {
    AboutDialog d = aboutDialog;
    FirebaseAuth.instance.currentUser!.delete();
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    startTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;

    if (loadingEmail <= 1) {
      verificationSending();
      loadingEmail++;
    }
    return FutureBuilder(
        future: verificationSending(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return mainPage(context, minutes, seconds, isVerified, isVerify);
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data == true) {
            isVerified = snapshot.data!;
            return mainPage(context, minutes, seconds, isVerified, isVerify);
          }

          return mainPage(context, minutes, seconds, isVerified, isVerify);
        });
  }

  Scaffold mainPage(BuildContext context, int minutes, int seconds,
      bool isverified, bool isVerify) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        deleteUser(AboutDialog(
                          applicationName: "Reminder",
                          children: [
                            Text("If You get back,You have to register again!")
                          ],
                        ));
                      },
                      icon: Icon(Icons.arrow_back)),
                  const Text(
                    "Verification",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              !isverified
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      alignment: Alignment.center,
                      child: Center(
                        child: Lottie.asset(
                          "assets/lottie/verify.json",
                          height: 300,
                          repeat: true,
                          animate: true,
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      alignment: Alignment.center,
                      child: Center(
                        child: Lottie.asset(
                          "assets/lottie/done.json",
                          height: 300,
                          repeat: true,
                          animate: true,
                        ),
                      ),
                    ),
              !isVerified
                  ? isTimeOff
                      ? Text(
                          "Try resending Email",
                          style: TextStyle(fontSize: 20),
                        )
                      : Text(
                          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: GoogleFonts.poppins(fontSize: 20),
                        )
                  : Container(),
              !isVerified
                  ? Text(" You will get email to verify email Id")
                  : AnimatedContainer(
                      duration: Duration(seconds: 1),
                      child: Text(
                        "Email Verified",
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                    ),
              Gap(20),
              !isVerified
                  ? ElevatedButton(
                      onPressed: () {
                        if (isTimeOff) {
                          verificationSending();
                          startTimer();
                          isVerified = false;
                        } else {
                          isOverloadResend = true;
                          overLoadVanish();
                        }
                      },
                      style: ButtonStyle(),
                      child: Text("Resend Message"))
                  : ElevatedButton(
                      onPressed: () {
                        saveData();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeatureStep()));
                      },
                      child: Text("Continue with App!")),
              Gap(4),
              AnimatedSwitcher(
                duration: Duration(seconds: 1),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: isOverloadResend
                    ? Text(
                        "Resend message after 1 minutes",
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Color.fromARGB(255, 223, 64, 6)),
                        key: ValueKey<int>(1),
                      )
                    : Container(
                        key: ValueKey<int>(2),
                      ),
              ),
              Gap(40),
              !isverified
                  ? TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 15,
                            color: Color.fromARGB(146, 0, 0, 0),
                          ),
                          Gap(10),
                          Text(
                            "Back to register page!",
                            style: TextStyle(
                              color: const Color.fromARGB(146, 0, 0, 0),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
