import 'package:flutter/material.dart';
import 'package:sankalp/views/Screens/CommunityScreen.dart';
import 'package:sankalp/views/Screens/HomeScreen.dart';
import 'package:sankalp/views/Screens/InterviewScreen.dart';
import 'package:sankalp/views/Screens/MainScreen.dart';
import 'package:sankalp/views/Screens/ProfileScreen.dart';
import 'package:sankalp/views/Screens/StudyPage.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => MainScreen(),
  '/main': (context) => MainScreen(),
  '/homepage': (context) => HomePage(),
  '/community': (context) => CommunityPage(),
  '/study': (context) => StudyPage(),
  '/profile': (context) => ProfilePage(),
  '/interview' : (context) => InterviewPage(),
  // Add other routes here
};
