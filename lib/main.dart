import 'package:MealBook/payments/pay.dart';
import 'package:MealBook/payments/step/framePay.dart';
import 'package:MealBook/src/Theme/theme_provider.dart';
import 'package:MealBook/controller/authLogic.dart';

import 'package:MealBook/firebase_options.dart';
import 'package:MealBook/src/components/connectionPage.dart';
import 'package:MealBook/src/pages/loader/actuator.dart';
import 'package:MealBook/src/pages/loader/loading.dart';
import 'package:MealBook/src/pages/registration/register.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart' as provider;

import ".env";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthController());

  // Stripe.publishableKey = stripePublicKey;
  // await Stripe.instance.applySettings();
  runApp(
    riverpod.ProviderScope(
      child: provider.ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return provider.ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Meal Book',
            theme: provider.Provider.of<ThemeProvider>(context).themeData,
            debugShowCheckedModeBanner: false,
            home: const ConnectionPage(
              widget: Actuator(
                Register: RegisterPage(),
                child: IntroPage(),
              ),
            ),
            // home: FramePay(),
            // home: const HomeScreen(),
            // home: StateRanderer(),
            // home: SecurityCheck(),
            // home: ProductDetail(),
            // home: Display()
            // home: Cart(),
            // home: const PayMode(),
            // home: Display(),
          );
        },
      ),
    );
  }
}
