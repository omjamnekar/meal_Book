import 'dart:core';

import 'package:MealBook/src/Theme/theme_preference.dart';
import 'package:MealBook/src/Theme/theme_provider.dart';
import 'package:MealBook/controller/homeLogic.dart';
import 'package:MealBook/data.dart';
import 'package:MealBook/firebase/image.dart';
import 'package:MealBook/respository/json/combo.dart';
import 'package:MealBook/respository/model/user.dart';
import 'package:MealBook/src/pages/account/account.dart';
import 'package:MealBook/src/pages/combo/combo.dart';
import 'package:MealBook/src/pages/homePage/homeItem/comboSlider.dart';
import 'package:MealBook/src/pages/homePage/footer.dart';
import 'package:MealBook/src/pages/homePage/homeItem/menuItem.dart';
import 'package:MealBook/src/pages/homePage/homePage.dart';
import 'package:MealBook/src/pages/searchPage/search.dart';
import 'package:MealBook/respository/provider/actuatorState.dart';
import 'package:MealBook/respository/provider/userState.dart';
import 'package:MealBook/src/showCase/showHome.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:http/http.dart' as http;
import 'package:popover/popover.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/uuid.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<MainPage> {
  int indexPage = 0;
  late ImageListModel imageListModel;
  DatabaseReference references = FirebaseDatabase.instance.ref();
  List<Object?> comboDataManager = [];
  UserDataManager user = UserDataManager(Uuid().v4());
  UserState userData = UserState();
  void snapshot() async {
    await UserState.getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    final snapshot = await references.child('combo/').get();
    if (snapshot.exists) {
      comboDataManager.add(snapshot.value);
    } else {
      print('No Data Available');
    }
  }

  bool isDark = false;
  setter() async {
    isDark = await ThemePreferences.isDarkMode();
  }

  @override
  void initState() {
    super.initState();
    snapshot();
    setter();
    imageListModel = ref.read(imageListProvider.notifier).currentImageState;
  }

  homeController ctrla = homeController();

  FireStoreDataBase storage = FireStoreDataBase();
  PageController pageController = PageController();

  void changePage(int pageIndex) {
    pageController.jumpToPage(pageIndex);
    setState(() {
      indexPage = pageIndex;
    });
  }

//Combo
  final List<String> imageUrls = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            width: MediaQuery.sizeOf(context).width,
            height: 50,
            child: Row(
              children: [
                Container(
                  width: 150,
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        user.name ?? "UserName",
                        style: GoogleFonts.roboto(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      Gap(10),
                      PopupMenuButton(
                        onSelected: (value) {
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) =>Account)
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        offset: Offset(-97, 24),
                        child: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          size: 20.0,
                          color: Color.fromARGB(221, 76, 76, 76),
                        ),
                        surfaceTintColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        itemBuilder: (BuildContext bc) {
                          return [
                            PopupMenuItem(
                              value: '/contact',
                              child: Container(
                                width: 200,
                                child: Row(
                                  children: [
                                    Container(
                                        width: 140,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${user.name ?? "UserName"}",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  height: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Gap(5),
                                            Text(
                                              "${user.email ?? "abc@gmail.com"}",
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        width: 60,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image.network(
                                              user.image ??
                                                  "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                                              width: 60,
                                              height: 60,
                                            ))),
                                  ],
                                ),
                              ),
                            )
                          ];
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                        child: Container(
                          child: Icon(
                            Icons.nightlight_outlined,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      Gap(20),
                      GestureDetector(
                        onTap: () {
                          //  Future<SignUpPlatform> signUpPlatformManager() async {

                          ctrla.signOut(ref, context);
                        },
                        child: Transform.scale(
                          scale: 2,
                          child: Image.asset("assets/logo/burgur.png",
                              width: 20, height: 20),
                        ), // Increase the width and height values to scale up the image
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: GetBuilder<homeController>(
          init: homeController(),
          builder: (ctrl) {
            List<Widget> list = [
              HomePageWidget(
                  ctrl: ctrl,
                  user: user,
                  ref: ref,
                  storage: storage,
                  imageListModel: imageListModel,
                  imageUrls: imageUrls,
                  comboDataManager: comboDataManager),
              ComboStore(),
              SearchPage(),
              AccountManager(),
            ];
            return SafeArea(
                child: PageView.builder(
                    onPageChanged: (int page) {
                      print(page);
                      setState(() {
                        indexPage = page;
                      });
                    },
                    scrollBehavior: ScrollBehavior(),
                    controller: pageController,
                    itemCount: list.length,
                    itemBuilder: (context, indexPAGE) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            imageListModel = ref
                                .read(imageListProvider.notifier)
                                .currentImageState;
                          });
                        },
                        child: list[indexPAGE],
                      );
                    }));
          }),
      bottomNavigationBar: Footer(
          indexPage: indexPage,
          onTabTapped: (index) {
            changePage(index);
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        onPressed: () {},
        child: Transform.translate(
          offset: Offset(-2, 1),
          child: Center(
            child: Image.asset(
              "assets/image/boat/boat.png",
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
  }
}
