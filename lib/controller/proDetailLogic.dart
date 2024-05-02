import 'dart:async';

import 'package:MealBook/respository/model/combo.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProDetailLogic extends GetxController {
  late PageController pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late Timer _timer;
  num totalPrice = 0;
  @override
  void dispose() {
    stopAutoScroll();
    pageController.dispose();
    super.dispose();
  }

  void startAutoScroll(int len) {
    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < len - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void stopAutoScroll() {
    _timer?.cancel();
  }

  void totalPriceSetter(List<Combo> allData) {
    totalPrice = 0;
    allData.forEach((element) {
      totalPrice += element.rate;
    });
  }

  void totalAddetSetter(num price) {}
}
