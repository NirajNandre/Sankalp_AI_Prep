
import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Components/InfoCard.dart';
import 'package:sankalp/views/Components/WeakTopic.dart';
import 'package:sankalp/views/Screens/SubjectScreen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image layer (make sure asset path is correct and declared in pubspec.yaml)
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png", // Replace with your actual image path
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 60),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.menu, size: 32),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                                SizedBox(width: 4),
                                Text("7", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 202, 117,30),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.notifications_none_sharp, color: Colors.deepOrange, size: 26)),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                      height: ScreenSize.getHeight(context)*0.1,
                  ),
                  const Text("Hello,\nRaj Verma!", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40, height: 1.12)),
                  SizedBox(height: ScreenSize.getHeight(context)*0.04),
                  const Text("Today's", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1: Daily Quizes (full height)
                      Expanded(
                        flex: 46,
                        child: SizedBox(
                          height: ScreenSize.getHeight(context)*0.27,
                          child: InfoCard(
                            color: const Color(0xFFD7E7FB),
                            child: Stack(
                              children: [
                                Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Daily Quizes", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 34, height: 1.12),),
                                  const SizedBox(height: 6,),
                                  const Text("Based on \nPYQ's", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  SizedBox(height: ScreenSize.getHeight(context)*0.07),
                                  Row(
                                    children: [
                                      const Text("Claim daily xp", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Row(
                                          children: [
                                            Text("+20", style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(width: 4),
                                            Icon(Icons.flash_on, color: Colors.yellow, size: 18),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                                Positioned(
                                  top:  5,
                                  right: 2,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Column 2: Live Lectures + Chapter 4
                      Expanded(
                        flex: 46,
                        child: Column(
                          children: [
                            InfoCard(
                              color: const Color(0xFFCDF6DB),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Live Lectures", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26, height: 1.12)),
                                  const SizedBox(height: 5,),
                                  const Text("Join Live:", style: TextStyle(fontSize: 12, color: Colors.black)),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Article 370 & Federalism",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            InfoCard(
                              color: const Color(0xFFFFF6DA),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Chapter 4", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                                  const Text("Polity - Fundamental rights", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: 0.3,
                                          backgroundColor: Colors.grey[300],
                                          color: Colors.blueAccent,
                                          minHeight: 5,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text("30% completed", style: TextStyle(fontSize: 10, color: Colors.blueGrey)),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SubjectPage()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Progress Overview", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  const SizedBox(height: 10),
                  const WeakTopicCard(
                    pngPath: "assets/images/target.png",
                    topics: [
                      "Economics - Inflation",
                      "History - 1887 Revolt",
                      "Politics - Government",
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}