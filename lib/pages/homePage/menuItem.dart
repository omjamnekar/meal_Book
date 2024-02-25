import 'package:MealBook/provider/actuatorState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuItem extends ConsumerWidget {
  MenuItem({
    super.key,
    required this.name,
    required this.email,
  });
  String name;
  String email;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 100,
          child: Text(
            name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: 300,
          height: 100,
          child: Text(
            email,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
