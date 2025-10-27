import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Components/InfoCard.dart';
import 'package:sankalp/views/Components/ScheduledCard.dart';
import 'package:sankalp/views/Screens/AiDiscussionPage.dart';
import 'package:sankalp/views/Screens/AiMockPage.dart';
import 'package:sankalp/views/Screens/MainScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';

class InterviewPage extends StatefulWidget {
  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  bool _isLoading = false;

  final String _baseUrl =
      "https://ai-core-backend-180048661835.us-central1.run.app";

  // Function to start the AI Interview
  Future<void> _startAiInterview() async {
    setState(() => _isLoading = true);

    final userId = const Uuid().v4();

    try {
      // The "headers" parameter has been removed from this GET request
      final response = await http
          .get(Uri.parse("$_baseUrl/interview/greeting/$userId"))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AiInterviewPage(
              greeting: data['greeting'],
              sessionId: data['session_id'],
              userId: userId,
            ),
          ),
        );
      } else {
        _showErrorDialog("Failed to start interview. Please try again.");
      }
    } catch (e) {
      _showErrorDialog(
        "Could not connect to the server. Please check your connection.",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'An Error Occurred!',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

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
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.getWidth(context)*0.035),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title bar with back and AI icon
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 32),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                        const Spacer(),
                        Text(
                          "Interview",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenSize.getWidth(context)*0.065,
                          ),
                        ),
                        const Spacer(),
                        Image.asset('assets/images/AI_logo.png', height: ScreenSize.getHeight(context)*0.03),
                      ],
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.03),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Column 1: AI Mock Interview
                        Expanded(
                          flex: 1,
                          child: InfoCard(
                            onTap: _isLoading ? null : _startAiInterview,
                            color: AppColors.blueColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "AI Mock \nInterview",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: ScreenSize.getWidth(context)*0.06,
                                        height: 1.12,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.auto_awesome,
                                      color: Colors.blue,
                                      size: ScreenSize.getWidth(context)*0.07,
                                    ),
                                  ],
                                ),
                                SizedBox(height: ScreenSize.getHeight(context)*0.01),
                                Text(
                                  "Start audio \nsession",
                                  style: TextStyle(
                                    fontSize: ScreenSize.getWidth(context)*0.032,
                                    fontWeight: FontWeight.w500,
                                    height: 1.12,
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenSize.getHeight(context) * 0.125,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: ScreenSize.getWidth(context)*0.025),
                        // Column 2: GD Simulator and Interview History stacked
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              InfoCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AiDiscussionPage(),
                                    ),
                                  );
                                },
                                color: const Color(0xFFE2E2FF),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "GD \nSimulator",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: ScreenSize.getWidth(context)*0.06,
                                            height: 1.12,
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.auto_awesome,
                                          color: Colors.purple,
                                          size: ScreenSize.getWidth(context)*0.06,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: ScreenSize.getHeight(context)*0.005),
                                    Text(
                                      "Generate topic &\ndiscuss",
                                      style: TextStyle(
                                        fontSize: ScreenSize.getWidth(context)*0.03,
                                        fontWeight: FontWeight.w500,
                                        height: 1.12,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          ScreenSize.getHeight(context) * 0.02,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: ScreenSize.getHeight(context)*0.012),
                              InfoCard(
                                color: const Color(0xFFF8EBB1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Interview & GD \nHistory",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: ScreenSize.getWidth(context)*0.038,
                                            height: 1.12,
                                          ),
                                        ),
                                        Icon(Icons.chevron_right, size: ScreenSize.getWidth(context)*0.06),
                                      ],
                                    ),
                                    SizedBox(height: ScreenSize.getHeight(context)*0.01),
                                    Text(
                                      "Review past sessions",
                                      style: TextStyle(
                                        fontSize: ScreenSize.getWidth(context)*0.03,
                                        fontWeight: FontWeight.w500,
                                        height: 1.12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.02),
            
                    // Live Practice Arena
                    Text(
                      "Live Practice Arena",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenSize.getWidth(context)*0.045),
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.01),
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
                                  fontSize: ScreenSize.getWidth(context)*0.06,
                                  height: 1.12,
                                ),
                              ),
                              SizedBox(height: ScreenSize.getHeight(context)*0.01),
                              Text(
                                "Schedule interview with mentor",
                                style: TextStyle(
                                  fontSize: ScreenSize.getWidth(context)*0.04,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  height: 1.12,
                                ),
                              ),
                              SizedBox(height: ScreenSize.getHeight(context)*0.06),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Claim daily xp",
                                    style: TextStyle(
                                      fontSize: ScreenSize.getWidth(context)*0.035,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenSize.getWidth(context)*0.02,
                                      vertical: ScreenSize.getHeight(context)*0.005,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "+20",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenSize.getWidth(context)*0.038,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Icon(
                                          Icons.flash_on,
                                          color: Colors.yellow[700],
                                          size: ScreenSize.getWidth(context)*0.04,
                                        ),
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
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.02),
                    Text(
                      "Scheduled Session",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenSize.getWidth(context)*0.045),
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.01),
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
          ),
        ],
      ),
    );
  }
}
