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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // Content with fixed header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed Title Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Revision Notes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 48), // for symmetry
                  ],
                ),

                const SizedBox(height: 18),

                // Scrollable Note Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 40),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Topic Title
                            Text(
                              topic,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 26,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Date
                            Text(
                              "Generated on: $date",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const Divider(height: 30, thickness: 1, color: Colors.black12),

                            // Markdown Notes
                            MarkdownBody(
                              data: notes,
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                                h1: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                                h2: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                listBullet: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
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
          ),
        ],
      ),
    );
  }
}
