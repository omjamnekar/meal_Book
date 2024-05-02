import 'package:MealBook/controller/generalControler.dart';
import 'package:MealBook/respository/json/combo.dart';
import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/components/loaderAnimation.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Recommed extends StatelessWidget {
  Recommed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RecommendedData().imageURlList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<String>> snapListImage) {
          if (snapListImage.connectionState == ConnectionState.waiting) {
            return LoadinAnimation(
              mainFrame: 200,
              scale: 0.5,
              viewportFraction: 0.4,
            );
          } else if (snapListImage.connectionState == ConnectionState.none) {
            return LoadinAnimation(
              mainFrame: 200,
              scale: 0.5,
              viewportFraction: 0.4,
            );
          } else if (snapListImage.connectionState == ConnectionState.done &&
              snapListImage.hasData) {
            return Container(
              width: MediaQuery.sizeOf(context).width,
              height: 200,
              margin: const EdgeInsets.only(bottom: 20),
              child: Swiper(
                containerHeight: 420,
                itemCount: snapListImage.data!.length,
                itemBuilder: (context, index) {
                  if (snapListImage.connectionState ==
                      ConnectionState.waiting) {
                    return _imageLoading();
                  } else if (snapListImage.connectionState ==
                      ConnectionState.done) {
                    return Transform.translate(
                      offset: Offset(-40, 0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Color.fromARGB(136, 62, 62, 62)),
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        child: Stack(
                          children: [
                            const Positioned(
                                top: 10,
                                right: 10,
                                child: Icon(Icons.arrow_forward)),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 20, left: 10),
                                  width: 110,
                                  child: Text(
                                    comboData[index]!["name"],
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        height: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiary),
                                  )),
                            ),
                            Positioned(
                              bottom: -9,
                              right: -10,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 20, left: 10),
                                width: 150,
                                child: Image.network(
                                  snapListImage.data![index],
                                  width: 110,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return _imageLoading();
                },
                viewportFraction: 0.4,
                scale: 0.5,
              ),
            );
          }

          return LoadinAnimation(
            mainFrame: 200,
            scale: 0.5,
            viewportFraction: 0.4,
          );
        });
  }

  Widget _imageLoading() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 250, //250
          height: 200, //200
          color: Colors.white,
        ),
      ),
    );
  }
}
