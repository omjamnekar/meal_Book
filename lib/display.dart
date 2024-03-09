// import 'package:MealBook/controller/comboLogic.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';

// class Display extends StatefulWidget {
//   const Display({super.key});

//   @override
//   State<Display> createState() => _DisplayState();
// }

// class _DisplayState extends State<Display> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetBuilder<ComboLogic>(
//         init: ComboLogic(),
//         builder: (ctrl) {
//           return FutureBuilder(
//               // future: ctrl.fetchImage("chinese", "chicken"),
//               builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting ||
//                     !snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }
//                 print(snapshot.data);
//                 return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       child: Image.network(snapshot.data![index]),
//                     );
//                   },
//                 );
//               });
//         },
//       ),
//     );
//   }
// }
