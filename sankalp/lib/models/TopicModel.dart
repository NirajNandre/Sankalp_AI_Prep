import 'package:flutter/material.dart';

class TopicModel {
  String name;
  String time;
  int completed;
  int flash;
  Color color;
  bool isFavorite;
  TopicModel({
    required this.name,
    required this.time,
    required this.completed,
    required this.flash,
    required this.color,
    this.isFavorite = false,
  });
}