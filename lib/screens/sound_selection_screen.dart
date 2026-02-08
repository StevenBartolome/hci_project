import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'practice_screen.dart';

class SoundSelectionScreen extends StatelessWidget {
  const SoundSelectionScreen({super.key});

  final List<Map<String, dynamic>> sounds = const [
    {'symbol': 'S', 'color': 0xFF66BB6A, 'emoji': '🐍', 'name': 'Snake Sound'},
    {'symbol': 'Z', 'color': 0xFF42A5F5, 'emoji': '🐝', 'name': 'Bee Sound'},
    {'symbol': 'R', 'color': 0xFFFF9800, 'emoji': '🦁', 'name': 'Lion Sound'},
    {'symbol': 'L', 'color': 0xFFAB47BC, 'emoji': '🦋', 'name': 'Butterfly Sound'},
    {'symbol': 'TH', 'color': 0xFFEC407A, 'emoji': '🌸', 'name': 'Flower Sound'},
    {'symbol': 'SH', 'color': 0xFF26A69A, 'emoji': '🌊', 'name': 'Wave Sound'},
    {'symbol': 'CH', 'color': 0xFFFFCA28, 'emoji': '🐥', 'name': 'Chick Sound'},
    {'symbol': 'J', 'color': 0xFF5C6BC0, 'emoji': '🎵', 'name': 'Music Sound'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/safari_background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Choose a sound to practice!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4E37),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Sound Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: sounds.length,
                  itemBuilder: (context, index) {
                    return _buildSoundCard(context, sounds[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoundCard(BuildContext context, Map<String, dynamic> sound) {
    final color = Color(sound['color']);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PracticeScreen(sound: sound['symbol']),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.25),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji at the top
            Text(
              sound['emoji'],
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 8),
            
            // Sound symbol in cheerful circle
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  sound['symbol'],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Friendly label
            Text(
              sound['name'],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
