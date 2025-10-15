import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Components/InfoCard.dart';
import 'package:sankalp/views/Components/ScheduledCard.dart';
import 'package:sankalp/views/Screens/MainScreen.dart';

class InterviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png", // Replace with your actual image path
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 60),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title bar with back and AI icon
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left, size: 32),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MainScreen()),
                                (route) => false,
                          );
                        },
                      ),
                      const Spacer(),
                      const Text("Interview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                      const Spacer(),
                      Image.asset('assets/images/AI_logo.png', height: 24),
                    ],
                  ),
                  const SizedBox(height: 35),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1: AI Mock Interview
                      Expanded(
                        flex: 1,
                        child: InfoCard(
                          color: AppColors.blueColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("AI Mock \nInterview", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26, height: 1.12)),
                                  Spacer(),
                                  Icon(Icons.auto_awesome, color: Colors.blue, size: 28),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text("Start audio \nsession", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.12)),
                              SizedBox(height: ScreenSize.getHeight(context)*0.112),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Column 2: GD Simulator and Interview History stacked
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            InfoCard(
                              color: Color(0xFFE2E2FF),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("GD \nSimulator", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26, height: 1.12)),
                                      Spacer(),
                                      Icon(Icons.auto_awesome, color: Colors.purple, size: 24),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text("Generate topic &\ndiscuss", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.12)),
                                  SizedBox(height: ScreenSize.getHeight(context)*0.02)
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            InfoCard(
                              color: Color(0xFFF8EBB1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Interview & GD \nHistory", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, height: 1.12)),
                                      Icon(Icons.chevron_right, size: 24),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text("Review past sessions", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Live Practice Arena
                  const Text("Live Practice Arena", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  const SizedBox(height: 10),
                  InfoCard(
                    color: const Color(0xFFD3EBFC),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1-1 interview with \nmentor",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 27,
                                height: 1.12,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              "Schedule interview with mentor",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                height: 1.12,
                              ),
                            ),
                            SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Claim daily xp",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  child: Row(
                                    children: [
                                      Text("+20", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      SizedBox(width: 2),
                                      Icon(Icons.flash_on, color: Colors.yellow[700], size: 15),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Red indicator dot
                        Positioned(
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Scheduled Session", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  const SizedBox(height: 10),
                  const ScheduledSessionCard(
                    title: "Interview of Polity",
                    subtitle: "Prof. Mohammad Pasha",
                    timeLeft: "1h:02m",
                    color: Color(0xFFF8EBB1),
                  ),
                  const ScheduledSessionCard(
                    title: "GD - Science & Tech",
                    subtitle: "Prof. Anjali Verma",
                    timeLeft: "2h:15m",
                    color: Color(0xFFE2E2FF),
                  ),
                  const ScheduledSessionCard(
                    title: "Interview of Fundamental Rights",
                    subtitle: "Prof. Vikram Aditya",
                    timeLeft: "4h:15m",
                    color: Color(0xFFC8FFD3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}