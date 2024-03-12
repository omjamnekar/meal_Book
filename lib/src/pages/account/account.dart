import 'package:MealBook/controller/accountLogic.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/src/Theme/theme_provider.dart';
import 'package:MealBook/src/util/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  void initState() {
    super.initState();

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
    List<Map<String, dynamic>> _accountOption = [
      {"label": "Profile Information", "icon": Icons.person},
      {
        "label":
            "Display Theme: ${provider.Provider.of<ThemeProvider>(context).themeData.brightness == Brightness.dark ? "Dark" : "Light"}",
        "icon": Icons
            .brightness_6 // You can choose a suitable icon for theme display
      },
      {"label": "Security and Privacy Settings", "icon": Icons.security},
      {"label": "Notification Preferences", "icon": Icons.notifications},
      {"label": "Accessibility Options", "icon": Icons.accessibility},
      {"label": "Data and Privacy", "icon": Icons.data_usage},
      {"label": "Help and Support", "icon": Icons.help},
      {"label": "payments History", "icon": Icons.payment_sharp},
      {"label": "Logout/Sign Out", "icon": Icons.exit_to_app},
    ];

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
                                                child: Image.network(
                                                  imageURL.data!.image ??
                                                      UserExcess.userDefault,
                                                  fit: BoxFit.cover,
                                                  width: 110,
                                                  height: 110,
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
                                  onPressed: () {},
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
                            itemCount: _accountOption.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Text(
                                    _accountOption[index]["label"],
                                    style: _accountOption[index]["label"] !=
                                            "Logout/Sign Out"
                                        ? Theme.of(context).textTheme.subtitle1!
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
                                    _accountOption[index]["icon"] as IconData,
                                  ),
                                  onTap: () {
                                    if (_accountOption[index]["label"] ==
                                        "Logout/Sign Out") {
                                      ctrl.signOut(context, ref);
                                    }
                                  });
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
}
