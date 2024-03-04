import 'dart:math';

import 'package:MealBook/src/pages/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class FeatureStep extends StatefulWidget {
  const FeatureStep({Key? key}) : super(key: key);

  @override
  _FeatureStepState createState() => _FeatureStepState();
}

class _FeatureStepState extends State<FeatureStep>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;

  late AnimationController _waveController1;

  late AnimationController _waveController;
  late List<String> _imagePaths;
  late List<String> _imageDish;
  int _currentIndex = 0;
  late Animation<Offset> _offsetAnimation2;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _offsetAnimation4;
  late Animation<Offset> _offsetAnimation3;

  // List of appearing positions for dish images
  final List<Offset> _appearingPositions = [
    const Offset(-100.0, -50.0),
    const Offset(350.0, -50.0),
    const Offset(-150.0, 650.0),
    // Add more positions as needed
  ];

  // List of destination positions for dish images
  final List<Offset> _destinationPositions = [
    const Offset(-50, 0),
    const Offset(270.0, 0.0),
    const Offset(-100.0, 550.0),
    // Add more positions as needed
  ];

  final List<Size> _size = [
    const Size(370, 600),
    const Size(170, 260),
    const Size(380, 350),
  ];

  List<HexColor> colorCircle = [
    HexColor("EDB927"),
    HexColor("A3A3A3"),
    HexColor("1A1912"),
    HexColor("F54A26"),
    HexColor("406E7B"),
    HexColor("9B706D"),
  ];

  List<HexColor> colorBorder = [
    HexColor("929292"),
    HexColor("EA300D"),
    HexColor("B9740D"),
    HexColor("FF0038"),
    HexColor("C9C7BB"),
    HexColor("803E00"),
  ];

  List<String> heading = [
    "Easy Order",
    "Customize Menus",
    "Friendly Interface",
    "Pre orders!",
    "Healthy Options:",
    "Secure Payment",
  ];
  List<String> discription = [
    "Browse our extensive menu and place orders with just a few taps.",
    "Personalize your orders to suit your taste preferences choices.",
    "Explore daily exclusive dishes that make every meal exciting.",
    "Plan your meals in advance by pre-ordering for a specific time.",
    "Discover nutritious and wholesome menu choices for healthly lifestyle.",
    "Enjoy free transactions with a variety of secure payment method.",
  ];

  late HexColor colorPoint;
  String headingpoint = "";
  String descriptionpoint = "";
  late HexColor colorBorderPoint;

  @override
  void initState() {
    headingpoint = heading[0];
    descriptionpoint = discription[0];
    colorPoint = colorCircle[0];
    colorBorderPoint = colorBorder[0];
    super.initState();

    _controller2 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _waveController.repeat(reverse: true);

    _waveController1 = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _waveController1.repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Offscreen
      end: const Offset(230.0 / 600, 260.0 / 600), // Bottom right corner
    ).animate(_controller);

    _offsetAnimation2 = Tween<Offset>(
      begin: const Offset(2.0, 2.0), // Bottom right corner
      end: const Offset(.3, 1.2), // Center of the screen
    ).animate(_controller);

    _imagePaths = [
      "assets/image/feature/maggie.png",
      "assets/image/feature/dish.png",
      "assets/image/feature/noodle.png",
      "assets/image/feature/juice.png",
      "assets/image/feature/marbalGreen.png",
      "assets/image/feature/tomato.png",
      // Add more image paths as needed
    ];

    _imageDish = [
      "assets/image/feature/fooddish.png",
      "assets/image/feature/fooddish1.png",
      "assets/image/feature/fooddish2.png",
    ];

    // Start the fadeIn animation for the first image with an initial delay
    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
    });
    _offsetAnimation3 = Tween<Offset>(
      begin: const Offset(1.9, 5.9), // Bottom right corner
      end: const Offset(0.5, 5.6), // Center of the screen
    ).animate(_controller);
    _offsetAnimation4 = Tween<Offset>(
      begin: const Offset(2.0, 9.4), // Bottom right corner
      end: const Offset(0.5, 9.4), // Center of the screen
    ).animate(_controller);
  }

  void changePage() {
    if (_currentIndex < _imagePaths.length - 1) {
      // Fade-out animation for the current image
      _controller.reverse().whenComplete(() {
        // Delay and then fade-in animation for the next image
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _currentIndex++;
          });

          _controller.forward();

          headingpoint = heading[_currentIndex];
          descriptionpoint = discription[_currentIndex];
          colorPoint = colorCircle[_currentIndex];
          colorBorderPoint = colorBorder[_currentIndex];
        });
      });
    } else {
      // Handle when all images are shown
      // Add your navigation logic here
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return MainPage(); // Replace 'NextPage' with the actual widget/page you want to navigate to
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/introPage/introBack.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _controller,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_imagePaths[_currentIndex]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: _currentIndex == 1
                        ? Stack(
                            children: _imageDish.asMap().entries.map(
                              (entry) {
                                if (_controller.isAnimating) {
                                  return Positioned(
                                    left: _appearingPositions[entry.key].dx +
                                        (_destinationPositions[entry.key].dx -
                                                _appearingPositions[entry.key]
                                                    .dx) *
                                            _controller.value,
                                    top: _appearingPositions[entry.key].dy +
                                        (_destinationPositions[entry.key].dy -
                                                _appearingPositions[entry.key]
                                                    .dy) *
                                            _controller.value,
                                    child: Container(
                                      width: _size[entry.key].width,
                                      height: _size[entry.key].height,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            _imageDish[entry.key],
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  // Display images at their final destination when not animating
                                  return Positioned(
                                    left: _destinationPositions[entry.key].dx,
                                    top: _destinationPositions[entry.key].dy,
                                    child: Container(
                                      width: _size[entry.key].width,
                                      height: _size[entry.key].height,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            _imageDish[entry.key],
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ).toList(),
                          )
                        : const SizedBox
                            .shrink(), // Hide dish images for other images
                  ),
                );
              },
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      -20 *
                          sin(_waveController
                              .value), // Adjust the amplitude of the left-right wave
                      -20 *
                          sin(2 *
                              _waveController
                                  .value), // Adjust the amplitude of the up-down wave
                    ),
                    child: child,
                  );
                },
                child: ClipRRect(
                  child: Container(
                    width: 1900,
                    height: 1500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1200),
                      image: const DecorationImage(
                          image: AssetImage(
                              "assets/image/introPage/introBright.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            // SlideTransition(
            //   position: _offsetAnimation,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(1200),
            //     child: Container(
            //       width: 1900,
            //       height: 1500,
            //       decoration: BoxDecoration(
            //           color: colorPoint,
            //           borderRadius: BorderRadius.circular(500)),
            //     ),
            //   ),
            // ),
            SlideTransition(
              position: _offsetAnimation2,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      -13 *
                          sin(_waveController
                              .value), // Adjust the amplitude of the left-right wave
                      -13 *
                          sin(4 *
                              _waveController
                                  .value), // Adjust the amplitude of the up-down wave
                    ),
                    child: child,
                  );
                },
                child: ClipRRect(
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1200),
                      color: colorPoint,
                      border: Border.all(color: colorBorderPoint, width: 3),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _waveController1,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -30 *
                        sin(_waveController1
                            .value), // Adjust the amplitude of the left-right wave
                    -10 *
                        sin(1 *
                            _waveController1
                                .value), // Adjust the amplitude of the up-down wave
                  ),
                  child: child,
                );
              },
              child: SlideTransition(
                position: _offsetAnimation3,
                child: Container(
                  width: 260,
                  decoration: const BoxDecoration(),
                  child: Text(
                    headingpoint,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: 50,
                        height: 1,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _waveController1,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -10 *
                        sin(_waveController
                            .value), // Adjust the amplitude of the left-right wave
                    -10 *
                        sin(1 *
                            _waveController
                                .value), // Adjust the amplitude of the up-down wave
                  ),
                  child: child,
                );
              },
              child: SlideTransition(
                position: _offsetAnimation4,
                child: Container(
                  width: 270,
                  decoration: const BoxDecoration(),
                  child: Text(
                    descriptionpoint,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        height: 1.2,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: changePage,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.orange,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _waveController.dispose();
    _waveController1.dispose();
    super.dispose();
  }
}
