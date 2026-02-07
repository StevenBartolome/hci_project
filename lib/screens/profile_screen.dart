import 'package:flutter/material.dart';
import 'dart:ui';
import 'welcome_screen.dart';
import '../widgets/hover_builder.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/safari_background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Header/Content Placeholder
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/profile_avatar/lion.png',
                        ), // Placeholder
                        backgroundColor: Colors.orangeAccent,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Steven! 🦁',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Profile Settings',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),

                      // Return to Main Menu Button
                      HoverBuilder(
                        builder: (context, isHovered) {
                          return Transform.scale(
                            scale: isHovered ? 1.05 : 1.0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const WelcomeScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: isHovered ? 8 : 4,
                              ),
                              child: const Text(
                                'Return to Main Menu',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
