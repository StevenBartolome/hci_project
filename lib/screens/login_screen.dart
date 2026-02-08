import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:hci_project/widgets/hover_builder.dart';
import 'package:hci_project/services/sound_service.dart';
import 'welcome_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SoundService _soundService = SoundService();
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    // Floating animation for buttons
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Start login music
    _soundService.playLoginMusic();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    _soundService.playClick();

    // Validate fields
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Please fill in all fields!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Stop login music and start welcome music
    await _soundService.playBackgroundMusic();

    // Show loading message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '🎉 Welcome back! Let\'s start your safari adventure!',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate to welcome screen after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog when back button is pressed
        return await _showExitConfirmation(context) ?? false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Main content
            Container(
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
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/images/Logo.png',
                          width: 180,
                          height: 180,
                        ),
                        const SizedBox(height: 16),

                        // Welcome Text
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Continue your sound safari adventure',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Login Form Card with Glassmorphism
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFFCE99,
                                ).withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Username Field
                                  _buildTextField(
                                    controller: _usernameController,
                                    label: 'Username',
                                    icon: Icons.person,
                                    iconColor: Colors.orange,
                                  ),
                                  const SizedBox(height: 20),

                                  // Password Field
                                  _buildTextField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    icon: Icons.lock,
                                    iconColor: Colors.blue,
                                    isPassword: true,
                                  ),
                                  const SizedBox(height: 32),

                                  // Login Button
                                  AnimatedBuilder(
                                    animation: _floatAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          0,
                                          _floatAnimation.value,
                                        ),
                                        child: HoverBuilder(
                                          builder: (context, isHovered) {
                                            return GestureDetector(
                                              onTap: _handleLogin,
                                              child: AnimatedScale(
                                                scale: isHovered ? 1.05 : 1.0,
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.green.shade400,
                                                        Colors.green.shade600,
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.green
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'Login',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          'or',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade400,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Register Button
                                  AnimatedBuilder(
                                    animation: _floatAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          0,
                                          _floatAnimation.value,
                                        ),
                                        child: HoverBuilder(
                                          builder: (context, isHovered) {
                                            return GestureDetector(
                                              onTap: () {
                                                _soundService.playClick();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegistrationScreen(),
                                                  ),
                                                );
                                              },
                                              child: AnimatedScale(
                                                scale: isHovered ? 1.05 : 1.0,
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.green.shade400,
                                                        Colors.green.shade600,
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.green
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'Register',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Speaker button
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: HoverBuilder(
                  builder: (context, isHovered) {
                    return GestureDetector(
                      onTap: () async {
                        await _soundService.toggleMute();
                        setState(() {}); // Rebuild to update icon
                      },
                      child: AnimatedScale(
                        scale: isHovered ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            _soundService.isMuted
                                ? Icons.volume_off
                                : Icons.volume_up,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmation(BuildContext context) async {
    _soundService.playClick();
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Exit App?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to exit VocaAid?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _soundService.playClick();
              Navigator.of(context).pop(false);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _soundService.playClick();
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Exit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color iconColor,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: iconColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
