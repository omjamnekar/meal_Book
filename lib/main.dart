import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
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
      home: const IntroPage(),
    );
  }
}

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                Container(
                  height: 170,
                  decoration: const BoxDecoration(),
                  child: Stack(
                    children: [
                      Transform.translate(
                        offset: Offset(180, 110),
                        child: Image.asset(
                          "assets/image/introPage/waterMouth.png",
                        ),
                      ),
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

                Transform.translate(
                  offset: Offset(0, -25),
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
                          offset: Offset(0, -7),
                          child: Container(
                            width: 210,
                            height: 2,
                            decoration:
                                BoxDecoration(color: HexColor("#ECECEC")),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, 2),
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
              ],
            ),

            Spacer(),

            //copy right sign

            Container(
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
