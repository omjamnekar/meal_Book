import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadinAnimation extends StatelessWidget {
  LoadinAnimation({
    super.key,
    required this.mainFrame,
    required this.scale,
    required this.viewportFraction,
  });

  final double mainFrame;

//
  final double viewportFraction;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: mainFrame, //200
      child: Swiper(
        duration: 2,
        itemCount: 10,
        curve: Curves.bounceInOut,
        itemBuilder: (BuildContext context, int index) {
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
        },
        viewportFraction: viewportFraction, //0.9
        scale: scale, //0.5
      ),
    );
  }
}
