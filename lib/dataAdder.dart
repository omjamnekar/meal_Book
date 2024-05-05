import 'package:MealBook/respository/json/combo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Cart extends StatefulWidget {
  Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  String displayText = 'Results go here!';

  Future<void> snapshot() async {
    // Assuming you want to retrieve data
    //from Firebase
    DataSnapshot snapshot = await ref.child('asf/').get();
    await call();
    setState(() {
      displayText = snapshot.value.toString(); // Update the display text
    });
  }

  Future<void> call() async {
    print("a");
    await ref.child('all/').set(all);
    print("work is done");
  }

  @override
  void initState() {
    super.initState();

    snapshot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(50),
            ElevatedButton(
              onPressed: () {
                snapshot(); // Call the snapshot function to update the data
              },
              child: const Text("Add Data"),
            ),
            Text(displayText,
                style: const TextStyle(
                    color: Colors.white)), // Display the updated text
          ],
        ),
      ),
    );
  }
}
