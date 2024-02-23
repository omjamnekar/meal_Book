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
  Widget build(BuildContext context) {
    final booleanState = ref.watch(booleanProvider);
    // if isRegistered is true then locate to homepage
    // or fetch data from the firebase

    //loading screen for the start
    // check the registrasion and if he is registered then

    // 1)// locate him to homepage

    // before checking is see data is loaded or not
    //  2)// locate to ragistration page

    if (booleanState.value) {
      return HomePage();
    } else {
      final imageListState = ref.watch(imageListProvider);

      ref.read(imageListProvider.notifier).fetchData();
      print(imageListState.dataCame);
      if (imageListState.dataCame) {
        return widget.Register;
      } else {
        // if data is not availabe then show the loading screen

        return widget.child;
      }
    }
    // return AnimatedCrossFade(firstChild: widget.child, secondChild: isRegistered?HomePage()  : RegisterPage(), crossFadeState:imageListState.state.dataCame?CrossFadeState.showFirst , duration: duration)
  }
}
