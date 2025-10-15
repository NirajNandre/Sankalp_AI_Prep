import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Components/commentCard.dart';
import 'package:sankalp/views/Screens/MainScreen.dart'; // adjust path if needed

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const Text("Connect", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    SizedBox(width: ScreenSize.getWidth(context)*0.05),
                  ],
                ),
                const SizedBox(height: 18),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07), // subtle, soft shadow
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilter("All posts", true),
                      _buildFilter("GS 1", false),
                      _buildFilter("Current Affairs", false),
                      _buildFilter("Optional subjects", false),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                // Comments (scrollable)
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const CommentCard(
                        profileImage: "assets/images/profiles/pic1.jpg",
                        username: "Ankit Sharma",
                        timeAgo: "2h ago",
                        comment: "Gandikota Canyon of South India was created by which river?",
                        likes: 7,
                        comments: 13,
                        tag: "geography",
                        cardColor: Color(0xFFC8FFD3),
                      ),
                      const CommentCard(
                        profileImage: "assets/images/profiles/pic2.jpg",
                        username: "Aditya Raj",
                        timeAgo: "7h ago",
                        comment: "By what percentage did SIDBI’s net profit increase in FY25 compared to FY24?",
                        likes: 7,
                        comments: 13,
                        tag: "Current Affairs",
                        cardColor: Color(0xFFD9D4FF),
                      ),
                      const CommentCard(
                        profileImage: "assets/images/profiles/pic3.jpg",
                        username: "Sachin Gavaskar",
                        timeAgo: "1d ago",
                        comment: "A and B invest in a business in the ratio 3 : 2. If 5% of the total profit goes to charity and A's share is Rs. 855, what's the total profit ?",
                        likes: 270,
                        comments: 256,
                        tag: "Aptitude",
                        cardColor: Color(0xFFD3EBFC),
                      ),
                      const CommentCard(
                        profileImage: "assets/images/profiles/pic4.jpg",
                        username: "Shubhangi Dev",
                        timeAgo: "2d ago",
                        comment: "Which one of the following ancient towns is well known for its elaborate system of water harvesting and management by building a series of dams and channelising water into connected reservoirs?",
                        likes: 7,
                        comments: 13,
                        tag: "History",
                        cardColor: Color(0xFFF8EBB1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating add button
          Positioned(
            right: 20,
            bottom: 30, // adjust to be above your nav bar
            child: FloatingActionButton(
              onPressed: () {
                // Add comment/add post logic here
              },
              backgroundColor: Colors.black87,
              child: const Icon(Icons.add, color: Colors.white, size: 32),
              shape: const CircleBorder(),
              elevation: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? Colors.blue[600] : Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.blue[600]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.blue[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
