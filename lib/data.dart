import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class PopoverExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Popover Example')),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Button(),
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: GestureDetector(
        child: const Center(child: Text('Click Me')),
        onTap: () {},
      ),
    );
  }
}

// class ListItems extends StatelessWidget {
//   const ListItems({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: ListView(
//         padding: const EdgeInsets.all(8),
//         children: [
//           InkWell(
//             onTap: () {
//               Navigator.of(context)
//                 ..pop()
//                 ..push(
//                   MaterialPageRoute<SecondRoute>(
//                     builder: (context) => SecondRoute(),
//                   ),
//                 );
//             },
//             child: Container(
//               height: 50,
//               color: Colors.amber[100],
//               child: const Center(child: Text('Entry A')),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
