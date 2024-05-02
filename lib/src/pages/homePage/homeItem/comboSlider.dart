import 'package:MealBook/controller/homeLogic.dart';
import 'package:MealBook/respository/json/combo.dart';
import 'package:MealBook/respository/provider/actuatorState.dart';
import 'package:MealBook/src/components/loaderAnimation.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ComboSlider extends StatefulWidget {
  ComboSlider({
    super.key,
    required this.snapshot,
  });

  // final ImageListModel imageListModel;
  // final List<String> imageUrls;

  final List<Map<dynamic, dynamic>> snapshot;

  @override
  State<ComboSlider> createState() => _ComboSliderState();
}

class _ComboSliderState extends State<ComboSlider> {
  final homeController ctrl = homeController();

  final List<String> imageDatamanager = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 230,
      child: PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
              future: ctrl.fetchProductImage(widget.snapshot[index]["image"]),
              builder: (BuildContext context, AsyncSnapshot<String> imageData) {
                if (imageData.connectionState == ConnectionState.waiting) {
                  return LoadinAnimation(
                    mainFrame: 240,
                    scale: 0.5,
                    viewportFraction: 0.9,
                  );
                } else if (imageData.connectionState == ConnectionState.none) {
                  return LoadinAnimation(
                    mainFrame: 240,
                    scale: 0.5,
                    viewportFraction: 0.9,
                  );
                } else if (imageData.connectionState == ConnectionState.done) {
                  return Container(
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 200,
                        width: 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              HexColor(
                                  widget.snapshot[index]["containerColor"]),
                              HexColor("ffffff")
                            ],
                          ),
                          color: HexColor(
                              widget.snapshot[index]["containerColor"]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: -70,
                              right: -60,
                              child: Container(
                                width: 260,
                                height: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(imageData.data.toString()),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 15,
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  "${widget.snapshot[index]["name"]}",
                                  style: GoogleFonts.passionOne(
                                    color: HexColor(
                                        widget.snapshot[index]["headerColor"]),
                                    fontSize: 29,
                                    height: 1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 90,
                              left: 20,
                              child: SizedBox(
                                  width: 205,
                                  height: 80,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        widget.snapshot[index]["dish"].length,
                                    itemBuilder: (context, i) {
                                      return Text(
                                        "${widget.snapshot[index]["dish"][i]}",
                                        style: GoogleFonts.passionOne(
                                          color: HexColor(widget.snapshot[index]
                                                  ["text"])
                                              .withOpacity(0.5),
                                          fontSize: 15,
                                          height: 1,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      );
                                    },
                                  )),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 20,
                              child: Container(
                                width: 105,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Order",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            221, 55, 55, 55)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return LoadinAnimation(
                  mainFrame: 240,
                  scale: 0.5,
                  viewportFraction: 0.9,
                );
              });
        },
        itemCount: widget.snapshot.length,
      ),
    );
  }
}
