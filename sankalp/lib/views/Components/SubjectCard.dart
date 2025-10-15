import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';


class SubjectCard extends StatelessWidget {
  final String name;
  final Color color;
  final double progress; // e.g., 0.3 for 30%
  final VoidCallback onTap;

  const SubjectCard({
    required this.name,
    required this.color,
    required this.progress,
    required this.onTap,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          name,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          maxLines: 1,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.black, size: 28),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(10),
                          value: progress,
                          backgroundColor: Colors.white.withOpacity(0.7),
                          color: Colors.blue,
                          minHeight: 3,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${(progress * 100).round()}% completed",
                        style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
