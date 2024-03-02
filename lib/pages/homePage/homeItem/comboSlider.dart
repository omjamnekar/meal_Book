import 'package:MealBook/json/combo.dart';
import 'package:MealBook/provider/actuatorState.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ComboSlider extends StatelessWidget {
  ComboSlider({
    super.key,
    required this.imageListModel,
    required this.imageUrls,
    required this.snapshot,
    required this.comboDataManager,
  });
  List<Object?> comboDataManager;
  final ImageListModel imageListModel;
  final List<String> imageUrls;
  final AsyncSnapshot<List<String>> snapshot;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 230,
      child: Swiper(
        duration: 2,
        curve: Curves.bounceInOut,
        itemBuilder: (BuildContext context, int index) {
          for (var url in imageListModel.imageUrls) {
            imageUrls.add(url);
            precacheImage(NetworkImage(url), context);
          }
          return ClipRRect(
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
                        (comboDataManager[0] as List)[index]["containerColor"]),
                    HexColor("ffffff")
                  ],
                ),
                color: HexColor(
                    (comboDataManager[0] as List)[index]["containerColor"]),
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
                          image: NetworkImage(snapshot.data![index]),
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
                        "${(comboDataManager[0] as List)[index]["name"]}",
                        style: GoogleFonts.passionOne(
                          color: HexColor((comboDataManager[0] as List)[index]
                              ["headerColor"]),
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (comboDataManager[0] as List)[index]
                                  ["dish"]
                              .length,
                          itemBuilder: (context, i) {
                            return Text(
                              "${(comboDataManager[0] as List)[index]["dish"][i]}",
                              style: GoogleFonts.passionOne(
                                color: HexColor((comboDataManager[0]
                                        as List)[index]["text"])
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
                              color: const Color.fromARGB(221, 55, 55, 55)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: (comboDataManager[0] as List).length,
        viewportFraction: 0.95,
        scale: 0.2,
      ),
    );
  }
}
