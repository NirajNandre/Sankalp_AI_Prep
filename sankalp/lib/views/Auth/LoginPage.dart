import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';
import 'package:sankalp/views/Screens/MainScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image (reference from other pages)
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenSize.getWidth(context)*0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: ScreenSize.getWidth(context)*0.06,
                            color: Colors.black87,
                            fontFamily: 'Poppins',
                            letterSpacing: 0.1,
                          ),
                          children: const [
                            TextSpan(text: "Sankalp"),
                            TextSpan(
                              text: ".",
                              style: TextStyle(
                                color: Color(0xFF2563EB), // your app's blue color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.05),
                    Text("Sign in to your \nAccount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenSize.getWidth(context)*0.08, height: 1.2)),
                    SizedBox(height: ScreenSize.getHeight(context)*0.01),
                    Text(
                      "Enter your credentials",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenSize.getWidth(context)*0.04, color: Colors.black87),
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.035),
                    // Email field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8),
                        ],
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          hintText: 'Enter your email',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.02),
                    // Password field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8),
                        ],
                      ),
                      child: TextField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          hintText: 'Enter your password',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.01),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (v) {
                            setState(() {
                              _rememberMe = v!;
                            });
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const Text("Remember me"),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password ?",
                            style: TextStyle(color: const Color(0xFF3B82F6), fontWeight: FontWeight.w500, fontSize: ScreenSize.getWidth(context)*0.035),
                          ),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(0, 0),
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.06),
                    SizedBox(
                      width: double.infinity,
                      height: ScreenSize.getHeight(context)*0.055,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                          elevation: 0,
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? SizedBox(
                          width: ScreenSize.getHeight(context)*0.03,
                          height: ScreenSize.getHeight(context)*0.03,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3.5,
                          ),
                        )
                            : Text("Log In", style: TextStyle(fontSize: ScreenSize.getWidth(context)*0.04, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.02),
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 1.2, color: Colors.grey[200])),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenSize.getWidth(context)*0.025),
                          child: Text("Or", style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenSize.getWidth(context)*0.04)),
                        ),
                        Expanded(child: Divider(thickness: 1.2, color: Colors.grey[200])),
                      ],
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.02),
                    SizedBox(
                      width: double.infinity,
                      height: ScreenSize.getHeight(context)*0.055,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          side: BorderSide.none,
                          elevation: 1,
                        ),
                        icon: Image.asset(
                          "assets/images/google-logo.png",
                          height: ScreenSize.getHeight(context)*0.02,
                        ),
                        onPressed: () {
                          // Google auth logic here
                        },
                        label: Text(
                          "Continue with Google",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenSize.getWidth(context)*0.04,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenSize.getWidth(context)*0.032)),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: const Color(0xFF3B82F6), fontWeight: FontWeight.w600, fontSize: ScreenSize.getWidth(context)*0.032),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenSize.getHeight(context)*0.02),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
