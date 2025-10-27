import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';

class WeakTopicCard extends StatelessWidget {
  final List<String> topics;
  final String pngPath;
  final VoidCallback? onTap;

  const WeakTopicCard({
    required this.pngPath,
    required this.topics,
    this.onTap,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: ScreenSize.getHeight(context)*0.18,
            padding: EdgeInsets.all(ScreenSize.getWidth(context)*0.045),
            decoration: BoxDecoration(
              color: const Color(0xFFD5DBF6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weak Topics", style: TextStyle(fontWeight: FontWeight.w800, fontSize: ScreenSize.getWidth(context)*0.07, height: 1)),
                SizedBox(height: ScreenSize.getHeight(context)*0.015),
                ...topics.map((t) => Text(t, style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.03))),
                Text("show more", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, height: 1.5, fontSize: ScreenSize.getWidth(context)*0.03)),
                SizedBox(height: ScreenSize.getHeight(context)*0.005),
              ],
            ),
          ),
          Positioned(
            right: -ScreenSize.getWidth(context)*0.001,
            bottom: -ScreenSize.getHeight(context)*0.15,
            child: Image.asset(
              pngPath,
              width: ScreenSize.getWidth(context)*0.4,
              height: ScreenSize.getHeight(context)*0.5,
              fit: BoxFit.contain, // Uses the full image
            ),
          ),
        ],
      ),
    );
  }
}
