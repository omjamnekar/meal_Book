import 'package:MealBook/controller/homeLogic.dart';
import 'package:MealBook/src/components/loaderAnimation.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralItem extends StatefulWidget {
  GeneralItem({
    super.key,
    required this.cntr,
  });
  homeController cntr;

  @override
  State<GeneralItem> createState() => _GeneralItemState();
}

class _GeneralItemState extends State<GeneralItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 200,
      margin: const EdgeInsets.only(bottom: 20),
      child: FutureBuilder(
          future: widget.cntr.generalLoading(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snp) {
            if (snp.connectionState == ConnectionState.done && snp.hasData) {
              return Swiper(
                containerHeight: 420,
                itemCount: snp.data!.length,
                itemBuilder: (context, index) {
                  return Transform.translate(
                    offset: Offset(-40, 0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Color.fromARGB(136, 62, 62, 62)),
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.tertiaryContainer,
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
                                  "${snp.data![index]!["ITEMS"]}",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      height: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary),
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                viewportFraction: 0.4,
                scale: 0.5,
              );
            }
            if (snp.connectionState == ConnectionState.waiting ||
                !snp.hasData) {
              return LoadinAnimation(
                mainFrame: 200,
                scale: 0.5,
                viewportFraction: 0.4,
              );
            }

            if (snp.connectionState == ConnectionState.waiting ||
                !snp.hasData) {
              return const CircularProgressIndicator();
            }

            return const CircularProgressIndicator();
          }),
    );
  }
}



  //  FutureBuilder(
  //                             future: widget.cntr
  //                                 .listImage(snp.data![index]!["IMAGE"]),
  //                             builder: (context, AsyncSnapshot<String> image) {
  //                               print(image.data);
  //                               if (image.connectionState ==
  //                                       ConnectionState.waiting &&
  //                                   !image.hasData) {
  //                                 return Container();
  //                               } else if (image.connectionState ==
  //                                       ConnectionState.done &&
  //                                   image.hasData) {
  //                                 return Positioned(
  //                                   bottom: -70,
  //                                   right: -5,
  //                                   child: Container(
  //                                     margin: const EdgeInsets.only(
  //                                         top: 20, left: 10),
  //                                     width: 150,
  //                                     child: Image.network(
  //                                       image.data!,
  //                                       width: 200,
  //                                       height: 200,
  //                                     ),
  //                                   ),
  //                                 );
  //                               } else {
  //                                 return Container(
  //                                   child: Text("No Image"),
  //                                 );
  //                               }
  //                             }),
            
            