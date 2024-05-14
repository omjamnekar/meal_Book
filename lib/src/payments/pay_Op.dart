import 'package:MealBook/src/payments/model/order_Time.dart';
import 'package:MealBook/src/payments/payDone/payDone.dart';
import 'package:MealBook/src/payments/step/frame_Pay.dart';
import 'package:MealBook/src/payments/stepControl/Time_Con.dart';
import 'package:MealBook/src/payments/success.dart';
import 'package:MealBook/respository/model/payInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentGateWay {
  final BuildContext context;
  final bool isCART;
  PaymentGateWay({required this.context, required this.isCART}) {
    init();
  }

  late Razorpay razorpay;
  bool isPayDone = false;
  String paymentId = "";
  String orderId = "";
  OrderTimeControl orderTimeControl = OrderTimeControl();
  OrderFrame orderFrame = OrderFrame();
  init() {
    ////////////////////////////////////////////////////////////////////////////////////////
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

  Future<void> openCheckout(
      Map<String, dynamic> option, OrderFrame orderFrame) async {
    try {
      razorpay.open(option);
      this.orderFrame = orderFrame;
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderFrame.paymentId = response.paymentId;

    orderTimeControl.setDataOrderSetValueToRealTime(orderFrame);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PayDone(),
      ),
    );

    Fluttertoast.showToast(
        msg: "SUCCESS: ${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isPayDone = false;
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    isPayDone = true;
    print("EXTERNAL_WALLET: ${response.walletName!}");
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void dispose() {
    razorpay.clear();
  }
}
