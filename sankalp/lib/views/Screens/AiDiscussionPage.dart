import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';

class AiDiscussionPage extends StatefulWidget {
  AiDiscussionPage({Key? key}) : super(key: key);

  @override
  State<AiDiscussionPage> createState() => _AiDiscussionPageState();
}

class _AiDiscussionPageState extends State<AiDiscussionPage> {
  bool isListening = false;
  bool _isEndingSession = false;

  Future<void> _clearSession() async {
    // if (_userId.isNotEmpty) {
    //   try {
    //     await http.delete(Uri.parse("$_baseUrl/interview/session/$_userId"));
    //   } catch (e) {
    //     print("Error clearing session: $e");
    //   }
    // }
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
              "assets/images/background.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:ScreenSize.getWidth(context)*0.04,
                  vertical: ScreenSize.getHeight(context)*0.015
              ),
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
                      Expanded(
                        child: Center(
                          child: Text(
                            "AI Discussion",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: ScreenSize.getWidth(context)*0.065,
                              color: Colors.black,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ScreenSize.getWidth(context)*0.12),
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
                                    height: ScreenSize.getHeight(context)*0.035,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 14),
                                  child: Text(
                                    "Max",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: ScreenSize.getWidth(context)*0.05,
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
                                    height: ScreenSize.getHeight(context)*0.035,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 14),
                                  child: Text(
                                    "Alen",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: ScreenSize.getWidth(context)*0.05,
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
                  SizedBox(height: ScreenSize.getHeight(context)*0.025),
                  // User Container
                  Container(
                    height: ScreenSize.getHeight(context) * 0.3,
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.getWidth(context)*0.04,
                        vertical: ScreenSize.getHeight(context)*0.015),
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
                        Text(
                          "You",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: ScreenSize.getWidth(context)*0.05,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: IconButton(
                            icon: Icon(
                              isListening ? Icons.mic : Icons.mic_off,
                              size: ScreenSize.getWidth(context)*0.1,
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
                    height: ScreenSize.getHeight(context) * 0.06,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isEndingSession
                          ? null
                          : () async {
                        setState(() => _isEndingSession = true);
                        await _clearSession();
                        // Short delay to let the user see the loader
                        await Future.delayed(
                            const Duration(milliseconds: 500));
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB2B2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: _isEndingSession
                          ? Center(
                        child: SizedBox(
                          height: ScreenSize.getHeight(context) *
                              0.02, // Control size with height
                          child: const AspectRatio(
                            aspectRatio: 1.0, // Force a square
                            child: CircularProgressIndicator(
                              color: Colors.black87,
                              strokeWidth: 3.5,
                            ),
                          ),
                        ),
                      )
                          : Text(
                        "End",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w800,
                          fontSize: ScreenSize.getWidth(context) * 0.048,
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
