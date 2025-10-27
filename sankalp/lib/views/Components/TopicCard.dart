import 'package:flutter/material.dart';
import 'package:sankalp/models/TopicModel.dart';
import 'package:sankalp/utils/constants.dart';

class TopicCard extends StatelessWidget {
  final TopicModel model;
  final VoidCallback onFavTap;
  final VoidCallback onTap;
  const TopicCard({required this.model, required this.onFavTap, super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ScreenSize.getWidth(context)*0.03),
        decoration: BoxDecoration(
          color: model.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenSize.getWidth(context) * 0.045, // ~18 on a 400dp screen
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: ScreenSize.getWidth(context) * 0.01),
                // Using a GestureDetector for a smaller tap area if needed
                GestureDetector(
                  onTap: onFavTap,
                  child: Icon(
                    model.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: model.isFavorite ? Colors.red : Colors.grey[500],
                    size: ScreenSize.getWidth(context) * 0.065, // ~26 on a 400dp screen
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenSize.getHeight(context) * 0.005),
            Text(model.time, style: TextStyle(fontSize: ScreenSize.getWidth(context) * 0.038, color: Colors.black87, fontWeight: FontWeight.w400)),
            const Spacer(),
            Row(
              children: [
                CircleAvatar(
                  radius: ScreenSize.getWidth(context) * 0.04,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: model.completed / 100,
                          color: const Color(0xFF27A5FA),
                          strokeWidth: 4,
                        ),
                        Text(
                          "${model.completed}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenSize.getWidth(context) * 0.028,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: ScreenSize.getWidth(context) * 0.015),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "completed",
                    style: TextStyle(fontSize: ScreenSize.getWidth(context) * 0.025, color: Colors.black87),
                  ),
                ),
                const Spacer(),
                // Flash container re-used
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      Text("+${model.flash}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 2),
                      Icon(Icons.flash_on, color: Colors.yellow[700], size: 16),
                    ],
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