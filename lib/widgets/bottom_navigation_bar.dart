import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onTabTapped,
  });

  void handleTabTap(BuildContext context, int index) {
    onTabTapped(index);

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/guardian_event_screen',(route) => false,);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, '/my_guardian_events_screen',(route) => false,);
        break;
      case 2:
        Navigator.pushNamed(context, '/your_dogs');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Dog Sitter Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'My Guardian Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: 'My Dogs',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.amber,
      unselectedItemColor: const Color.fromARGB(255, 42, 42, 41),
      onTap: (index) => handleTabTap(context, index),
    );
  }
}
