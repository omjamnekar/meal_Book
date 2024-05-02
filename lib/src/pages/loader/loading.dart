import 'dart:math';

import 'package:MealBook/src/pages/loader/featureIntro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double translateY = 0.0;
  double scaleValue = 0.0;
  bool initialScalingComplete = false;

  bool isVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust the duration as needed
    )..addListener(() {
        setState(() {
          if (_controller.value < 0.125 && !initialScalingComplete) {
            // First 0.5 seconds: Smooth scale-up from 0 size to larger size
            scaleValue = Curves.easeInOutBack.transform(_controller.value * 6);
          } else {
            // After the first 0.5 seconds: Float in the normal size
            translateY = sin((_controller.value - 0.125) * pi * 2) * 3;
            scaleValue = 1.0;
            initialScalingComplete = true;
          }
        });

// maintaining the time of linear loading indicator

        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            isVisible = true;
          });
        });
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset the controller for the next loop
        _controller.reset();
        _controller.forward();
      }
    });

    // Start the initial animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/image/introPage/introBack.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              const Gap(260),
              // LoGO Specification
              Column(
                children: [
                  // Logo Image
                  AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: scaleValue,
                          child: Transform.translate(
                            offset: Offset(0, translateY),
                            child: Container(
                                height: 100,
                                decoration: const BoxDecoration(),
                                child: Image.asset(
                                  "assets/logo/main.png",
                                  width: 190,
                                  height: 90,
                                  fit: BoxFit.contain,
                                )),
                          ),
                        );
                      }),

                  Gap(7),

                  Animate(
                    delay: Duration(seconds: 1),
                    effects: [FadeEffect(), ScaleEffect()],
                    child: Transform.translate(
                      offset: const Offset(0, -10),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          children: [
                            Text(
                              "Meal Book",
                              style: GoogleFonts.lilitaOne(
                                color: HexColor("#DA6900"),
                                fontSize: 52,
                                letterSpacing: -1.4,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, -7),
                              child: Container(
                                width: 210,
                                height: 2,
                                decoration:
                                    BoxDecoration(color: HexColor("#ECECEC")),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, 2),
                              child: Container(
                                width: 200,
                                height: 50,
                                child: Text(
                                  "Always here to \nserve you",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    height: 1.3,
                                    color: HexColor("#ECECEC"),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: -1.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // loading linearindicator
              Gap(20),
              Visibility(
                visible: isVisible,
                child: Center(
                  child: Container(
                    width: 300,
                    child: Column(
                      children: [
                        LinearProgressIndicator(),
                        Gap(10),
                        Text(
                          "loading necessary files from database to cache",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 9, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              //copy right sign

              Animate(
                delay: Duration(seconds: 1),
                effects: [FadeEffect(), AlignEffect()],
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 70,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 120,
                      height: 70,
                      margin: const EdgeInsets.only(bottom: 20, right: 20),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/image/introPage/contentCopy.png",
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
