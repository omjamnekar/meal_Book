import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer({
    super.key,
  });

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int indexbase = 0;
  // @override
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // unselectedLabelStyle: TextStyle(color: Colors.grey),
      unselectedLabelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),

      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.fastfood,
          ),
          label: 'Food',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'COMBO',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'SEARCH',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'ACCOUNT',
        ),
      ],
      // Set the currentIndex and implement the onTap callback to handle taps.
      currentIndex: indexbase,
      onTap: (index) {
        switch (index) {
          case 0:
            setState(() {
              indexbase = index;
            });
            break;
          case 1:
            print("as");
            setState(() {
              indexbase = index;
            });
            break;
          case 2:
            setState(() {
              indexbase = index;
            });
            // Navigate to School
            break;
          case 3:
            setState(() {
              indexbase = index;
            });
            // Navigate to Settings
            break;
        }
      },
    );
  }
}
