import 'package:MealBook/json/combo.dart';
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

  Object? products;
  List productList = [];
  String displayText = 'Results go here!';

  snapshot() async {
    final snapshot = await ref.child('comboData/').get();
    productList = [];
    if (snapshot.exists) {
      productList.add(snapshot.value);
      products = (snapshot.value);
      print(snapshot);
      print(snapshot.value);
    } else {
      print('No Data Available');
    }
  }

  call() async {
    final snapshot = ref.child('comboData/');
    snapshot.set(comboData).then((value) => print("work is done"));
  }

  @override
  void initState() {
    super.initState();
    call();
    snapshot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Gap(50),
        ElevatedButton(
          onPressed: () async {
            // await ref.set({"name": "Tyler"});
            call();
          },
          child: const Text("Add Data"),
        ),
        Text("${snapshot()}", style: TextStyle(color: Colors.white))
      ],
    ));
  }
}
