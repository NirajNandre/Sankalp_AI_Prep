import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';

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
        margin: EdgeInsets.only(bottom: ScreenSize.getHeight(context)*0.01),
        padding: EdgeInsets.all(ScreenSize.getWidth(context)*0.04),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: ScreenSize.getWidth(context)*0.055,
              height: 1.12,
            ),),
            SizedBox(height: ScreenSize.getHeight(context)*0.007),
            Text(subtitle, style: TextStyle(
              fontSize: ScreenSize.getWidth(context)*0.03,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.12,
            ),),
            SizedBox(height: ScreenSize.getHeight(context)*0.05),
            Text("In $timeLeft", style: TextStyle(
              fontSize: ScreenSize.getWidth(context)*0.04,
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
