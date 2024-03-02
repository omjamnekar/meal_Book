import 'package:MealBook/Theme/theme_provider.dart';
import 'package:MealBook/controller/authLogic.dart';

import 'package:MealBook/firebase_options.dart';
import 'package:MealBook/pages/actuator.dart';
import 'package:MealBook/pages/loading.dart';
import 'package:MealBook/pages/registration/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:get/get.dart';
import 'package:provider/provider.dart' as provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());
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
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
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
            home: Actuator(
              child: IntroPage(),
              Register: RegisterPage(),
            ),

            //  home: PopoverExample(),
            //  home: Cdeom(),
            //  home: Verification(),
          );
        },
      ),
    );
  }
}
