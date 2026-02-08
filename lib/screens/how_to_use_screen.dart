import 'package:flutter/material.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'How to Use',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange.withOpacity(0.9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/safari_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header Icon with glassmorphism
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade200.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.help_outline,
                    size: 80,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'How to Use',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.8),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildInstructionCard(
                  icon: Icons.mic,
                  text: 'Practice sounds with fun activities!',
                  color: Colors.blue,
                ),
                const SizedBox(height: 15),
                _buildInstructionCard(
                  icon: Icons.star,
                  text: 'Earn stars and stickers!',
                  color: Colors.amber.shade700,
                ),
                const SizedBox(height: 15),
                _buildInstructionCard(
                  icon: Icons.volume_up,
                  text: 'Listen to audio guides!',
                  color: Colors.purple,
                ),
                const SizedBox(height: 15),
                _buildInstructionCard(
                  icon: Icons.emoji_events,
                  text: 'Complete challenges to unlock rewards!',
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
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
