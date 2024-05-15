import 'package:MealBook/controller/accountLogic.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/src/Theme/theme_preference.dart';
import 'package:MealBook/src/Theme/theme_provider.dart';
import 'package:MealBook/src/pages/account/option/profile.dart';
import 'package:MealBook/src/pages/account/option/security.dart';
import 'package:MealBook/src/pages/assecess.dart/access.dart';
import 'package:MealBook/src/pages/help/help.dart';
import 'package:MealBook/src/pages/orderCart/ord_loading.dart';
import 'package:MealBook/src/pages/orderCart/orderRec.dart';
import 'package:MealBook/src/pages/paymentHistory/historyPay.dart';
import 'package:MealBook/src/util/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as provider;

class AccountManager extends ConsumerStatefulWidget {
  const AccountManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountManagerState();
}

class _AccountManagerState extends ConsumerState<AccountManager>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  UserDataManager? userDataManager;
  String sd = "";

  @override
  void initState() {
    super.initState();
    sd = UserExcess.userDefault;
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String str =
        provider.Provider.of<ThemeProvider>(context).themeData.brightness ==
                Brightness.dark
            ? "Dark"
            : "Light";
    List<Map<String, dynamic>> accountOption = [
      {
        "label": "Profile Information",
        "icon": Icons.person,
      },
      {
        "label": "Display Theme: ${str}",
        "icon": Icons
            .brightness_6 // You can choose a suitable icon for theme display
      },
      {"label": "Security and Privacy Settings", "icon": Icons.security},
      {"label": "Notification Preferences", "icon": Icons.notifications},
      {"label": "Accessibility Options", "icon": Icons.accessibility},
      {"label": "Data and Privacy", "icon": Icons.data_usage},
      {"label": "Help and Support", "icon": Icons.help},
      {"label": "Orders", "icon": Icons.shopping_cart},
      {"label": "payments History", "icon": Icons.payment_sharp},
      {"label": "Logout/Sign Out", "icon": Icons.exit_to_app},
    ];

    ThemePreferences themePreferences = ThemePreferences();

    return GetBuilder<AccountLogic>(
        init: AccountLogic(),
        builder: (ctrl) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(seconds: 2),
                        right: _visible ? -30 : -200,
                        top: _visible ? -30 : -200,
                        curve: Curves.easeInOut,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, -10 * _animation.value),
                              child: child,
                            );
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 2300),
                        right: _visible ? -30 : -200,
                        top: _visible ? -30 : -10,
                        curve: Curves.easeInOut,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, -10 * _animation.value),
                              child: child,
                            );
                          },
                          child: AnimatedPositioned(
                            duration: Duration(seconds: 2),
                            right: _visible ? -30 : -150,
                            top: _visible ? -30 : -150,
                            curve: Curves.easeInOut,
                            child: FutureBuilder<UserDataManager>(
                                future: ctrl.getUser(),
                                builder: (context,
                                    AsyncSnapshot<UserDataManager> imageURL) {
                                  userDataManager = imageURL.data;
                                  String imageUrl = str;
                                  if (imageURL.data != null &&
                                      imageURL.data!.image != null &&
                                      imageURL.data!.image!.isNotEmpty) {
                                    imageUrl = imageURL.data!.image!;
                                  }

                                  return Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    child: imageURL.data != null
                                        ? Transform.translate(
                                            offset: Offset(0, 30),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Hero(
                                                  tag: "profileImage",
                                                  child: Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: 110,
                                                    height: 110,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  );
                                }),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<UserDataManager>(
                    future: ctrl.getUser(),
                    builder:
                        (context, AsyncSnapshot<UserDataManager> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      if (snapshot.hasData) {
                        return Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.name ?? "UserName",
                                      style: GoogleFonts.poppins(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.email ??
                                          "UserEmail@gamil.com",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: userAccount,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.8)),
                                    shape: MaterialStateProperty.all(
                                        CircleBorder()),
                                  ),
                                  icon: Icon(
                                    Icons.edit_note_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryFixed,
                                  )),
                            ],
                          ),
                        );
                      }

                      return Container();
                    }),
                Gap(20),
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Divider(
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: accountOption.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (accountOption[index]["label"] ==
                                          "Display Theme: Dark" ||
                                      accountOption[index]["label"] ==
                                          "Display Theme: Light") {
                                    context.read<ThemeProvider>().toggleTheme();
                                  }
                                },
                                child: ListTile(
                                    title: Text(
                                      accountOption[index]["label"],
                                      style: accountOption[index]["label"] !=
                                              "Logout/Sign Out"
                                          ? Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                          : Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer
                                                      .withOpacity(0.7)),
                                    ),
                                    leading: Icon(
                                      accountOption[index]["icon"] as IconData,
                                    ),
                                    onTap: () {
                                      if (accountOption[index]["label"] ==
                                          "Security and Privacy Settings") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SecurityCheck()));
                                      }
                                      if (accountOption[index]["label"] ==
                                          "Logout/Sign Out") {
                                        ctrl.signOut(context, ref);
                                      }

                                      if (accountOption[index]["label"] ==
                                          "Profile Information") {
                                        userAccount();
                                      }

                                      if (accountOption[index]["label"] ==
                                          "Display Theme: ${str}") {
                                        bool sd =
                                            Theme.of(context).brightness ==
                                                Brightness.dark;

                                        ThemePreferences.setDarkMode(!sd);
                                        context
                                            .read<ThemeProvider>()
                                            .toggleTheme();
                                      }
                                      if (accountOption[index]["label"] ==
                                          "Help and Support") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HelpAndSupportPage(),
                                          ),
                                        );
                                      }
                                      if (accountOption[index]["label"] ==
                                          "payments History") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentHistoryPage(),
                                          ),
                                        );
                                      }

                                      if (accountOption[index]["label"] ==
                                          "Accessibility Options") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AccessibilityOptionsPage(),
                                          ),
                                        );
                                      }
                                      if (accountOption[index]["label"] ==
                                          "Orders") {
                                        // navigate

                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                OrdLoading(child: OrderRec()),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              var begin = 0.0;
                                              var end = 1.0;
                                              var curve = Curves.ease;

                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));

                                              return ScaleTransition(
                                                scale: animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    }),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  userAccount() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Profile(
            imageUrl: userDataManager!.image!,
            userDataManager: userDataManager!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
