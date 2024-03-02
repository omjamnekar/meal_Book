import 'dart:async';
import 'dart:io';

import 'package:MealBook/model/user.dart';
import 'package:MealBook/pages/auth.dart';
import 'package:MealBook/pages/featureIntro.dart';
import 'package:MealBook/provider/registerState.dart';
import 'package:MealBook/provider/userState.dart';
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
  Verification({super.key, required this.user});

  UserDataManager user;

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

  Future<void> saveData() async {
    await UserState.insertUser(
      userData: widget.user,
    );
    ref.watch(booleanProvider.notifier).update(isVerified);
    print("done");
  }

  Future<bool> verificationSending() async {
    isVerified = await auth.sendVerification(context).then((value) {
      User? user = FirebaseAuth.instance.currentUser;
      auth.waitForEmailVerification(user!, context);

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
      const Duration(seconds: 7),
      (Timer timer) => setState(
        () {
          isOverloadResend = false;
        },
      ),
    );
  }

  Future<void> deleteUser() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text('Warning'),
          content: Text(
            'Are you sure to Register account again?',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );

    FirebaseAuth.instance.currentUser!.delete();
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
            return mainPage(
                widget.user, context, minutes, seconds, isVerified, isVerify);
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data == true) {
            isVerified = snapshot.data!;
            return mainPage(
                widget.user, context, minutes, seconds, isVerified, isVerify);
          }

          return mainPage(
              widget.user, context, minutes, seconds, isVerified, isVerify);
        });
  }

  Scaffold mainPage(UserDataManager userData, BuildContext context, int minutes,
      int seconds, bool isverified, bool isVerify) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        deleteUser();
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
                      ? const Text(
                          "Try resending Email",
                          style: TextStyle(fontSize: 20),
                        )
                      : Text(
                          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: GoogleFonts.poppins(fontSize: 20),
                        )
                  : Container(),
              !isVerified
                  ? const Text(" You will get email to verify email Id")
                  : AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      child: Text(
                        "Email Verified",
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                    ),
              const Gap(20),
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
                      style: const ButtonStyle(),
                      child: const Text("Resend Message"))
                  : ElevatedButton(
                      onPressed: () {
                        saveData();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeatureStep()));
                      },
                      child: const Text("Continue with App!")),
              const Gap(4),
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: isOverloadResend
                    ? Text(
                        "Resend message after 1 minutes",
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Color.fromARGB(255, 223, 64, 6)),
                        key: const ValueKey<int>(1),
                      )
                    : Container(
                        key: const ValueKey<int>(2),
                      ),
              ),
              const Gap(40),
              !isverified
                  ? TextButton(
                      onPressed: () {
                        deleteUser();
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
                              color: Color.fromARGB(146, 0, 0, 0),
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
