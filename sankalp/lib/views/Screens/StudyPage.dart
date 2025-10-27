import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Components/SubjectCard.dart';
import 'package:sankalp/views/Screens/MainScreen.dart';
import 'package:sankalp/views/Screens/SubjectScreen.dart';

class StudyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.getWidth(context)*0.04, vertical: ScreenSize.getHeight(context)*0.06),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar with back and title
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Centered Title
                      Center(
                        child: Text("Study",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenSize.getWidth(context)*0.065)),
                      ),
                      // Back button aligned to the left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left, size: 32),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()),
                                  (route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenSize.getHeight(context)*0.05),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        contentPadding: EdgeInsets.symmetric(horizontal: ScreenSize.getWidth(context)*0.05, vertical: ScreenSize.getHeight(context)*0.015),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenSize.getHeight(context)*0.025),
                  Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(ScreenSize.getWidth(context)*0.035),
                              decoration: BoxDecoration(
                                color: AppColors.blueColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Current Affairs", style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenSize.getWidth(context)*0.07, height: 1.12)),
                                  SizedBox(height: ScreenSize.getHeight(context)*0.005),
                                  Text("Daily \nupdates", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.04,fontWeight: FontWeight.w500, height: 1.12)),
                                  SizedBox(height: ScreenSize.getHeight(context)*0.06),
                                  Row(
                                    children: [
                                      Text("Claim daily xp", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.03, fontWeight: FontWeight.w500)),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(9),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text("+5", style: TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(width: 2),
                                            Icon(Icons.flash_on, color: Colors.yellow[700], size: 16),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Red dot positioned on top right
                            Positioned(
                              top: 15,
                              right: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: ScreenSize.getWidth(context)*0.03),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(ScreenSize.getWidth(context)*0.035),
                          decoration: BoxDecoration(
                            color: AppColors.purpleColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Revision Notes", style: TextStyle(fontWeight: FontWeight.w800, fontSize: ScreenSize.getWidth(context)*0.07, height: 1.12)),
                              SizedBox(height: ScreenSize.getHeight(context)*0.005),
                              Text("summarized", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.04,fontWeight: FontWeight.w500, height: 1.12)),
                              SizedBox(height: ScreenSize.getHeight(context)*0.082),
                              Row(
                                children: [
                                  Text("Claim daily xp", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.03, fontWeight: FontWeight.w500)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text("+2", style: TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 2),
                                        Icon(Icons.flash_on, color: Colors.yellow[700], size: 16),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: ScreenSize.getHeight(context)*0.025),
                  Text("Subjects", style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenSize.getWidth(context)*0.05)),
                  SizedBox(height: ScreenSize.getHeight(context)*0.01),
                  // Only this grid is scrollable
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    childAspectRatio: 2.5,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      SubjectCard(name: "Polity", color: const Color(0xFFFFF7D4), progress: 0.3, onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SubjectPage()),
                        );
                      }
                      ),
                      SubjectCard(name: "Geography", color: const Color(0xFFC8FFD3), progress: 0.5, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubjectPage()),
                      );}),
                      SubjectCard(name: "Modern history", color: const Color(0xFFFFD4D7), progress: 0.25, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubjectPage()),
                      );}),
                      SubjectCard(name: "Science & Tech", color: const Color(0xFFD9D4FF), progress: 0.15, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubjectPage()),
                      );}),
                      SubjectCard(name: "Indian Economy", color: const Color(0xFFFFF7D4), progress: 0.4, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubjectPage()),
                      );}),
                      SubjectCard(name: "Environment", color: const Color(0xFFC8FFD3), progress: 0.75, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubjectPage()),
                      );}),
                      SubjectCard(name: "Social justice", color: const Color(0xFFFFD4D7), progress: 0.45, onTap: () {}),
                      SubjectCard(name: "Ethics & Aptitude", color: const Color(0xFFD9D4FF), progress: 0.32, onTap: () {}),
                      SubjectCard(name: "Ancient History", color: const Color(0xFFFFF7D4), progress: 0.6, onTap: () {}),
                      SubjectCard(name: "Art & Culture", color: const Color(0xFFC8FFD3), progress: 0.1, onTap: () {}),
                      SubjectCard(name: "I.R.", color: const Color(0xFFFFD4D7), progress: 0.55, onTap: () {}),
                      SubjectCard(name: "Internal Security", color: const Color(0xFFD9D4FF), progress: 0.2, onTap:() {}),
                      SubjectCard(name: "Post-Indep.", color: const Color(0xFFFFF7D4), progress: 0.35, onTap: (){}),
                      SubjectCard(name: "World History", color: const Color(0xFFC8FFD3), progress: 0.05, onTap:() {}),
                      SizedBox(height: ScreenSize.getHeight(context)*0.01)
                    ],
                  ),
                  SizedBox(height: ScreenSize.getHeight(context)*0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
