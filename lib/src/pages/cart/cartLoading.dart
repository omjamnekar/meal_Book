import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/pages/cart/cart.dart';
import 'package:MealBook/src/pages/cart/cartMode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartLoading extends StatefulWidget {
  CartLoading({
    Key? key,
  }) : super(key: key);

  @override
  State<CartLoading> createState() => _CartLoadingState();
}

class _CartLoadingState extends State<CartLoading>
    with SingleTickerProviderStateMixin {
  bool isLoadingDone = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _timerLoading();
    _setupAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _timerLoading() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoadingDone = true;
      });
    });
  }

  void _setupAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
      ),
    );
    _animationController.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: !isLoadingDone
          ? Scaffold(
              body: Center(
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: 140,
                    height: 140,
                    child: const Hero(
                      tag: "Burgure_logo",
                      child: Image(
                        image: AssetImage(
                          "assets/logo/burgur.png",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : CartProssToOrder(),
    );
  }
}
