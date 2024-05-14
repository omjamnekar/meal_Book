import 'package:MealBook/src/payments/payDone/animation/animationPay.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class PayDone extends StatefulWidget {
  const PayDone({Key? key}) : super(key: key);

  @override
  State<PayDone> createState() => _PayDoneState();
}

class _PayDoneState extends State<PayDone> with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int indexOrderStepper = 0;
  bool isFirst = true;
  bool isLast = false;
  bool isSecond = false;
  @override
  void initState() {
    super.initState();
    _delay();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // Start the animation when the widget is first built
    _animationController.forward();
  }

  bool isOpacity = false;
  bool isThird = false;
  _opacity() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isOpacity = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showBottomSheet() {
    PageController _pageControl = PageController(initialPage: 0);

    void _changeStateToNext(int index, bool isLast, StateSetter setState) {
      print(index);
      if (index == 3) {
        isThird = true;
        isSecond = false;
      }
      if (isLast) {
      } else {
        _pageControl.animateToPage(index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);

        if (index == 1) {
          setState(() {
            isSecond = true;
            isFirst = false;
          });
        }
        if (index == 2) {
          setState(() {
            isSecond = false;
          });
        }
      }
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height /
                2, // Adjust the height as needed
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Hierarchies :',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //stepper  here
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          StepperIndicatorUser(
                            isActivePath: isFirst,
                            isLast: false,
                          ),
                          StepperIndicatorUser(
                            isActivePath: isSecond,
                            isLast: false,
                          ),
                          StepperIndicatorUser(
                            isActivePath: isLast,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    // Main content here
                    Flexible(
                      flex: 6,
                      child: Container(
                        width: double.maxFinite,
                        height: MediaQuery.of(context).size.height / 2.7,
                        child: PageView.builder(
                            itemCount: orderComponent.length,
                            controller: _pageControl,
                            itemBuilder: (context, index) {
                              return Container(
                                width: double.maxFinite,
                                height: double.maxFinite,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Lottie.asset(
                                            isDarkMode
                                                ? orderComponent[index]
                                                    .orderImage[0]
                                                : orderComponent[index]
                                                    .orderImage[1],
                                            height: 200,
                                            width: 200,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                opacity: 1.0,
                                                child: Text(
                                                  "${orderComponent[index].header}",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                "${orderComponent[index].desc}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(20),
                                    isLast == false
                                        ? TextButton.icon(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                Colors.white,
                                              ),
                                              padding:
                                                  MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                  horizontal: 140,
                                                  vertical: 10,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _changeStateToNext(
                                                    index + 1,
                                                    index == 2 ? true : false,
                                                    setState);
                                              });
                                            },
                                            label: Text(
                                              "Next",
                                            ),
                                          )
                                        : Gap(20),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    opacity: isThird ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary,
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 2.9,
                            vertical: 8,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: const Text(
                        "Continue",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  List<OrderComponent> orderComponent = [
    OrderComponent(
      header: 'Order Received',
      desc: 'Your order has been received and is being processed',
      onTap: () {},
      orderImage: [
        'assets/lottie/darkMode/orderProceed_dark.json',
        'assets/lottie/orderProceed.json'
      ],
    ),
    OrderComponent(
      header: 'Order Processing',
      desc: 'Your order is being processed and will be ready in 15 minutes',
      onTap: () {},
      orderImage: [
        'assets/lottie/darkMode/cookingFood_dark.json',
        'assets/lottie/cookingFood.json'
      ],
    ),
    OrderComponent(
      header: 'Order Ready',
      desc: 'Your order is ready for pickup',
      onTap: () {},
      orderImage: [
        'assets/lottie/darkMode/foodReady_dark.json',
        'assets/lottie/foodReady.json'
      ],
    ),
  ];
  bool delayBitch = false;
  _delay() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        delayBitch = true;
      });
      print(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: delayBitch ? 1.0 : 0.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Lottie.asset(
                  isDarkMode
                      ? "assets/lottie/darkMode/payDone_dark.json"
                      : "assets/lottie/payDone.json",
                  height: 200,
                  width: 200,
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.5),
                  end: const Offset(0.0, 0.0),
                ).animate(_animation),
                child: Text(
                  'Payment Successful ',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.5),
                  end: const Offset(0.0, 0.0),
                ).animate(_animation),
                child: Text(
                  'Thank you for shopping with us\n Your order will be ready in 15 minutes.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.5),
                  end: const Offset(0.0, 0.0),
                ).animate(_animation),
                child: ElevatedButton(
                  onPressed: () {
                    // Delay showing the bottom sheet to ensure animations complete first
                    Future.delayed(const Duration(milliseconds: 800), () {
                      _showBottomSheet(
                          // will change that leter
                          );
                    });
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderComponent {
  final String header;
  final String desc;
  final Function onTap;
  final List<String> orderImage;
  OrderComponent({
    required this.header,
    required this.desc,
    required this.onTap,
    required this.orderImage,
  });
}
