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
  final VoidCallback? onTap;
  final Widget? trailing;

  const CommentCard({
    required this.profileImage,
    required this.username,
    required this.timeAgo,
    required this.comment,
    required this.likes,
    required this.comments,
    required this.tag,
    required this.cardColor,
    this.onTap,
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 17,
                  backgroundImage: AssetImage(profileImage),
                ),
                SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ],
                ),
                Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
            SizedBox(height: 10),
            Text(
              comment,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 18),
                SizedBox(width: 4),
                Text('$likes', style: TextStyle(fontSize: 14)),
                SizedBox(width: 16),
                Icon(Icons.comment, color: Colors.black54, size: 18),
                SizedBox(width: 4),
                Text('$comments', style: TextStyle(fontSize: 14)),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(fontSize: 11, color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
