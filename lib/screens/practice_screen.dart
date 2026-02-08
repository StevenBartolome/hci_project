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

class _PracticeScreenState extends State<PracticeScreen>
    with TickerProviderStateMixin {
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
  int _selectedPosition = 0; // 0: Beginning, 1: Middle, 2: Ending
  // Data for sound positions
  final Map<String, List<Map<String, dynamic>>> _soundContent = {
    'S': [
      {
        'word': 'Sun',
        'icon': Icons.wb_sunny_rounded,
        'image': 'assets/images/practice_screen/sun.png',
        'color': Colors.orange,
        'phonetic': '/sʌn/',
        'simple_pronunciation': 's-uh-n',
      },
      {
        'word': 'Basin',
        'icon': Icons.wash_rounded,
        'image': 'assets/images/practice_screen/basin.png',
        'color': Colors.blue,
        'phonetic': "/'beɪsn/",
        'simple_pronunciation': 'BAY-sin',
      },
      {
        'word': 'Bus',
        'icon': Icons.directions_bus_rounded,
        'image': 'assets/images/practice_screen/bus.png',
        'color': Colors.yellow,
        'phonetic': '/bʌs/',
        'simple_pronunciation': 'b-uh-s',
      },
    ],
    'Z': [
      {
        'word': 'Zoo',
        'icon': Icons.fence_rounded,
        'image': 'assets/images/practice_screen/zoo.png',
        'color': Colors.grey,
        'phonetic': '/zuː/',
        'simple_pronunciation': 'z-oo',
      },
      {
        'word': 'Puzzle',
        'icon': Icons.extension_rounded,
        'image': 'assets/images/practice_screen/puzzle.png',
        'color': Colors.red,
        'phonetic': "/'pʌzl/",
        'simple_pronunciation': 'PUH-zl',
      },
      {
        'word': 'Jazz',
        'icon': Icons.music_note_rounded,
        'image': 'assets/images/practice_screen/jazz.png',
        'color': Colors.purple,
        'phonetic': '/dʒæz/',
        'simple_pronunciation': 'j-az',
      },
    ],
    'R': [
      {
        'word': 'Rabbit',
        'icon': Icons.pest_control_rodent_rounded,
        'image': 'assets/images/practice_screen/rabbit.png',
        'color': Colors.brown,
        'phonetic': "/'ræbɪt/",
        'simple_pronunciation': 'RAB-it',
      },
      {
        'word': 'Carrot',
        'icon': Icons.restaurant_rounded,
        'image': 'assets/images/practice_screen/carrot.png',
        'color': Colors.orange,
        'phonetic': "/'kærət/",
        'simple_pronunciation': 'KAIR-uh-t',
      },
      {
        'word': 'Car',
        'icon': Icons.directions_car_rounded,
        'image': 'assets/images/practice_screen/car.png',
        'color': Colors.red,
        'phonetic': '/kɑːr/',
        'simple_pronunciation': 'k-ar',
      },
    ],
    'L': [
      {
        'word': 'Lion',
        'icon': Icons.pets_rounded,
        'image': 'assets/images/practice_screen/lion.png',
        'color': Colors.orange,
        'phonetic': "/'laɪən/",
        'simple_pronunciation': 'LIE-uh-n',
      },
      {
        'word': 'Balloon',
        'icon': Icons.bubble_chart_rounded,
        'image': 'assets/images/practice_screen/balloon.png',
        'color': Colors.pink,
        'phonetic': "/bə'luːn/",
        'simple_pronunciation': 'buh-LOON',
      },
      {
        'word': 'Ball',
        'icon': Icons.sports_soccer_rounded,
        'image': 'assets/images/practice_screen/ball.png',
        'color': Colors.white,
        'phonetic': '/bɔːl/',
        'simple_pronunciation': 'b-aw-l',
      },
    ],
    'TH': [
      {
        'word': 'Thumb',
        'icon': Icons.thumb_up_rounded,
        'image': 'assets/images/practice_screen/thumb.png',
        'color': Colors.amber,
        'phonetic': '/θʌm/',
        'simple_pronunciation': 'th-uh-m',
      },
      {
        'word': 'Toothbrush',
        'icon': Icons.brush_rounded,
        'image': 'assets/images/practice_screen/toothbrush.png',
        'color': Colors.blue,
        'phonetic': "/'tuːθbrʌʃ/",
        'simple_pronunciation': 'TOOTH-brush',
      },
      {
        'word': 'Mouth',
        'icon': Icons.tag_faces_rounded,
        'image': 'assets/images/practice_screen/mouth.png',
        'color': Colors.red,
        'phonetic': '/maʊθ/',
        'simple_pronunciation': 'm-ow-th',
      },
    ],
    'SH': [
      {
        'word': 'Shoe',
        'icon': Icons.do_not_step_rounded,
        'image': 'assets/images/practice_screen/shoe.png',
        'color': Colors.brown,
        'phonetic': '/ʃuː/',
        'simple_pronunciation': 'sh-oo',
      },
      {
        'word': 'Fishing',
        'icon': Icons.phishing_rounded,
        'image': 'assets/images/practice_screen/fishing.png',
        'color': Colors.blue,
        'phonetic': "/'fɪʃɪŋ/",
        'simple_pronunciation': 'FISH-ing',
      },
      {
        'word': 'Fish',
        'icon': Icons.set_meal_rounded,
        'image': 'assets/images/practice_screen/fish.png',
        'color': Colors.teal,
        'phonetic': '/fɪʃ/',
        'simple_pronunciation': 'f-i-sh',
      },
    ],
  };

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
    await _flutterTts.setPitch(
      1.5,
    ); // Higher, more cheerful pitch like Teacher Rachel

    // IMPORTANT: Wait for speech to complete before resolving await
    await _flutterTts.awaitSpeakCompletion(true);

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
      // Determine what to speak
      final contentList = _soundContent[widget.sound];
      final currentContent =
          (contentList != null && _selectedPosition < contentList.length)
          ? contentList[_selectedPosition]
          : null;
      final wordToSpeak = currentContent?['word'] ?? widget.sound;

      // Fun introduction
      await _flutterTts.setSpeechRate(0.5); // Normal rate
      await _flutterTts.speak("Listen carefully.");
      await Future.delayed(const Duration(milliseconds: 500));

      // Speak the word slowly
      await _flutterTts.setSpeechRate(0.1); // Very slow for clear pronunciation
      await _flutterTts.speak(wordToSpeak);

      // Wait for speech to complete
      await Future.delayed(const Duration(milliseconds: 800));

      // Encouraging ending
      await _flutterTts.setSpeechRate(0.5); // Reset
      await _flutterTts.speak("Now you say $wordToSpeak!");
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

        // Start recording with a temporary path
        // The record package will save to cache directory by default
        await _audioRecorder.start(
          const RecordConfig(),
          path: '/data/user/0/com.example.hci_project/cache/temp_recording.m4a',
        );

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
      {
        "text": "That sounded amazing! 🦁",
        "voice": "Wow! You sound like a lion!",
      },
      {
        "text": "You're getting better! 🚀",
        "voice": "You're improving so fast!",
      },
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

  Widget _buildPositionTab(String text, int index) {
    bool isSelected = _selectedPosition == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPosition = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF5D4E37) : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get content for current sound and position
    final contentList = _soundContent[widget.sound];
    final currentContent =
        (contentList != null && _selectedPosition < contentList.length)
        ? contentList[_selectedPosition]
        : null;

    // Fallback if no specific content
    final displayWord = currentContent?['word'] ?? widget.sound;
    final displayIcon = currentContent?['icon'];
    final displayImage = currentContent?['image'];
    final displayColor = currentContent?['color'] ?? const Color(0xFFFFD54F);

    final displaySimple = currentContent?['simple_pronunciation'] ?? '';

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
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFFF9800),
                        ),
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

                      // Sound Position Toggle
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.6),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildPositionTab("Beginning", 0),
                            _buildPositionTab("Middle", 1),
                            _buildPositionTab("Ending", 2),
                          ],
                        ),
                      ),

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
                              color: Colors.orange.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              displayWord, // Show the target word
                              style: const TextStyle(
                                fontSize: 24, // Larger for emphasis
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B6F47),
                              ),
                            ),

                            if (displaySimple.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                "Say: $displaySimple",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation.value),
                                  child: Container(
                                    width: 160, // Slightly larger
                                    height: 160,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          displayColor.withOpacity(0.8),
                                          displayColor,
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: displayColor.withOpacity(0.4),
                                          blurRadius: 24,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                    ),
                                    child: Center(
                                      // Display image if available, else fallback to icon
                                      child: displayImage != null
                                          ? Padding(
                                              padding: const EdgeInsets.all(
                                                24.0,
                                              ),
                                              child: Image.asset(
                                                displayImage,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                          : displayIcon != null
                                          ? Icon(
                                              displayIcon,
                                              size: 80,
                                              color: Colors.white,
                                            )
                                          : Text(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
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
                                onTap: _isPlaying || _isRecording
                                    ? null
                                    : _playDemonstration,
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: _isPlaying
                                          ? [
                                              const Color(0xFF42A5F5),
                                              const Color(0xFF1976D2),
                                            ]
                                          : [
                                              const Color(0xFFE3F2FD),
                                              const Color(0xFFBBDEFB),
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withValues(
                                          alpha: 0.3,
                                        ),
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
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _isPlaying
                                              ? Icons.volume_up
                                              : Icons.volume_up_outlined,
                                          size: 36,
                                          color: _isPlaying
                                              ? const Color(0xFF1976D2)
                                              : const Color(0xFF42A5F5),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Listen",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: _isPlaying
                                              ? Colors.white
                                              : const Color(0xFF1565C0),
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
                                      scale =
                                          1.0 + (_pulseController.value * 0.05);
                                    }
                                    return Transform.scale(
                                      scale: scale,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: _isRecording
                                                ? [
                                                    const Color(0xFFEF5350),
                                                    const Color(0xFFC62828),
                                                  ]
                                                : [
                                                    const Color(0xFFFFEBEE),
                                                    const Color(0xFFFFCDD2),
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.red.withValues(
                                                alpha: _isRecording ? 0.5 : 0.3,
                                              ),
                                              blurRadius: _isRecording
                                                  ? 20
                                                  : 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.9,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                _isRecording
                                                    ? Icons.stop
                                                    : Icons.mic,
                                                size: 36,
                                                color: _isRecording
                                                    ? const Color(0xFFC62828)
                                                    : const Color(0xFFEF5350),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              _isRecording ? "Stop" : "Record",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: _isRecording
                                                    ? Colors.white
                                                    : const Color(0xFFC62828),
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
