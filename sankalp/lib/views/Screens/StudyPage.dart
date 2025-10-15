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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with back and title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 32),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MainScreen()),
                              (route) => false,
                        );
                      },
                    ),
                    const Text("Study", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                    SizedBox(width: ScreenSize.getWidth(context)*0.05),
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
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.blueColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Current Affairs", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28, height: 1.12)),
                                const SizedBox(height: 6,),
                                const Text("Daily \nupdates", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500, height: 1.12)),
                                const SizedBox(height: 50),
                                Row(
                                  children: [
                                    const Text("Claim daily xp", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
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
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.purpleColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Revision Notes", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28, height: 1.12)),
                            const Text("summarized", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500, height: 1.12)),
                            const SizedBox(height: 75),
                            Row(
                              children: [
                                const Text("Claim daily xp", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
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
                const SizedBox(height: 22),
                const Text("Subjects", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                const SizedBox(height: 10),
                // Only this grid is scrollable
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    childAspectRatio: 2.5,
                    padding: EdgeInsets.zero,
                    children: [
                      SubjectCard(name: "Polity", color: const Color(0xFFFFF7D4), progress: 0.3, onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SubjectPage()),
                        );
                      }
                      ),
                      SubjectCard(name: "Geography", color: const Color(0xFFC8FFD3), progress: 0.5, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubjectPage()),
                      );}),
                      SubjectCard(name: "Modern history", color: const Color(0xFFFFD4D7), progress: 0.25, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubjectPage()),
                      );}),
                      SubjectCard(name: "Science & Tech", color: const Color(0xFFD9D4FF), progress: 0.15, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubjectPage()),
                      );}),
                      SubjectCard(name: "Indian Economy", color: const Color(0xFFFFF7D4), progress: 0.4, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubjectPage()),
                      );}),
                      SubjectCard(name: "Environment", color: const Color(0xFFC8FFD3), progress: 0.75, onTap: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubjectPage()),
                      );}),
                      SubjectCard(name: "Social justice", color: const Color(0xFFFFD4D7), progress: 0.45, onTap: () {}),
                      SubjectCard(name: "Ethics & Aptitude", color: const Color(0xFFD9D4FF), progress: 0.32, onTap: () {}),
                      SubjectCard(name: "Ancient History", color: const Color(0xFFFFF7D4), progress: 0.6, onTap: () {}),
                      SubjectCard(name: "Art & Culture", color: const Color(0xFFC8FFD3), progress: 0.1, onTap: () {}),
                      SubjectCard(name: "I.R.", color: const Color(0xFFFFD4D7), progress: 0.55, onTap: () {}),
                      SubjectCard(name: "Internal Security", color: const Color(0xFFD9D4FF), progress: 0.2, onTap:() {}),
                      SubjectCard(name: "Post-Indep.", color: const Color(0xFFFFF7D4), progress: 0.35, onTap: (){}),
                      SubjectCard(name: "World History", color: const Color(0xFFC8FFD3), progress: 0.05, onTap:() {}),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
