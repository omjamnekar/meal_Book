import 'package:MealBook/respository/model/combo.dart';
import 'package:MealBook/src/pages/proD/productDetail.dart';
import 'package:flutter/material.dart';

class NavigatorToDetail {
  navigatorToProDetail(
      BuildContext context, List<Combo> combo, List<dynamic> _recData) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProductDetail(
          allData: combo,
          recData: _recData,
        ),
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
