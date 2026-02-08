import 'package:flutter/material.dart';
import 'package:hci_project/services/sound_service.dart';
import 'dart:ui';
import 'package:hci_project/widgets/hover_builder.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SoundService _soundService = SoundService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Play click sound when tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _soundService.playClick();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          bottom: false,
          child: Column(
            children: [
              // 1. Header Section
              _buildHeader(),

              // 2. Tab Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.orange.shade400,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.brown.shade700,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("🎨"),
                                SizedBox(width: 8),
                                Text("Stickers"),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("🏅"),
                                SizedBox(width: 8),
                                Text("Badges"),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("🏆"),
                                SizedBox(width: 8),
                                Text("Wins"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildStickersTab(),
                    _buildBadgesTab(),
                    _buildWinsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Rewards",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade300,
                            Colors.orange.shade400,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "✨ 245 ✨",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Steven, you're doing amazing! 🎉",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickersTab() {
    // Sticker Data
    final stickers = [
      {
        'name': 'Gold Star',
        'emoji': '⭐',
        'unlocked': true,
        'date': 'Today',
        'description': 'You are a shining star! Keep up the great work!',
      },
      {
        'name': 'Brave Lion',
        'emoji': '🦁',
        'unlocked': true,
        'date': 'Yesterday',
        'description': 'Roaring with courage! You faced a tough challenge.',
      },
      {
        'name': 'Artist',
        'emoji': '🎨',
        'unlocked': true,
        'date': '2 days ago',
        'description': 'Creative genius! Your imagination is amazing.',
      },
      {
        'name': 'Rocket',
        'emoji': '🚀',
        'unlocked': true,
        'date': '3 days ago',
        'description': 'Blast off! You are learning so fast.',
      },
      {
        'name': 'Bullseye',
        'emoji': '🎯',
        'unlocked': true,
        'date': '4 days ago',
        'description': 'Right on target! Perfect practice session.',
      },
      {
        'name': 'Rainbow',
        'emoji': '🌈',
        'unlocked': true,
        'date': '5 days ago',
        'description': 'Colorful and bright! You bring joy to learning.',
      },
      {
        'name': 'Music Note',
        'emoji': '🎵',
        'unlocked': false,
        'date': '',
        'description': 'Unlock this by practicing a song!',
      },
      {
        'name': 'Cool Cat',
        'emoji': '😎',
        'unlocked': false,
        'date': '',
        'description': 'Stay cool and keep practicing!',
      },
      {
        'name': 'Winner Cup',
        'emoji': '🏆',
        'unlocked': false,
        'date': '',
        'description': 'For the ultimate champion!',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      child: Column(
        children: [
          // Progress Bar Card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontFamily: 'Segoe UI', // Default font
                    ),
                    children: [
                      TextSpan(
                        text: "6",
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: " of 9 stickers collected!"),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 6 / 9,
                    backgroundColor: Colors.orange.shade50,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange.shade400,
                    ),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          ),

          // Sticker Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: stickers.length,
            itemBuilder: (context, index) {
              final sticker = stickers[index];
              final isUnlocked = sticker['unlocked'] as bool;

              return HoverBuilder(
                builder: (context, isHovered) {
                  return GestureDetector(
                    onTap: () => _showStickerDetails(context, sticker),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: isHovered && isUnlocked
                          ? Matrix4.translationValues(0, -4, 0)
                          : Matrix4.identity(),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isUnlocked ? 0.9 : 0.6),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isUnlocked ? (isHovered ? 0.1 : 0.05) : 0.02,
                            ),
                            blurRadius: isHovered ? 12 : 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: isUnlocked
                            ? Border.all(color: Colors.transparent)
                            : Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isUnlocked
                                    ? (sticker['emoji'] as String)
                                    : "🔒",
                                style: TextStyle(
                                  fontSize: 40,
                                  color: isUnlocked ? null : Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                sticker['name'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked
                                      ? Colors.brown.shade800
                                      : Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (isUnlocked)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    sticker['date'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange.shade800,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (isUnlocked)
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFD700),
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        _buildBadgeCard(
          title: "3-Day Streak",
          description: "Practice 3 days in a row",
          progress: 3,
          total: 3,
          icon: "🔥",
          color: Colors.orange,
          isEarned: true,
        ),
        _buildBadgeCard(
          title: "Sound Master",
          description: "Complete 10 sounds",
          progress: 10,
          total: 10,
          icon: "📚",
          color: Colors.blue,
          isEarned: true,
        ),
        _buildBadgeCard(
          title: "Practice Pro",
          description: "Practice 50 times",
          progress: 32,
          total: 50,
          icon: "🎤",
          color: Colors.grey,
          isEarned: false,
        ),
        _buildBadgeCard(
          title: "Early Bird",
          description: "Practice before 9 AM",
          progress: 1,
          total: 5,
          icon: "🌅",
          color: Colors.grey,
          isEarned: false,
        ),
      ],
    );
  }

  Widget _buildBadgeCard({
    required String title,
    required String description,
    required int progress,
    required int total,
    required String icon,
    required Color color,
    required bool isEarned,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: isEarned
            ? Border.all(color: Colors.amber, width: 2)
            : Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isEarned ? color.withOpacity(0.1) : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Text(icon, style: const TextStyle(fontSize: 30)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800,
                          ),
                        ),
                        if (isEarned) ...[
                          const SizedBox(width: 8),

                          Container(
                            // Keeping the original "EARNED! 🎉" badge as the instruction was ambiguous
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "EARNED! 🎉",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress / total,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isEarned ? const Color(0xFF00C853) : color,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "$progress/$total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.brown.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWinsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        _buildWinCard(
          title: "First Practice!",
          description: "Completed your first sound practice",
          points: 10,
          icon: "🏆",
          color: Colors.amber,
          isDone: true,
        ),
        _buildWinCard(
          title: "Perfect Score!",
          description: "Got 100% on a practice round",
          points: 25,
          icon: "🎯",
          color: Colors.orange,
          isDone: true,
        ),
        _buildWinCard(
          title: "Week Warrior",
          description: "Practice every day for a week",
          points: 50,
          icon: "🔒",
          color: Colors.grey,
          isDone: false,
        ),
        _buildWinCard(
          title: "Vocabulary Master",
          description: "Learn 50 new words",
          points: 100,
          icon: "🔒",
          color: Colors.grey,
          isDone: false,
        ),
      ],
    );
  }

  Widget _buildWinCard({
    required String title,
    required String description,
    required int points,
    required String icon,
    required Color color,
    required bool isDone,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: isDone
            ? Border(left: BorderSide(color: const Color(0xFF00C853), width: 6))
            : Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDone ? color.withOpacity(0.1) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Text(icon, style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.brown.shade400),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "+$points points",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isDone)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check, size: 16, color: Color(0xFF2E7D32)),
                  SizedBox(width: 4),
                  Text(
                    "Done",
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showStickerDetails(BuildContext context, Map<String, Object> sticker) {
    final isUnlocked = sticker['unlocked'] as bool;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Backend/Card
            Container(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sticker['name'] as String,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isUnlocked
                        ? (sticker['description'] as String)
                        : "Keep practicing to unlock this sticker!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: Colors.orange.shade800,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Earned: ${sticker['date']}",
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Awesome!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Floating Emoji
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  isUnlocked ? (sticker['emoji'] as String) : "🔒",
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
