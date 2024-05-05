import 'dart:ffi';
import 'dart:ui';

import 'package:MealBook/respository/model/payInfo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentGateWay {
  late Razorpay razorpay;

  init() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  PayRazorUser payInfoprocess(
      String name, String email, int contect, int amount, Food food) {
    return PayRazorUser(
      name: name,
      email: email,
      contect: contect,
      amount: amount,
      food: food,
    );
  }

  Map<String, dynamic> frameDataToCheck(PayRazorUser Userpay) {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': Userpay.amount * 100, //in the smallest currency sub-unit.,
      'name': "Meal Book",
      'description': "Alway here to serve you",
      'send_sms_hash': true,
      'prefill': {
        'contact': Userpay.contect.toString(),
        'email': Userpay.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    return options;
  }

  Future<void> openCheckout(Map<String, dynamic> option) async {
    try {
      razorpay.open(option);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: ${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(
        "////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
    print("EXTERNAL_WALLET: ${response.walletName!}");
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void dispose() {
    razorpay.clear();
  }
}
