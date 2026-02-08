import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'package:hci_project/widgets/hover_builder.dart';
import 'package:hci_project/services/sound_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  final SoundService _soundService = SoundService();

  @override
  void initState() {
    super.initState();

    // Floating animation for start button
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  void _toggleMute() {
    _soundService.toggleMute();
    setState(() {}); // Rebuild to update UI
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome_bg.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Spacer(flex: 5),

                    // Start Adventure Button - Image Button with Float Animation
                    AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: HoverBuilder(
                            builder: (context, isHovered) {
                              return GestureDetector(
                                onTap: () {
                                  // Play click sound
                                  _soundService.playClick();
                                  // Navigate to dashboard
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardScreen(),
                                    ),
                                  );
                                },
                                child: AnimatedScale(
                                  scale: isHovered ? 1.08 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Image.asset(
                                    'assets/images/start_button.png',
                                    width: 200,
                                    height: 80,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const Spacer(flex: 2),
                  ],
                ),
              ),

              // Mute/Unmute Button - Top Left
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: _toggleMute,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _soundService.isMuted
                          ? Icons.volume_off
                          : Icons.volume_up,
                      color: _soundService.isMuted ? Colors.red : Colors.blue,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
