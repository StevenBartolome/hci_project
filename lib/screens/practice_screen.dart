import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

class PracticeScreen extends StatefulWidget {
  final String sound;

  const PracticeScreen({super.key, required this.sound});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> with TickerProviderStateMixin {
  bool _isPlaying = false;
  bool _isRecording = false;
  String? _feedbackMessage;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _scaleController;
  late AnimationController _feedbackController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _feedbackAnimation;
  late FlutterTts _flutterTts;
  late AudioRecorder _audioRecorder;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for recording
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    // Floating animation for sound symbol
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    
    // Scale animation for button press
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    
    // Feedback animation
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _feedbackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );
    
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    _flutterTts = FlutterTts();
    _audioRecorder = AudioRecorder();
    
    // Configure TTS with cheerful, teacher-like voice settings
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.45); // Upbeat but clear
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.5); // Higher, more cheerful pitch like Teacher Rachel
    
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _scaleController.dispose();
    _feedbackController.dispose();
    _flutterTts.stop();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _playDemonstration() async {
    if (!_isInitialized) return;
    
    // Trigger button press animation
    _scaleController.forward().then((_) => _scaleController.reverse());
    
    setState(() {
      _isPlaying = true;
      _feedbackMessage = null;
    });

    try {
      // Fun introduction
      await _flutterTts.speak("Listen carefully!");
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Speak the sound with enthusiasm
      String textToSpeak = "${widget.sound}! ${widget.sound}! ${widget.sound}!";
      await _flutterTts.speak(textToSpeak);
      
      // Wait for speech to complete
      await Future.delayed(const Duration(seconds: 3));
      
      // Encouraging ending
      await _flutterTts.speak("Now you try!");
      await Future.delayed(const Duration(milliseconds: 1200));
    } catch (e) {
      print("TTS Error: $e");
    }

    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _toggleRecording() async {
    // Trigger button press animation
    _scaleController.forward().then((_) => _scaleController.reverse());
    
    if (_isRecording) {
      // Stop recording
      await _stopRecording();
    } else {
      // Check and request microphone permission
      final status = await Permission.microphone.request();
      
      if (status.isGranted) {
        await _startRecording();
      } else {
        // Show permission denied message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission is required to record'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
          _feedbackMessage = null;
          _isPlaying = false;
        });

        // Start recording
        await _audioRecorder.start(const RecordConfig(), path: '');
        
        // Auto-stop after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isRecording) {
            _stopRecording();
          }
        });
      }
    } catch (e) {
      print("Recording Error: $e");
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      print("Recording saved to: $path");
      
      setState(() {
        _isRecording = false;
      });

      // Simulate analysis delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        _giveFeedback();
      }
    } catch (e) {
      print("Stop Recording Error: $e");
      setState(() {
        _isRecording = false;
      });
    }
  }

  void _giveFeedback() async {
    final List<Map<String, String>> positiveFeedback = [
      {"text": "Great job! 🌟", "voice": "Awesome! You're a superstar!"},
      {"text": "That sounded amazing! 🦁", "voice": "Wow! You sound like a lion!"},
      {"text": "You're getting better! 🚀", "voice": "You're improving so fast!"},
      {"text": "Perfect pronunciation! ✨", "voice": "Perfect! You nailed it!"},
      {"text": "Fantastic! 🎉", "voice": "Fantastic work, champion!"},
      {"text": "You're a star! ⭐", "voice": "You're a shining star!"},
    ];
    
    // Random feedback
    final random = Random();
    final feedback = positiveFeedback[random.nextInt(positiveFeedback.length)];
    
    setState(() {
      _feedbackMessage = feedback['text'];
    });
    
    // Trigger feedback animation
    _feedbackController.forward(from: 0.0);
    
    // Speak the encouragement
    try {
      await _flutterTts.speak(feedback['voice']!);
    } catch (e) {
      print("Feedback TTS Error: $e");
    }
  }

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
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, color: Color(0xFFFF9800)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Practice '${widget.sound}' Sound",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4E37),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // 1. Visual Target with Floating Animation - Now in a card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFFFF9E6),
                              const Color(0xFFFFE4B5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Target Sound",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8B6F47),
                              ),
                            ),
                            const SizedBox(height: 16),
                            AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation.value),
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFFFD54F),
                                          Color(0xFFFFB300),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withValues(alpha: 0.4),
                                          blurRadius: 24,
                                          spreadRadius: 4,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.sound,
                                        style: const TextStyle(
                                          fontSize: 72,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(2, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),

                      // 2. Instructions / Feedback Area
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _feedbackMessage != null
                              ? ScaleTransition(
                                  scale: _feedbackAnimation,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.celebration,
                                        color: Color(0xFF4CAF50),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          _feedbackMessage!,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4CAF50),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  _isRecording 
                                      ? "🎤 Listening to you..." 
                                      : _isPlaying 
                                          ? "🔊 Listen carefully..." 
                                          : "Tap a button below to start!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 3. Controls - Redesigned as cards
                      Row(
                        children: [
                          // Listen Button
                          Expanded(
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: GestureDetector(
                                onTap: _isPlaying || _isRecording ? null : _playDemonstration,
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: _isPlaying
                                          ? [const Color(0xFF42A5F5), const Color(0xFF1976D2)]
                                          : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _isPlaying ? Icons.volume_up : Icons.volume_up_outlined,
                                          size: 36,
                                          color: _isPlaying ? const Color(0xFF1976D2) : const Color(0xFF42A5F5),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Listen",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: _isPlaying ? Colors.white : const Color(0xFF1565C0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 16),

                          // Record Button
                          Expanded(
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: GestureDetector(
                                onTap: _isPlaying ? null : _toggleRecording,
                                behavior: HitTestBehavior.opaque,
                                child: AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    double scale = 1.0;
                                    if (_isRecording) {
                                      scale = 1.0 + (_pulseController.value * 0.05);
                                    }
                                    return Transform.scale(
                                      scale: scale,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: _isRecording
                                                ? [const Color(0xFFEF5350), const Color(0xFFC62828)]
                                                : [const Color(0xFFFFEBEE), const Color(0xFFFFCDD2)],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.red.withValues(alpha: _isRecording ? 0.5 : 0.3),
                                              blurRadius: _isRecording ? 20 : 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.9),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                _isRecording ? Icons.stop : Icons.mic,
                                                size: 36,
                                                color: _isRecording ? const Color(0xFFC62828) : const Color(0xFFEF5350),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              _isRecording ? "Stop" : "Record",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: _isRecording ? Colors.white : const Color(0xFFC62828),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
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
