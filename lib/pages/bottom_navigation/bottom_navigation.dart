import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/Inventory/inventory.dart';
import 'package:food_inventory_tracking_app/pages/chatbot/chatbot.dart';
import 'package:food_inventory_tracking_app/pages/home/homepage.dart';
import 'package:food_inventory_tracking_app/pages/profile/profile_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentindex = 0;
  final List<Widget> _pages = [
    HomePage(), //inventory and interactive elements
    ChatPage(),
    InventoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(currentindex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: currentindex,
            onTap: (value) {
              setState(() {
                currentindex = value;
              });
            },
            selectedItemColor:
                const Color(0xFF2E7D32), // Dark green to match theme
            unselectedItemColor: Colors.grey[400],
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 20,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_rounded), label: 'Inventory'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
