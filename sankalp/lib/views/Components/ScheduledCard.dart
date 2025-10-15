import 'package:flutter/material.dart';

class ScheduledSessionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeLeft;
  final Color color;
  final VoidCallback? onTap;

  const ScheduledSessionCard({
    required this.title,
    required this.subtitle,
    required this.timeLeft,
    required this.color,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              height: 1.12,
            ),),
            SizedBox(height: 6),
            Text(subtitle, style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.12,
            ),),
            SizedBox(height: 50),
            Text("In $timeLeft", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            ),
          ],
        ),
      ),
    );
  }
}
