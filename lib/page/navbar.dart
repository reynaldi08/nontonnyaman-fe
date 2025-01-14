import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/page/HomePage.dart';
import 'package:my_app/page/profile/profile.dart';
import 'package:my_app/page/requestAssistance/RequestHomePage.dart';
import 'package:my_app/page/emergency/emergency.dart';
import 'package:my_app/page/stadium/searchingPage.dart';

// ignore: must_be_immutable
class Navbar extends StatefulWidget {
  final User user;
  const Navbar(this.user, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavbarPage createState() => _NavbarPage();
}

class _NavbarPage extends State<Navbar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeView(widget.user),
      const SearchPage(),
      const Emergency(),
      const Request(),
      const Profile()
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xffFF7D05),
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(),
              child: const Icon(Icons.house_outlined),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(),
              child: const Icon(Icons.map),
            ),
            label: 'Navigation',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffFF7D05),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 45,
                color: Colors.white,
              ),
            ),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(),
              child: const Icon(Icons.call),
            ),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(),
              child: const Icon(Icons.account_box_outlined),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}