import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessPayScreen extends StatefulWidget {
  String paymentId;
  String orderId;
  SuccessPayScreen({required this.paymentId, required this.orderId});
  @override
  State<SuccessPayScreen> createState() => _SuccessPayScreenState();
}

class _SuccessPayScreenState extends State<SuccessPayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset("assets/lottie/done.json"),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
