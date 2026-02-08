import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rewards'),
        backgroundColor: Color(0xFFFFD700),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFFFFF8DC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, size: 100, color: Color(0xFFFFD700)),
              const SizedBox(height: 20),
              Text(
                'My Rewards',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Collect stickers and stars! ⭐',
                style: TextStyle(fontSize: 24, color: Colors.brown[600]),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('⭐', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 10),
                  Text('🌟', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 10),
                  Text('✨', style: TextStyle(fontSize: 40)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
