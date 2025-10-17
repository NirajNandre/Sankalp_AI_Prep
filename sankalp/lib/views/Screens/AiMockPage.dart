import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';

class AiInterviewPage extends StatefulWidget {
  final String greeting;
  final String sessionId;
  final String userId;

  const AiInterviewPage({
    Key? key,
    required this.greeting,
    required this.sessionId,
    required this.userId,
  }) : super(key: key);

  @override
  State<AiInterviewPage> createState() => _AiInterviewPageState();
}

class _AiInterviewPageState extends State<AiInterviewPage> {
  late FlutterTts _flutterTts;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isAiSpeaking = false;
  String _aiResponse = "";
  String _userTranscript = "Tap the mic to speak...";
  late String _userId;
  late String _sessionId;

  final String _baseUrl = "http://10.0.2.2:8000";

  @override
  void initState() {
    super.initState();
    _aiResponse = widget.greeting;
    _sessionId = widget.sessionId;
    _userId = widget.userId;
    _initialize();
  }

  Future<void> _initialize() async {
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() => setState(() => _isAiSpeaking = true));
    _flutterTts.setCompletionHandler(() => setState(() => _isAiSpeaking = false));
    _flutterTts.setErrorHandler((msg) => setState(() => _isAiSpeaking = false));

    await _speech.initialize(
      onError: (error) => print("STT Error: $error"),
      onStatus: (status) => print("STT Status: $status"),
    );

    _speak(_aiResponse);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _userTranscript = "";
        });
        _speech.listen(
          listenFor: const Duration(minutes: 2),
          pauseFor: const Duration(seconds: 5),
          onResult: (result) => setState(() {
            _userTranscript = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_userTranscript.isNotEmpty) {
        _sendChatMessage(_userTranscript);
      }
    }
  }

  Future<void> _sendChatMessage(String text) async {
    setState(() {
      _aiResponse = "Thinking...";
    });

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/interview/chat"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_input": text,
          "user_id": _userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _aiResponse = data['response'];
        });
        _speak(_aiResponse);
      } else {
        setState(() {
          _aiResponse = "Error: Something went wrong.";
        });
      }
    } catch (e) {
      setState(() {
        _aiResponse = "Error: Could not connect to the server.";
      });
    }
  }

  Future<void> _clearSession() async {
    if (_userId.isNotEmpty) {
      try {
        await http.delete(Uri.parse("$_baseUrl/interview/session/$_userId"));
      } catch (e) {
        print("Error clearing session: $e");
      }
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speech.cancel();
    super.dispose();
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: ScreenSize.getHeight(context) * 0.35,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB2F3FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.13), width: 1.1),
                      boxShadow: _isAiSpeaking
                          ? [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.7),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                          : [],
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Image.asset('assets/images/AI_logo.png', height: 50),
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "AI \nInterviewer",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              color: Colors.black,
                              height: 1.12,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SingleChildScrollView(
                            child: Text(
                              _aiResponse,
                              style: const TextStyle(
                                fontSize: 16,
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: ScreenSize.getHeight(context) * 0.35,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9C8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.13), width: 1.1),
                      boxShadow: _isListening
                          ? [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.7),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                          : [],
                    ),
                    // Using a Stack to position the microphone button
                    child: Stack(
                      children: [
                        Column(
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
                            const SizedBox(height: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  _userTranscript,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Aligning the IconButton to the bottom right
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(
                              _isListening ? Icons.mic : Icons.mic_off,
                              size: 44,
                              color: _isListening ? Colors.deepOrange : const Color(0xFF2C2C2C),
                            ),
                            onPressed: _listen,
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
                        _clearSession();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB2B2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text(
                        "End",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
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
    );
  }
}
