import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:hci_project/services/sound_service.dart';
import 'package:hci_project/widgets/hover_builder.dart';
import 'package:hci_project/screens/rewards_screen.dart';
import 'package:hci_project/screens/parent_dashboard_screen.dart';
import 'package:hci_project/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onNavigateToRewards;

  const ProfileScreen({super.key, this.onNavigateToRewards});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SoundService _soundService = SoundService();

  @override
  void initState() {
    super.initState();
    // Only play background music if not already playing
    if (!_soundService.isBackgroundMusicPlaying) {
      _soundService.playBackgroundMusic();
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
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Header
                _buildProfileHeader(),
                const SizedBox(height: 24),

                // Stats Cards Grid
                _buildStatsGrid(),
                const SizedBox(height: 24), // Added small gap
                // Recent Activity Feed
                _buildRecentActivity(),
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.85),
                Colors.white.withOpacity(0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Parent Settings Button (top right)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      _soundService.playClick();
                      _showParentAccessModal(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.settings,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Avatar with Edit Button
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      _soundService.playClick();
                      _showAvatarSelection();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade300,
                            Colors.amber.shade200,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile_avatar/lion.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _soundService.playClick();
                        _showAvatarSelection();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.orange.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Child's Name
              Text(
                "Steven",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              // Level Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade300, Colors.blue.shade400],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("⭐", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text(
                      "Level 5",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text("⭐", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 12, // Reduced spacing to tighten grid
      childAspectRatio: 1.2, // Adjusted to balance height and overflow
      padding: EdgeInsets.zero,
      children: [
        _buildStatCard(
          icon: "🔥",
          value: "7",
          label: "Day Streak",
          gradient: [Colors.orange.shade300, Colors.red.shade300],
        ),
        _buildStatCard(
          icon: "⭐",
          value: "245",
          label: "Total Stars",
          gradient: [Colors.amber.shade300, Colors.yellow.shade400],
        ),
        _buildStatCard(
          icon: "🎯",
          value: "12",
          label: "Sounds Learned",
          gradient: [Colors.pink.shade300, Colors.purple.shade300],
        ),
        _buildStatCard(
          icon: "🏆",
          value: "8",
          label: "Badges",
          gradient: [Colors.blue.shade300, Colors.cyan.shade300],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String value,
    required String label,
    required List<Color> gradient,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(10), // Reduced padding further
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 24), // Reduced emoji size
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20, // Reduced font size
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11, // Reduced font size
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {
        'title': 'S Sound Practice',
        'time': 'Today',
        'stars': 25,
        'icon': Icons.mic,
        'color': Colors.blue,
      },
      {
        'title': 'Earned Gold Star',
        'time': 'Today',
        'stars': 10,
        'icon': Icons.star,
        'color': Colors.amber,
      },
      {
        'title': 'R Sound Mastered',
        'time': 'Yesterday',
        'stars': 50,
        'icon': Icons.emoji_events,
        'color': Colors.purple,
      },
      {
        'title': '3-Day Streak!',
        'time': '2 days ago',
        'stars': 30,
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
      },
    ];

    return ClipRRect(
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
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  Icon(Icons.history, color: Colors.grey[600], size: 24),
                ],
              ),
              const SizedBox(height: 16),
              ...activities.map((activity) => _buildActivityItem(activity)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (activity['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: activity['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
                Text(
                  activity['time'] as String,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade300, Colors.orange.shade400],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Text("⭐", style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  "+${activity['stars']}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const _AvatarSelectionScreen()),
    );
  }

  void _showSoundSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _SoundSettingsModal(),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(15),
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
              child: Row(
                children: [
                  const Text("⚡", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildActionButton(
          icon: Icons.palette,
          iconEmoji: "🎨",
          title: "Change My Avatar",
          subtitle: "Pick a new character",
          gradient: [Colors.pink.shade300, Colors.purple.shade400],
          onTap: () {
            _soundService.playClick();
            _showAvatarSelection();
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.volume_up,
          iconEmoji: "🔊",
          title: "Sound Settings",
          subtitle: "Volume & effects",
          gradient: [Colors.blue.shade300, Colors.cyan.shade400],
          onTap: () {
            _soundService.playClick();
            _showSoundSettings();
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.emoji_events,
          iconEmoji: "🏆",
          title: "View All Achievements",
          subtitle: "See all your rewards",
          gradient: [Colors.green.shade300, Colors.teal.shade400],
          onTap: () {
            _soundService.playClick();
            if (widget.onNavigateToRewards != null) {
              widget.onNavigateToRewards!();
            } else {
              // Fallback if callback not provided
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RewardsScreen()),
              );
            }
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.logout,
          iconEmoji: "🚪",
          title: "Logout",
          subtitle: "Return to login screen",
          gradient: [Colors.red.shade300, Colors.orange.shade400],
          onTap: () {
            _soundService.playClick();
            // Navigate to login and clear all previous routes
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String iconEmoji,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return HoverBuilder(
      builder: (context, isHovered) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: isHovered
                ? Matrix4.translationValues(0, -2, 0)
                : Matrix4.identity(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.6),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(isHovered ? 0.4 : 0.3),
                        blurRadius: isHovered ? 15 : 10,
                        offset: isHovered
                            ? const Offset(0, 6)
                            : const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          iconEmoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.9),
                                shadows: const [
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
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withOpacity(0.8),
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showParentAccessModal(BuildContext context) {
    final TextEditingController pinController = TextEditingController();
    const String correctPin = "123456";

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Parent Access 🔒",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade800,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _soundService.playClick();
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // PIN Field
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: pinController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter PIN (123456)",
                            counterText: "",
                            icon: Icon(Icons.lock_outline),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _soundService.playClick();
                            if (pinController.text == correctPin) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ParentDashboardScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "Incorrect PIN. Try 123456",
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            "Enter Parent Mode",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarSelectionScreen extends StatefulWidget {
  const _AvatarSelectionScreen();

  @override
  State<_AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<_AvatarSelectionScreen> {
  int? _selectedIndex;

  final List<String> _avatars = [
    'assets/images/profile_avatar/bear.png',
    'assets/images/profile_avatar/lion.png',
    'assets/images/profile_avatar/panda.png',
    'assets/images/profile_avatar/rhino.png',
    'assets/images/profile_avatar/tiger.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/safari_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.brown.shade800,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Choose Your Avatar",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                        shadows: const [
                          Shadow(color: Colors.white, blurRadius: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double itemWidth = (constraints.maxWidth - 60) / 2;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: List.generate(_avatars.length, (index) {
                            final isSelected = _selectedIndex == index;
                            return SizedBox(
                              width: itemWidth,
                              height: itemWidth,
                              child: HoverBuilder(
                                builder: (context, isHovered) {
                                  return GestureDetector(
                                    onTap: () {
                                      SoundService().playClick();
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      transform: isHovered || isSelected
                                          ? Matrix4.translationValues(0, -5, 0)
                                          : Matrix4.identity(),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.orange
                                              : (isHovered
                                                    ? Colors.orange.withOpacity(
                                                        0.5,
                                                      )
                                                    : Colors.transparent),
                                          width: isSelected ? 4 : 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isSelected
                                                ? Colors.orange.withOpacity(0.3)
                                                : Colors.black.withOpacity(0.1),
                                            blurRadius: isSelected ? 15 : 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Image.asset(_avatars[index]),
                                          ),
                                          if (isSelected)
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.orange,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Save Button
              if (_selectedIndex != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        SoundService().playClick();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile Successfully changed"),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Save Change",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

class _SoundSettingsModal extends StatefulWidget {
  const _SoundSettingsModal();

  @override
  State<_SoundSettingsModal> createState() => _SoundSettingsModalState();
}

class _SoundSettingsModalState extends State<_SoundSettingsModal> {
  double _musicVolume = 0.5;
  double _sfxVolume = 0.8;

  @override
  void initState() {
    super.initState();
    _musicVolume = SoundService().musicVolume;
    _sfxVolume = SoundService().sfxVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Sound Settings 🔊",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildVolumeSlider(
            "Background Music",
            Icons.music_note,
            _musicVolume,
            (value) {
              setState(() => _musicVolume = value);
              SoundService().setMusicVolume(value);
            },
            Colors.purple,
          ),
          const SizedBox(height: 24),
          _buildVolumeSlider("Sound Effects", Icons.volume_up, _sfxVolume, (
            value,
          ) {
            setState(() => _sfxVolume = value);
            SoundService().setSfxVolume(value);
          }, Colors.orange),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                SoundService().playClick();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Done",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeSlider(
    String label,
    IconData icon,
    double value,
    ValueChanged<double> onChanged,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              "${(value * 100).toInt()}%",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withOpacity(0.2),
            thumbColor: color,
            overlayColor: color.withOpacity(0.1),
          ),
          child: Slider(value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}
