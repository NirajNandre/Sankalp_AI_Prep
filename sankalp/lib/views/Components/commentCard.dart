import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String profileImage;
  final String username;
  final String timeAgo;
  final String comment;
  final int likes;
  final int comments;
  final String tag;
  final Color cardColor;

  const CommentCard({
    required this.profileImage,
    required this.username,
    required this.timeAgo,
    required this.comment,
    required this.likes,
    required this.comments,
    required this.tag,
    required this.cardColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.05,
                  backgroundImage: AssetImage(profileImage),
                ),
                SizedBox(width: screenWidth * 0.025),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.035)),
                    Text(timeAgo,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: screenWidth * 0.03)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.005),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.03),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              comment,
              style: TextStyle(
                  fontSize: screenWidth * 0.038, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: screenHeight * 0.015),
            Row(
              children: [
                Icon(Icons.favorite_border,
                    color: Colors.black54, size: screenWidth * 0.05),
                SizedBox(width: screenWidth * 0.01),
                Text('$likes', style: const TextStyle(color: Colors.black54)),
                SizedBox(width: screenWidth * 0.04),
                Icon(Icons.comment_outlined,
                    color: Colors.black54, size: screenWidth * 0.05),
                SizedBox(width: screenWidth * 0.01),
                Text('$comments', style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
