
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
            padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.getWidth(context)*0.035,
                vertical: ScreenSize.getHeight(context)*0.07),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.menu, size: ScreenSize.getWidth(context)*0.08),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0.8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.local_fire_department, color: Colors.orange, size: ScreenSize.getHeight(context)*0.03),
                                const SizedBox(width: 3),
                                Text("7", style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenSize.getWidth(context)*0.055)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 202, 117,30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:  Icon(Icons.notifications_none_sharp, color: Colors.deepOrange, size: ScreenSize.getWidth(context)*0.065)),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                      height: ScreenSize.getHeight(context)*0.1,
                  ),
                  Text("Hello,\nRaj Verma!", style: TextStyle(fontWeight: FontWeight.w800, fontSize: ScreenSize.getWidth(context)*0.08, height: 1.12)),
                  SizedBox(height: ScreenSize.getHeight(context)*0.04),
                  Text("Today's", style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenSize.getWidth(context)*0.05)),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1: Daily Quizes (full height)
                      Expanded(
                        flex: 46,
                        child: SizedBox(
                          height: ScreenSize.getHeight(context)*0.32,
                          child: InfoCard(
                            color: const Color(0xFFD7E7FB),
                            child: Stack(
                              children: [
                                Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Daily Quizes", style: TextStyle(fontWeight: FontWeight.w800, fontSize: ScreenSize.getWidth(context)*0.085, height: 1.12),),
                                  const SizedBox(height: 6,),
                                  Text("Based on \nPYQ's", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.04, fontWeight: FontWeight.w500)),
                                  SizedBox(height: ScreenSize.getHeight(context)*0.1),
                                  Row(
                                    children: [
                                      Text("Claim daily xp", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.03, fontWeight: FontWeight.w500)),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("+20", style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenSize.getWidth(context)*0.025)),
                                            const SizedBox(width: 2),
                                            Icon(Icons.flash_on, color: Colors.yellow, size: ScreenSize.getWidth(context)*0.035),
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
                                  Text("Live Lectures", style: TextStyle(fontWeight: FontWeight.w800, fontSize: ScreenSize.getWidth(context)*0.065, height: 1.12)),
                                  const SizedBox(height: 5,),
                                  Text("Join Live:", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.03, color: Colors.black)),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Article 370 & Federalism",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenSize.getWidth(context)*0.03),
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
                                  Text("Chapter 4", style: TextStyle(fontWeight: FontWeight.w800, fontSize: ScreenSize.getWidth(context)*0.05)),
                                  Text("Polity - Fundamental rights", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.025, fontWeight: FontWeight.w500)),
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
                                      Text("30% completed", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.025, color: Colors.blueGrey)),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SubjectPage()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Progress Overview", style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenSize.getWidth(context)*0.05)),
                  const SizedBox(height: 10),
                  const WeakTopicCard(
                    pngPath: "assets/images/target.png",
                    topics: [
                      "Economics - Inflation",
                      "History - 1887 Revolt",
                      "Politics - Government",
                    ],
                  ),
                  SizedBox(height: ScreenSize.getHeight(context)*0.1,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}