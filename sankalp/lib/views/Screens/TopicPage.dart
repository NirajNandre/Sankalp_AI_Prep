import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Screens/PdfView.dart';
import 'package:sankalp/views/Screens/QuizPage.dart';
import 'package:sankalp/views/Screens/RevisionNotesPage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TopicPage extends StatefulWidget {
  final String title;
  final String aboutText;
  final String youtubeUrl;

  const TopicPage({
    super.key,
    required this.title,
    required this.aboutText,
    required this.youtubeUrl,
  });

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  late YoutubePlayerController _controller;
  bool aboutExpanded = false;
  bool _isGeneratingNotes = false;



  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget aboutSection(String text) {
    final maxLines = aboutExpanded ? null : 4;
    final showToggle = text.split('\n').length > 4 || text.length > 200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: maxLines,
          overflow: aboutExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
        if (showToggle)
          GestureDetector(
            onTap: () => setState(() => aboutExpanded = !aboutExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                aboutExpanded ? "show less" : "show more",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _generateAiNotes() async {
    setState(() {
      _isGeneratingNotes = true;
    });

    // Show a loading dialog so the user knows something is happening
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppColors.blueColor,
            ),
          ],
        ),
      ),
    );

    try {
      // 1. Set up the request to your new endpoint
      // Use port 8001 for the notes generator
      final url = Uri.parse('http://10.0.2.2:8001/generate-notes-from-pdf/');
      var request = http.MultipartRequest('POST', url);

      // 2. Add the 'topic' as a form field
      request.fields['topic'] = widget.title;

      // 3. Load the PDF file from assets and add it to the request
      final byteData = await rootBundle.load('assets/pdfs/fundamental-rights.pdf');
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        byteData.buffer.asUint8List(),
        filename: 'fundamental-rights.pdf', // The filename is required
      ));

      // 4. Send the request and wait for the response
      final streamedResponse = await request.send().timeout(const Duration(seconds: 90));
      final response = await http.Response.fromStream(streamedResponse);

      // Close the loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        // On success, navigate to the RevisionNotesPage with the data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RevisionNotesPage(
              topic: data['topic'],
              notes: data['notes'],
              date: data['date'],
            ),
          ),
        );
      } else {
        // If the server returns an error, show it in a SnackBar
        final errorData = json.decode(response.body);
        throw Exception('Failed to generate notes: ${errorData['detail']}');
      }
    } catch (e) {
      // Close the loading dialog if it's still open
      if(Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      // Show any other errors (like network issues)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      // Re-enable the button
      setState(() {
        _isGeneratingNotes = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 0,
            ),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text("Topic", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                    SizedBox(width: ScreenSize.getWidth(context)*0.05),
                  ],
                ),
                SizedBox(height: ScreenSize.getHeight(context)*0.05),
                // Youtube Player
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 18),
                // Title and progress indicator
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  color: Colors.black)),
                          const Text(
                            'Prof. Mohammad Pasha',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "20%",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Text('remaining', style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: ScreenSize.getHeight(context)*0.03),
                const Text(
                  'About',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
                ),
                aboutSection(widget.aboutText),
                const SizedBox(height: 18),
                // Four Grid Buttons
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.6,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        elevation: 1,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // The Expanded ensures the text column uses all available space
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Ask AI",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: Colors.black,
                                    height: 1.05,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "clear doubts by AI",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: Colors.black,
                                    height: 1.05,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Some space between text and image
                          const SizedBox(width: 2),
                          Image.asset("assets/images/AI_logo.png", height: 50),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE1F7FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        elevation: 1,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {},
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Ask Mentor a \ndoubt",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.black,
                              height: 1.05,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Clear doubt by mentor",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Colors.black,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE1F7FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        elevation: 1,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PdfViewerPage(assetPath: "assets/pdfs/fundamental-rights.pdf"),
                          ),
                        );
                      },
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Lecture \nResources",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.black,
                              height: 1.05,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Tap to get lecture notes",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Colors.black,
                              height: 1.05,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEADBFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        elevation: 1,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QuizPage(topic: widget.title)),
                        );
                      },
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Try Quiz",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.black,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Try topicwise quiz by AI",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.black,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenSize.getHeight(context)*0.03),
                // AI Notes Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  icon: Image.asset("assets/images/AI_logo.png", height: 22),
                  onPressed: _isGeneratingNotes ? null : _generateAiNotes,
                  label: _isGeneratingNotes
                      ? const Text("Generating...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                      : const Text("Get AI Generated Notes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(height: 65),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
