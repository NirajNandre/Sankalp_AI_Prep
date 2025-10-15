import 'package:flutter/material.dart';
import 'package:sankalp/models/TopicModel.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Components/TopicCard.dart';
import 'package:sankalp/views/Screens/TopicPage.dart';

class SubjectPage extends StatefulWidget {
  // You can pass data like subjectName, topics, etc through this constructor
  const SubjectPage({super.key});
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
              padding: const EdgeInsets.symmetric(horizontal: 14),
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
                      const Expanded(
                        child: Center(
                            child: Text(
                              "Subject",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 26,
                                color: Colors.black,
                                letterSpacing: 0.3,
                              ),
                            )
                        ),
                      ),
                      SizedBox(width: ScreenSize.getWidth(context)*0.05,)
                    ],
                  ),
                  const SizedBox(height: 24),
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
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Polity",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      "by Prof. Mohammad Pasha",
                                      style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 13),
                                    const Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "28",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10, left: 4),
                                          child: Text(
                                            "hours spent",
                                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
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
                                        const SizedBox(width: 8),
                                        const Text("30% completed", style: TextStyle(fontSize: 10,color: Colors.black54)),
                                        const SizedBox(width: 60),
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
                          top: 10,
                          right: 14,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Topics",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  // GridView of topic cards (scrollable only this part)
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 11,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.19,
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
                                  builder: (context) => const TopicPage(
                                    title: "Fundamental Rights",
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