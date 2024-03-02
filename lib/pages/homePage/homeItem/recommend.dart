import 'package:MealBook/json/combo.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubRecommed extends StatelessWidget {
  SubRecommed({
    super.key,
    required this.snapshot,
  });

  AsyncSnapshot<List<String>> snapshot;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 200,
      child: Swiper(
        containerHeight: 440,
        itemCount: comboData.length,
        itemBuilder: (context, index) {
          return Transform.translate(
            offset: Offset(-40, 3),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black
                //         .withOpacity(0.2), // Shadow color
                //     spreadRadius: 3, // Spread radius
                //     blurRadius: 10, // Blur radius
                //     offset: Offset(0, 3), // Offset in x and y
                //   ),
                // ],
                border: Border.all(
                    width: 1, color: const Color.fromARGB(137, 39, 39, 39)),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 10, right: 10, child: Icon(Icons.arrow_forward)),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20, left: 10),
                        width: 110,
                        child: Text(
                          comboData[index]!["name"],
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 1,
                              color: Theme.of(context).colorScheme.onTertiary),
                        )),
                  ),
                  Positioned(
                    bottom: -9,
                    right: -10,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, left: 10),
                      width: 150,
                      child: Image.network(
                        snapshot.data![index],
                        width: 110,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        viewportFraction: 0.4,
        scale: 0.5,
      ),
    );
  }
}
