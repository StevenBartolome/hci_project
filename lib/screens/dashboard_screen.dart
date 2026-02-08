import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hci_project/widgets/hover_builder.dart';
import 'package:hci_project/services/sound_service.dart';

import 'how_to_use_screen.dart';
import 'sound_selection_screen.dart';
import 'rewards_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final SoundService _soundService = SoundService();

  // List of pages for navigation
  final List<Widget> _pages = [
    const _HomeContentPlaceholder(), // Placeholder for the extracted home content
    const SoundSelectionScreen(),
    const RewardsScreen(),
    const Center(child: Text("Profile Screen - Coming Soon")),
  ];

  void _onItemTapped(int index) {
    _soundService.playClick();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If on Home tab (index 0), show the full custom home layout
    // Otherwise, show the simple page layout from the list
    Widget currentBody;
    if (_selectedIndex == 0) {
      currentBody = _buildHomeContent();
    } else {
      currentBody = _pages[_selectedIndex];
    }

    return Scaffold(
      extendBody: true,
      body: currentBody,
      floatingActionButton: _selectedIndex == 0 ? _buildFab() : null,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHomeContent() {
    return Container(
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
            // 1. Header with Greeting & Parent Access
            _buildHeader(),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Streak Tracker
                    _buildStreakTracker(),
                    const SizedBox(height: 20),

                    // 3. Quick Action Cards
                    _buildQuickActionCards(),
                    const SizedBox(height: 20),

                    // 4. Featured Character / Mascot
                    _buildMascotSection(),
                    const SizedBox(height: 20),

                    // 5. Recent Activity / Quick Resume
                    _buildQuickResume(),
                    const SizedBox(height: 20),

                    // 6. Achievements / Badges
                    _buildAchievements(),

                    // Extra space for FAB and BottomNavBar
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Greeting with Avatar
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.orange.shade200,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.orange.shade50,
                          backgroundImage: const AssetImage(
                            'assets/images/profile_avatar/lion.png',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Afternoon,',
                            style: TextStyle(
                              fontSize: 14, // Slightly smaller
                              fontWeight: FontWeight.w600,
                              color: Colors.brown[800],
                            ),
                          ),
                          Text(
                            'Steven!',
                            style: TextStyle(
                              fontSize: 20, // Slightly smaller to fit
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Parent Access Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.lock_outline, color: Colors.grey),
                    tooltip: 'Parent Access',
                    onPressed: () {
                      _soundService.playClick();
                      // TODO: Implement Parent Access
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakTracker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade100, Colors.orange.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "You're on a 3-day streak! 🔥",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.5, // 5/10
                  minHeight: 12,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "5/10 sounds practiced today",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCards() {
    return Row(
      children: [
        _buildActionCard(
          title: 'Practice',
          icon: Icons.mic,
          color: Colors.blue.shade100,
          iconColor: Colors.blue.shade700,
          onTap: () {
            _onItemTapped(1); // Switch to Practice tab
          },
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          title: 'Rewards',
          icon: Icons.star,
          color: Colors.amber.shade100,
          iconColor: Colors.amber.shade700,
          onTap: () {
            _onItemTapped(2); // Switch to Rewards tab
          },
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          title: 'Progress',
          icon: Icons.bar_chart,
          color: Colors.purple.shade100,
          iconColor: Colors.purple.shade700,
          onTap: () {
            // TODO: Implement Progress page or modal
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: HoverBuilder(
        builder: (context, isHovered) {
          return GestureDetector(
            onTap: () {
              _soundService.playClick();
              onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 110,
              transform: isHovered
                  ? Matrix4.translationValues(0, -4, 0)
                  : Matrix4.identity(),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isHovered ? 0.1 : 0.05,
                    ),
                    blurRadius: isHovered ? 12 : 8,
                    offset: isHovered ? const Offset(0, 8) : const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 32, color: iconColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMascotSection() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.fromLTRB(20, 20, 140, 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's practice the 'S' sound today!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "You did great yesterday! Keep going!",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Image.asset(
            'assets/images/profile_avatar/lion.png', // Assuming user selected lion
            height: 130,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickResume() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Continue where you left off:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.music_note, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "'S' Sound Practice",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Lesson 2 • 5 mins remaining",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _soundService.playClick();
                  _onItemTapped(1); // Resume goes to Practice tab
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  "Resume",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Achievements",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "See All",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildBadgeItem(
                  'assets/icons/star-fall-2-svgrepo-com.svg',
                  Colors.amber,
                ),
                _buildBadgeItem(
                  'assets/icons/voice-svgrepo-com.svg',
                  Colors.blue,
                ),
                _buildBadgeItem(
                  'assets/icons/house-home-svgrepo-com.svg',
                  Colors.green,
                ),
                // Add static placeholders for more distinct badges if icon assets are limited
                _buildPlaceholderBadge(Icons.emoji_events, Colors.purple),
                _buildPlaceholderBadge(
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String assetName, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          assetName,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          width: 32,
          height: 32,
        ),
      ),
    );
  }

  Widget _buildPlaceholderBadge(IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: Icon(icon, color: color, size: 32)),
    );
  }

  Widget _buildFab() {
    return HoverBuilder(
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: isHovered
              ? Matrix4.translationValues(0, -4, 0)
              : Matrix4.identity(),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isHovered ? 0.15 : 0.1,
                      ),
                      blurRadius: isHovered ? 12 : 10,
                      offset: isHovered
                          ? const Offset(0, 8)
                          : const Offset(0, 4),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    _soundService.playClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HowToUseScreen(),
                      ),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(Icons.help_outline, color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      assetName: 'assets/icons/house-home-svgrepo-com.svg',
                      index: 0,
                      label: 'Home',
                    ),
                    _buildNavItem(
                      assetName: 'assets/icons/voice-svgrepo-com.svg',
                      index: 1,
                      label: 'Practice',
                    ),
                    _buildNavItem(
                      assetName: 'assets/icons/star-fall-2-svgrepo-com.svg',
                      index: 2,
                      label: 'Rewards',
                    ),
                    _buildNavItem(
                      assetName:
                          'assets/icons/account-customize-man-svgrepo-com.svg',
                      index: 3,
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String assetName,
    required int index,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetName,
            colorFilter: ColorFilter.mode(
              isSelected ? const Color(0xFF4CAF50) : Colors.grey,
              BlendMode.srcIn,
            ),
            width: 28,
            height: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy class to satisfy the List<Widget> type, though strictly not needed if we filter in build
class _HomeContentPlaceholder extends StatelessWidget {
  const _HomeContentPlaceholder();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
