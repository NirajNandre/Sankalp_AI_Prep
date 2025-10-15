import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Screens/CommunityScreen.dart';
import 'package:sankalp/views/Screens/HomeScreen.dart';
import 'package:sankalp/views/Screens/InterviewScreen.dart';
import 'package:sankalp/views/Screens/ProfileScreen.dart';
import 'package:sankalp/views/Screens/StudyPage.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    StudyPage(),
    InterviewPage(),
    CommunityPage(),
    ProfilePage(),
  ];

  void _onCenterButtonTap() {
    setState(() {
      _currentIndex = 2; // Index for middle feature
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 110,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: FloatingNavbar(
                currentIndex: _currentIndex,
                onTap: (int index) {
                  if (index == 2) {
                    // Info icon has no effect
                    return;
                  }
                  // Map navbar index > 2 to page index (skip info)
                  setState(() => _currentIndex = index > 2 ? index : index);
                },
                items: [
                  FloatingNavbarItem(icon: Icons.home),
                  FloatingNavbarItem(icon: Icons.menu_book),
                  FloatingNavbarItem(icon: Icons.info_outline_sharp),
                  FloatingNavbarItem(icon: Icons.groups),
                  FloatingNavbarItem(icon: Icons.person),
                ],
                backgroundColor: Colors.black,
                borderRadius: 16,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                selectedBackgroundColor: Colors.transparent,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.white,
                iconSize: 32,
              ),
            ),
            Positioned(
              bottom: 40,
              child: GestureDetector(
                onTap: () {
                  setState(() => _currentIndex = 2);
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: _currentIndex == 2
                        ? Border.all(color: Colors.blueAccent, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/AI_logo.png',
                        fit: BoxFit.contain,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
