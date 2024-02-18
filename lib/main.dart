import 'package:flutter/material.dart';
import 'package:meal_book/pages/featureIntro.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(218, 105, 0, 1)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const FeatureStep(),
    );
  }
}
