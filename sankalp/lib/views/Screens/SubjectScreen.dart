import 'package:flutter/material.dart';
import 'package:sankalp/models/TopicModel.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Components/TopicCard.dart';
import 'package:sankalp/views/Screens/TopicPage.dart';

class SubjectPage extends StatefulWidget {
  // You can pass data like subjectName, topics, etc through this constructor
  SubjectPage({super.key});
  @override
  State<SubjectPage> createState() => _SubjectPageState();

}

class _SubjectPageState extends State<SubjectPage> {
  // Dummy Data
  List<TopicModel> topics = [
    TopicModel(
      name: "Fundamental Rights",
      time: "1h 20m",
      completed: 80,
      flash: 3,
      color: const Color(0xFFD8F2FF),
      isFavorite: true,
    ),
    TopicModel(
      name: "State Executive & Legislature",
      time: "51m",
      completed: 20,
      flash: 3,
      color: const Color(0xFFE2DEF9),
      isFavorite: false,
    ),
    TopicModel(
      name: "Constitution of India",
      time: "1h 40m",
      completed: 10,
      flash: 3,
      color: const Color(0xFFD8FFD7),
      isFavorite: false,
    ),
    TopicModel(
      name: "Judiciary",
      time: "2h 51m",
      completed: 50,
      flash: 3,
      color: const Color(0xFFFFFFD3),
      isFavorite: false,
    ),
    TopicModel(
      name: "Federalism",
      time: "1h 20m",
      completed: 80,
      flash: 3,
      color: const Color(0xFFD8F2FF),
      isFavorite: true,
    ),
    TopicModel(
      name: "Governance",
      time: "30m",
      completed: 20,
      flash: 3,
      color: const Color(0xFFE2DEF9),
      isFavorite: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image as in other pages
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.getWidth(context) * 0.035),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar with back and title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                            child: Text(
                              "Subject",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: ScreenSize.getWidth(context) * 0.065,
                                color: Colors.black,
                                letterSpacing: 0.3,
                              ),
                            )
                        ),
                      ),
                      SizedBox(width: ScreenSize.getWidth(context)*0.1)
                    ],
                  ),
                  SizedBox(height: ScreenSize.getHeight(context) * 0.02),
                  // Top info card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8F2FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(ScreenSize.getWidth(context) * 0.045),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Polity",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenSize.getWidth(context) * 0.07,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: ScreenSize.getHeight(context) * 0.002),
                                    Text(
                                      "by Prof. Mohammad Pasha",
                                      style: TextStyle(fontSize: ScreenSize.getWidth(context) * 0.035, color: Colors.black87, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: ScreenSize.getHeight(context) * 0.015),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "28",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenSize.getWidth(context) * 0.1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10, left: 4),
                                          child: Text(
                                            "hours spent",
                                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: ScreenSize.getWidth(context) * 0.04),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: ScreenSize.getHeight(context) * 0.01),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: 0.3,
                                            backgroundColor: Colors.white,
                                            color: const Color(0xFF27A5FA),
                                            minHeight: 4,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        SizedBox(width: ScreenSize.getWidth(context) * 0.02),
                                        Text("30% completed", style: TextStyle(fontSize: ScreenSize.getWidth(context) * 0.025,color: Colors.black54)),
                                        SizedBox(width: ScreenSize.getWidth(context) * 0.15),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: IconButton(
                                            visualDensity: VisualDensity.compact,
                                            icon: const Icon(Icons.download_rounded, color: Colors.black87, size: 24),
                                            onPressed: () {
                                              // Download logic
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Notification dot
                        Positioned(
                          top: 15,
                          right: 14,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenSize.getHeight(context) * 0.025),
                  Text(
                    "Topics",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenSize.getWidth(context) * 0.05, color: Colors.black),
                  ),
                  SizedBox(height: ScreenSize.getWidth(context) * 0.05),
                  // GridView of topic cards (scrollable only this part)
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 11,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.95,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        for (int i = 0; i < topics.length; i++)
                          TopicCard(
                            model: topics[i],
                            onFavTap: () {
                              setState(() => topics[i].isFavorite = !topics[i].isFavorite);
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TopicPage(
                                    title: topics[i].name,
                                    aboutText: "The fundamental rights are six categories of basic freedoms guaranteed to Indian citizens by the Constitution, ensuring their development and dignity. These include the Right to Equality, Right to Freedom, Right against Exploitation, Right to Freedom of Religion, Cultural and Educational Rights, and the Right to Constitutional Remedies. These rights are enforceable in the Supreme Court and High Courts, which act as guardians of these fundamental liberties.",
                                    youtubeUrl: "https://www.youtube.com/watch?v=zbAPxvTuDUg",
                                  ),
                                ),
                              );
                            },
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}