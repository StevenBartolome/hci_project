import 'package:flutter/material.dart';

class SoundSelectionScreen extends StatelessWidget {
  const SoundSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Sounds'),
        backgroundColor: Color(0xFF4CAF50),
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
              Icon(Icons.mic, size: 100, color: Color(0xFF4CAF50)),
              const SizedBox(height: 20),
              Text(
                'Sound Selection',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Coming Soon! 🎤',
                style: TextStyle(fontSize: 24, color: Colors.brown[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
