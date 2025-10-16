import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';

class AiInterviewPage extends StatefulWidget {
  const AiInterviewPage({Key? key}) : super(key: key);

  @override
  State<AiInterviewPage> createState() => _AiInterviewPageState();
}

class _AiInterviewPageState extends State<AiInterviewPage> {
  bool isListening = false;

  @override
  Widget build(BuildContext context) {
    final bgImage = "assets/images/background.png";

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
              )
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title bar mimic
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 32),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Interview",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                              color: Colors.black,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // AI Interviewer Container
                  Container(
                    height: ScreenSize.getHeight(context)*0.35,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB2F3FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.13), width: 1.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/images/AI_logo.png',
                            height: 50,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "AI \nInterviewer",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              color: Colors.black,
                              height: 1.12
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 28),
                            child: Text(
                              "",
                              // Leave empty since this is voice-only
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // User Container
                  Container(
                    height: ScreenSize.getHeight(context)*0.35,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9C8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.13), width: 1.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "You",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: IconButton(
                            icon: Icon(
                              isListening ? Icons.mic : Icons.mic_off,
                              size: 44,
                              color: isListening
                                  ? Colors.deepOrange
                                  : const Color(0xFF2C2C2C),
                            ),
                            onPressed: () {
                              setState(() => isListening = !isListening);
                            },
                            tooltip: "Tap to speak",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // End Button (full width, styled like app logout/submit)
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB2B2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        elevation: 0.7,
                        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
                      ),
                      child: const Text(
                        "End",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
