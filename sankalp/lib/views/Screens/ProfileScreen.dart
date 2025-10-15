import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Auth/LoginPage.dart';
import 'package:sankalp/views/Components/InfoCard.dart';
import 'package:sankalp/views/Components/tile.dart';
import 'package:sankalp/views/Screens/MainScreen.dart';// Path to ProfileTile

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background gradient/image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png", // Replace with your actual image path
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 32),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MainScreen()),
                              (route) => false,
                        );
                      },
                    ),
                    const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                    SizedBox(width: ScreenSize.getWidth(context)*0.05,)
                  ],
                ),
                SizedBox(height: ScreenSize.getHeight(context)*0.04),
                // Profile Avatar
                const CircleAvatar(
                  radius: 44,
                  backgroundImage: AssetImage("assets/images/profiles/pic3.jpg"),
                ),
                const SizedBox(height: 14),
                // Profile Name
                const Text("Raj Verma", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28, height: 1.12)),
                const SizedBox(height: 8),
                const Text("UPSC aspirant", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400, height: 1.12)),
                const SizedBox(height: 30),

                // Insights heading
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("My Insights", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                ),
                const SizedBox(height: 10),

                // Info Cards Row
                Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        color: const Color(0xFFD3EBFC),
                        child: Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Study Hours\nThis Week", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                                  SizedBox(height: 2),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("28", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 50)),
                                      SizedBox(width: 5),
                                      Text("hours", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  Text("Goal : 35 hours", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            // Red dot indicator
                            Positioned(
                              top: 8,
                              right: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: InfoCard(
                        color: AppColors.yellowColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Quizzes\nAttempted", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                            SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("20", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 50)),
                                SizedBox(width: 5),
                                Text("attempted", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            Text("Average: 72%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Tiles section
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ProfileTile(title: "Edit Profile", onTap: () {}),
                      ProfileTile(title: "Saved Content", onTap: () {}),
                      ProfileTile(title: "Help & Support", onTap: () {}),
                      ProfileTile(title: "Refer a friend", onTap: () {}),
                      const SizedBox(height: 7),
                      Container(
                        width: double.infinity,
                        height: ScreenSize.getHeight(context)*0.06,
                        margin: const EdgeInsets.only(top: 2, bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: TextButton(
                          onPressed: _isLoggingOut ? null : () async {
                            setState(() => _isLoggingOut = true);
                            await Future.delayed(const Duration(milliseconds: 1200));
                            setState(() => _isLoggingOut = false);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                                  (route) => false,
                            );
                          },
                          child: _isLoggingOut
                              ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.5,
                            ),
                          )
                              : const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reuse InfoCard from your previous screens, or make one as above.
