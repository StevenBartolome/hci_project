import 'package:flutter/material.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Use'),
        backgroundColor: Color(0xFF2196F3),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.help_outline, size: 100, color: Color(0xFF2196F3)),
                const SizedBox(height: 20),
                Text(
                  'How to Use',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                const SizedBox(height: 30),
                _buildInstructionCard(
                  icon: Icons.mic,
                  text: 'Practice sounds with fun activities!',
                ),
                const SizedBox(height: 15),
                _buildInstructionCard(
                  icon: Icons.star,
                  text: 'Earn stars and stickers!',
                ),
                const SizedBox(height: 15),
                _buildInstructionCard(
                  icon: Icons.volume_up,
                  text: 'Listen to audio guides!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Color(0xFF2196F3)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.brown[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
