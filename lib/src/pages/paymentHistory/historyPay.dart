import 'package:flutter/material.dart';

class Payment {
  final String date;
  final String amount;
  final String status;

  Payment({
    required this.date,
    required this.amount,
    required this.status,
  });
}

class PaymentHistoryPage extends StatelessWidget {
  final List<Payment> payments = [
    Payment(date: 'May 1, 2024', amount: 'Rs50.00', status: 'Completed'),
    Payment(date: 'April 20, 2024', amount: 'Rs30.00', status: 'Completed'),
    Payment(date: 'April 5, 2024', amount: 'Rs25.00', status: 'Failed'),
    // Add more payments as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Payment History'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Total Payments: ${payments.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          )),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          Payment payment = payments[index];
          return ListTile(
            title: Text(payment.date),
            subtitle:
                Text('Amount: ${payment.amount} - Status: ${payment.status}'),
            onTap: () {
              // You can add functionality here to show more details of the payment
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentHistoryPage(),
  ));
}
