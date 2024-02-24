import 'package:MealBook/pages/homePage.dart';
import 'package:MealBook/pages/register/register.dart';
import 'package:MealBook/provider/actuatorState.dart';
import 'package:MealBook/provider/registerState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// this widget is use for animation and fraction of loading screen and
//feature or home page

class Actuator extends ConsumerStatefulWidget {
  const Actuator({super.key, required this.Register, required this.child});

  final Widget child;
  final Widget Register;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActuatorState();
}

class _ActuatorState extends ConsumerState<Actuator> {
  @override
  void initState() {
    // TODO: implement initState
    ref.read(imageListProvider.notifier).fetchData();
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    final booleanState = ref.watch(booleanProvider);

    // if isRegistered is true then locate to homepage
    // or fetch data from the firebase

    //loading screen for the start
    // check the registrasion and if he is registered then

    // 1)// locate him to homepage

    // before checking is see data is loaded or not
    //  2)// locate to ragistration page
    print(booleanState.value.toString());
    return AnimatedSwitcher(
      duration: Duration(seconds: 1), // Define the duration of the animation
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(child: child, opacity: animation);
      },
      child: booleanState.value
          ? _isLoading
              ? widget.child
              : HomePage()
          : ref.watch(imageListProvider).dataCame
              ? widget.Register
              : widget.child,
    );

    // return AnimatedCrossFade(firstChild: widget.child, secondChild: isRegistered?HomePage()  : RegisterPage(), crossFadeState:imageListState.state.dataCame?CrossFadeState.showFirst , duration: duration)
  }
}
