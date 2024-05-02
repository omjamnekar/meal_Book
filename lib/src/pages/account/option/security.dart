import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SecurityCheck extends StatefulWidget {
  const SecurityCheck({super.key});

  @override
  State<SecurityCheck> createState() => _SecurityCheckState();
}

class _SecurityCheckState extends State<SecurityCheck> {
  PageController controller = PageController(initialPage: 0);

  bool isDark = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the current theme from storage and set it to isDark
    _getCurrentTheme();
  }

  Future<void> _getCurrentTheme() async {
    isDark = await Theme.of(context).brightness == Brightness.dark;
    print(isDark);
  }

  List<String> heading = [
    "PRIVATE CLOUD",
    "COMMUNICATIONS",
    "ANTIVIRUS",
    "SECURITY"
  ];
  List<String> description = [
    "Private cloud is a type of cloud computing that delivers similar advantages to public cloud, including scalability and self-service, but through a proprietary architecture.",
    "Communication security (COMSEC) is the prevention of unauthorized access to telecommunications traffic, or to any information that is transmitted or transferred.",
    "Antivirus software is a type of program designed and developed to protect computers from malware like viruses, computer worms, spyware, botnets, rootkits, keyloggers and such.",
    "Security is the degree of resistance to, or protection from, harm. It applies to any vulnerable and valuable asset, such as a person, dwelling, community, item, nation, or organization."
  ];
  List<String> image = [
    'assets/lottie/cloud.json',
    'assets/lottie/communication.json',
    'assets/lottie/ANTIVIRUS.json',
    'assets/lottie/SECURITY.json'
  ];
  List<String> image_dark = [
    'assets/lottie/darkMode/cloud_dark.json',
    'assets/lottie/darkMode/communication_dark.json',
    'assets/lottie/darkMode/ANTIVIRUS_dark.json',
    'assets/lottie/darkMode/SECURITY_dark.json'
  ];

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Security & Privacy"),
        ),
        body: PageView.builder(
          controller: controller,
          itemCount: 4,
          itemBuilder: (context, index) {
            return AnimatedContainer(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              duration: const Duration(milliseconds: 300),
              child: Slides(
                name: heading[index],
                description: description[index],
                isDark: isDark,
                index: index,
                image: isDark ? image_dark[index] : image[index],
                controller: controller,
              ),
            );
          },
        ));
  }
}

class Slides extends StatefulWidget {
  Slides({
    Key? key,
    required this.name,
    required this.description,
    required this.image,
    required this.isDark,
    required this.index,
    required this.controller,
  }) : super(key: key);

  String name;
  String description;
  bool isDark;
  int index;
  String image;
  PageController controller;

  @override
  State<Slides> createState() => _SlidesState();
}

class _SlidesState extends State<Slides> {
  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            widget.image,
            height: 350,
            width: 350,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text(
                  widget.name,
                  style: GoogleFonts.roboto(
                    color: widget.isDark
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.description,
                  style: GoogleFonts.roboto(
                    color: widget.isDark
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.8),
                    fontSize: 15,
                  ),
                ),
                Gap(50),
                SmoothPageIndicator(
                  controller: widget.controller,
                  count: 4,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: widget.isDark
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.primaryContainer,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 8,
                    expansionFactor: 4,
                  ),
                ),
                Gap(30),
                widget.index == 3
                    ? TextButton(
                        style: ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 10)),
                            backgroundColor: MaterialStateProperty.all(
                                widget.isDark
                                    ? Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .outlineVariant
                                        .withOpacity(0.2))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Next",
                          style: GoogleFonts.roboto(
                            color: widget.isDark
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).colorScheme.tertiaryFixed,
                            fontSize: 15,
                          ),
                        ))
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
