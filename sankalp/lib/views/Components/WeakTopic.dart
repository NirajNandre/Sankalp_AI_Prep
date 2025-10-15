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
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Color(0xFFD5DBF6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weak Topics", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32, height: 1)),
                SizedBox(height: 15),
                ...topics.map((t) => Text(t, style: TextStyle(fontSize: 12))),
                Text("show more", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, height: 1.5, fontSize: 12)),
                SizedBox(height: 5),
              ],
            ),
          ),
          Positioned(
            right: -10,
            bottom: 10,
            child: Image.asset(
              pngPath,
              width: 180,
              height: 180,
              fit: BoxFit.contain, // Uses the full image
            ),
          ),
        ],
      ),
    );
  }
}
