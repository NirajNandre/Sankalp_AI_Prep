import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';

class AiDiscussionPage extends StatefulWidget {
  const AiDiscussionPage({Key? key}) : super(key: key);

  @override
  State<AiDiscussionPage> createState() => _AiDiscussionPageState();
}

class _AiDiscussionPageState extends State<AiDiscussionPage> {
  bool isListening = false;

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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title bar
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 32),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "AI Discussion",
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
                  SizedBox(height: ScreenSize.getHeight(context) * 0.05),
                  // Discussion AI cards
                  Row(
                    children: [
                      // Max
                      Expanded(
                        child: Container(
                          height: ScreenSize.getHeight(context) * 0.35,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB2F3FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.13),
                              width: 1.1,
                            ),
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
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/images/AI_logo.png',
                                    height: 32,
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, top: 14),
                                  child: Text(
                                    "Max",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 26,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Alen
                      Expanded(
                        child: Container(
                          height: ScreenSize.getHeight(context) * 0.35,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6D4FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.13),
                              width: 1.1,
                            ),
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
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/images/AI_logo.png',
                                    height: 32,
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, top: 14),
                                  child: Text(
                                    "Alen",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 26,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // User Container
                  Container(
                    height: ScreenSize.getHeight(context) * 0.3,
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
                            fontSize: 32,
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
                  // End Button
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
                          fontSize: 20,
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
