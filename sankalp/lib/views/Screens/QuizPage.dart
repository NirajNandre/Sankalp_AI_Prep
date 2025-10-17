import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sankalp/utils/constants.dart';
import 'package:http/http.dart' as http;

class QuizPage extends StatefulWidget {
  final String topic;
  const QuizPage({super.key, required this.topic});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> _questions = [];
  List<bool> _answersCorrect = [];
  int _currentQuestionIndex = 0;
  int _remainingSeconds = 20;
  Timer? _timer;
  int? _selectedOptionIndex;
  bool _submitted = false;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    // Use '10.0.2.2' for Android emulator or your computer's IP for a physical device.
    const String baseUrl =
        'https://ai-core-backend-180048661835.us-central1.run.app';
    final Uri url = Uri.parse('$baseUrl/generate-quiz/');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            // Use the topic passed to the widget
            body: json.encode({'topic': widget.topic}),
          )
          .timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(
          utf8.decode(response.bodyBytes),
        );
        setState(() {
          _questions = jsonData.map((q) => Question.fromJson(q)).toList();
          _isLoading = false;
        });
        _startTimer();
      } else {
        setState(() {
          _error = 'Failed to load quiz. Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error =
            'Failed to connect to the server. Please check your network and make sure the backend is running.';
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    _remainingSeconds = 20;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        _goToNext();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _goToNext() {
    _timer?.cancel();
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _submitted = false;
      });
      _startTimer();
    } else {
      final correct = _answersCorrect.where((c) => c).length;
      final incorrect = _answersCorrect.length - correct;
      // Submit action
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Center(
            child: Text(
              'Quiz Submitted',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      "Correct - $correct",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Incorrect - $incorrect",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Thanks for completing the quiz!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _selectOption(int idx) {
    if (_submitted) return;
    setState(() {
      _selectedOptionIndex = idx;
      _submitted = true;
      _answersCorrect.add(
        _questions[_currentQuestionIndex].options[idx].isCorrect,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Generating your quiz...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      // UI to show when an error occurs
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];
    final total = _questions.length;
    final isLast = _currentQuestionIndex == total - 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 64, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 32),
                      onPressed: () {
                        // Standard practice: pop the current route to go back
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      "Quiz",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "Topic : ${widget.topic}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Question ${_currentQuestionIndex + 1} out of $total",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.blueAccent),
                          const SizedBox(width: 6),
                          Text(
                            "$_remainingSeconds s",
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blueColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black, width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            question.question,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(question.options.length, (index) {
                          final option = question.options[index];
                          final isSelected = _selectedOptionIndex == index;
                          final isAnswered = _submitted;

                          Color bgColor() {
                            if (!isAnswered) return Colors.white;
                            if (isSelected)
                              return option.isCorrect
                                  ? Colors.green[100]!
                                  : Colors.red[100]!;
                            if (option.isCorrect)
                              return Colors.green.withOpacity(0.08);
                            return Colors.white;
                          }

                          Color borderColor() {
                            if (isSelected)
                              return option.isCorrect
                                  ? Colors.green
                                  : Colors.red;
                            if (isAnswered && option.isCorrect)
                              return Colors.green;
                            return Colors.grey.shade400;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectOption(index),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: bgColor(),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: borderColor(),
                                          width: 2.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        option.text,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        if (_submitted && _selectedOptionIndex != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 1.3,
                              ),
                            ),
                            child: Text(
                              _questions[_currentQuestionIndex]
                                  .options[_selectedOptionIndex!]
                                  .reason,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        SizedBox(height: ScreenSize.getHeight(context) * 0.02),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.06,
                          // Or ScreenSize.getHeight(context)*0.06
                          margin: const EdgeInsets.only(top: 2, bottom: 0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: TextButton(
                            onPressed:
                                _selectedOptionIndex == null && !_submitted
                                ? null
                                : _goToNext,
                            child: Text(
                              isLast ? "Submit" : "Next",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                letterSpacing: 0.2,
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
          ),
        ],
      ),
    );
  }
}

class Question {
  final String question;
  final List<Option> options;

  Question({required this.question, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['options'] as List<dynamic>;
    return Question(
      question: json['question'] as String,
      options: optionsJson
          .map((opt) => Option.fromJson(opt as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Option {
  final String text;
  final bool isCorrect;
  final String reason;

  Option({required this.text, required this.isCorrect, required this.reason});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool,
      reason: json['reason'] as String,
    );
  }
}
