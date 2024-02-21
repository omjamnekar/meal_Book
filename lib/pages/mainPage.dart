import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_book/pages/featureIntro.dart';

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
            scaleValue = Curves.easeInOutBack.transform(_controller.value * 8);
          } else {
            // After the first 0.5 seconds: Float in the normal size
            translateY = sin((_controller.value - 0.125) * pi * 2) * 5;
            scaleValue = 1.0;
            initialScalingComplete = true;
          }
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
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeatureStep(),
                  ));
            },
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
                                height: 170,
                                decoration: const BoxDecoration(),
                                child: Stack(
                                  children: [
                                    // Transform.translate(
                                    //   offset: Offset(180, 110),
                                    //   child: Image.asset(
                                    //     "assets/image/introPage/waterMouth.png",
                                    //   ),
                                    // ),
                                    Container(
                                      child: Image.asset(
                                        "assets/image/introPage/logoBack.png",
                                        width: 170,
                                        height: 170,
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: Offset(4, 0),
                                      child: Image.asset(
                                        "assets/image/introPage/logo.png",
                                        width: 160,
                                        height: 160,
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(4, 33),
                                      child: Image.asset(
                                        "assets/image/introPage/Rectangle 1.png",
                                        width: 160,
                                        height: 160,
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(5, 70),
                                      child: Image.asset(
                                        "assets/image/introPage/Rectangle 2.png",
                                        width: 160,
                                        height: 110,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                    Animate(
                      delay: Duration(seconds: 1),
                      effects: [FadeEffect(), ScaleEffect()],
                      child: Transform.translate(
                        offset: const Offset(0, -25),
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
                        width: 100,
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
      ),
    );
  }
}
