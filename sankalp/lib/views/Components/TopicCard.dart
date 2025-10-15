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
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: model.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        model.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      splashRadius: 22,
                      padding: EdgeInsets.only(top: 0, right: 0), // tight padding
                      constraints: BoxConstraints(),
                      icon: Icon(
                        model.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: model.isFavorite ? Colors.red : Colors.grey[500],
                        size: 27,
                      ),
                      onPressed: onFavTap,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(model.time, style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w400)),
                SizedBox(height: ScreenSize.getHeight(context)*0.03),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: model.completed / 100,
                              color: Color(0xFF27A5FA),
                              strokeWidth: 4,
                            ),
                            Text(
                              "${model.completed}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 3),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        "completed",
                        style: TextStyle(fontSize: 10, color: Colors.black87),
                      ),
                    ),
                    Spacer(),
                    // Flash container re-used
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        children: [
                          Text("+${model.flash}", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 2),
                          Icon(Icons.flash_on, color: Colors.yellow[700], size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}