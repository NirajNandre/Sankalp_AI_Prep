import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class RevisionNotesPage extends StatelessWidget {
  final String topic;
  final String notes;
  final String date;

  const RevisionNotesPage({
    super.key,
    required this.topic,
    required this.notes,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive Markdown Style Sheet
    final markdownStyleSheet = MarkdownStyleSheet(
      p: TextStyle(
        fontSize: screenWidth * 0.035, // Responsive paragraph font size
        color: Colors.black87,
        height: 1.5,
      ),
      h1: TextStyle(
        fontSize: screenWidth * 0.055, // Responsive H1 font size
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
      h2: TextStyle(
        fontSize: screenWidth * 0.045, // Responsive H2 font size
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
      listBullet: TextStyle(
        fontSize: screenWidth * 0.04, // Responsive list font size
        color: Colors.black87,
      ),
      strong: const TextStyle(
        fontWeight: FontWeight.w800,
      ),
    );

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
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Revision Notes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.065),
                      ),
                      SizedBox(
                          width:
                          screenWidth * 0.12), // Balance the back button
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Topic and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          topic,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.05),
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.035),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Notes container
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Markdown( // Changed from ListView to Markdown
                        data: notes,
                        padding: EdgeInsets.zero,
                        styleSheet: markdownStyleSheet, // Using the responsive stylesheet
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: screenHeight * 0.06,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: SizedBox(
                          height: screenHeight * 0.06,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              "Download",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}



