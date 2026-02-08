import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hci_project/widgets/hover_builder.dart';
import 'practice_screen.dart';

class SoundSelectionScreen extends StatelessWidget {
  const SoundSelectionScreen({super.key});

  final List<Map<String, dynamic>> sounds = const [
    {
      'symbol': 'S',
      'color': 0xFF66BB6A,
      'emoji': '🐍',
      'name': 'Snake / S Sound',
    },
    {
      'symbol': 'Z',
      'color': 0xFF42A5F5,
      'emoji': '🐝',
      'name': 'Bee / Z Sound',
    },
    {
      'symbol': 'R',
      'color': 0xFFFF9800,
      'emoji': '🚗',
      'name': 'Car / R Sound',
    },
    {
      'symbol': 'L',
      'color': 0xFFAB47BC,
      'emoji': '🪜',
      'name': 'Ladder / L Sound',
    },
    {
      'symbol': 'TH',
      'color': 0xFFEC407A,
      'emoji': '👍',
      'name': 'Thumb / TH Sound',
    },
    {
      'symbol': 'SH',
      'color': 0xFF26A69A,
      'emoji': '🤫',
      'name': 'Quiet / SH Sound',
    },
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
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

    return HoverBuilder(
      builder: (context, isHovered) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PracticeScreen(sound: sound['symbol']),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: isHovered
                ? Matrix4.translationValues(0, -6, 0)
                : Matrix4.identity(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // Higher opacity for better visibility, reduced glassmorphism
                  color.withValues(alpha: isHovered ? 0.9 : 0.8),
                  color.withValues(alpha: isHovered ? 0.95 : 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: isHovered ? 0.4 : 0.3),
                  blurRadius: isHovered ? 20 : 16,
                  offset: isHovered ? const Offset(0, 12) : const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.9,
                ), // More opaque border
                width: 3,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Emoji at the top
                Text(sound['emoji'], style: const TextStyle(fontSize: 40)),
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
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
