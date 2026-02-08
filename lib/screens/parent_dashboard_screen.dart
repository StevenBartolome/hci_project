import 'package:flutter/material.dart';
import 'dart:ui';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Settings State
  bool _soundEffectsEnabled = true;
  bool _practiceRemindersEnabled = false;
  bool _weeklyReportEnabled = true;
  bool _childSafetyModeEnabled = false;
  String _selectedAvatar = 'assets/images/profile_avatar/lion.png';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildAvatarOption(String assetPath) {
    bool selected = _selectedAvatar == assetPath;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAvatar = assetPath;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selected ? Colors.orange : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: AssetImage(assetPath),
        ),
      ),
    );
  }

  Widget _buildToggleSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.8)),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.deepOrange,
        secondary: Icon(
          title == 'Sound Effects'
              ? Icons.volume_up_outlined
              : title == 'Practice Reminders'
              ? Icons.notifications_none
              : title ==
                    'Child Safety Mode' // Add icon for Safety Mode
              ? Icons.shield_outlined
              : Icons.email_outlined,
          color: Colors.orange.shade800,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset:
          false, // Prevents background image from adjusting/squishing
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/safari_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.white.withOpacity(0.3)),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ), // Smoothly adjust for keyboard
            child: Column(
              children: [
                // 1. Header Section
                _buildHeader(),

                // 2. Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
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
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.deepOrange, // Changed to Orange
                    unselectedLabelColor: Colors.grey.shade700,
                    indicatorColor: Colors.deepOrange, // Changed to Orange
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.analytics_outlined),
                        child: FittedBox(child: Text('Overview')),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.analytics_outlined,
                        ), // Changed icon to match "Graph" concept if needed, or keep generic
                        child: FittedBox(child: Text('Progress')),
                      ),
                      Tab(
                        icon: Icon(Icons.calendar_month_outlined),
                        child: FittedBox(child: Text('Sessions')),
                      ),
                      Tab(
                        icon: Icon(Icons.settings_outlined),
                        child: FittedBox(child: Text('Settings')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildProgressTab(),
                      _buildSessionsTab(),
                      _buildSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parent Dashboard',
                    style: TextStyle(
                      fontSize:
                          24, // Slightly smaller to fix overflow if new layout is wider
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                      shadows: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Steven's Progress Overview",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  elevation: 2,
                ),
                tooltip: 'Exit Parent Mode',
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Quick Stats Cards
          Row(
            children: [
              _buildQuickStatCard(
                '7',
                'Day Streak',
                Colors.orange.withOpacity(0.8),
              ),
              const SizedBox(width: 12),
              _buildQuickStatCard(
                '12',
                'This Week',
                Colors.blue.withOpacity(0.8),
              ),
              const SizedBox(width: 12),
              _buildQuickStatCard(
                '12',
                'Mastered',
                Colors.green.withOpacity(0.8),
              ),
              const SizedBox(width: 12),
              _buildQuickStatCard(
                '4h',
                'Total Time',
                Colors.purple.withOpacity(0.8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(String value, String label, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // --- Placeholder Widgets for Tabs ---

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Overall Progress'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildOverviewStatCard(
                  title: 'Mastered Sounds',
                  value: '12/24',
                  subtitle: '',
                  icon: Icons.check_circle_outline,
                  color: Colors.green.shade50,
                  accentColor: Colors.green,
                  progressBarValue: 0.5,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOverviewStatCard(
                  title: 'In Progress',
                  value: '8',
                  subtitle: 'sounds being practiced',
                  icon: Icons.timeline,
                  color: Colors.blue.shade50,
                  accentColor: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildOverviewStatCard(
                  title: 'Practice Time',
                  value: '245',
                  subtitle: 'minutes total',
                  icon: Icons.timer_outlined,
                  color: Colors.purple.shade50,
                  accentColor: Colors.purple,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOverviewStatCard(
                  title: 'Longest Streak',
                  value: '14',
                  subtitle: 'days in a row',
                  icon: Icons.local_fire_department_outlined,
                  color: Colors.orange.shade50,
                  accentColor: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // AI Insights
          _buildSectionTitle('✨ Personalized Insights'),
          const SizedBox(height: 16),
          _buildInsightCard(
            title: 'Focus on "R" Sound',
            description:
                'Steven is making progress but could benefit from more practice with the R sound.',
            actionLabel: 'Schedule Practice',
            color: Colors.blue.shade50,
            accentColor: Colors.blue,
            onPressed: () => _pickDateAndSave(context, 'Schedule Practice'),
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            title: 'Great Streak!',
            description:
                '7 days in a row! Encourage Steven to keep the momentum going.',
            actionLabel: 'Send Praise',
            color: Colors.green.shade50,
            accentColor: Colors.green,
            onPressed: () => _sendPraise(context),
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            title: 'Best Practice Time',
            description:
                'Steven shows highest accuracy during afternoon sessions (2-4 PM).',
            actionLabel: 'Set Reminder',
            color: Colors.amber.shade50,
            accentColor: Colors.amber.shade800,
            onPressed: () => _pickDateAndSave(context, 'Set Reminder'),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color accentColor,
    double? progressBarValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          if (progressBarValue != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressBarValue,
                backgroundColor: accentColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 6,
              ),
            ),
          ],
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Weekly Activity'),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarChartColumn('Mon', 0.4, Colors.blue.shade300),
                _buildBarChartColumn('Tue', 0.6, Colors.blue.shade300),
                _buildBarChartColumn('Wed', 0.3, Colors.blue.shade300),
                _buildBarChartColumn('Thu', 0.8, Colors.blue),
                _buildBarChartColumn('Fri', 0.7, Colors.blue.shade300),
                _buildBarChartColumn('Sat', 0.9, Colors.blue.shade300),
                _buildBarChartColumn('Sun', 0.5, Colors.blue.shade300),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Sound-by-Sound Progress'),
          const SizedBox(height: 16),
          _buildSoundProgressItem(
            'S',
            'S Sound',
            'Mastered',
            0.95,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildSoundProgressItem(
            'R',
            'R Sound',
            'In Progress',
            0.88,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildSoundProgressItem(
            'TH',
            'TH Sound',
            'In Progress',
            0.72,
            Colors.orange,
          ), // Intentionally < 75% for variety? User said 92% in prompt, let's stick to prompt or reasonable defaults. Green=90+, Blue=75-89, Yellow<75.
          // Correcting based on prompt logic:
          // S: Mastered 95% -> Green
          // R: In Progress 88% -> Blue
          // TH: In Progress 72% -> Yellow (Prompt said Green=90+, Blue=75-89, Yellow=<75%)
          // Let's match the prompt's example data though: "TH Sound... 92%... Green"
          // Wait, prompt says: "Sound letter (S, R, TH...)", "Green = 90%+, Blue = 75-89%, Yellow = <75%"
          // But also in the ASCII art: "TH Sound 8 practice sessions Accuracy 92%"
          // I will follow the visual example for TH being 92% (Green) and maybe add another one for Yellow.
          const SizedBox(height: 12),
          _buildSoundProgressItem(
            'L',
            'L Sound',
            'Mastered',
            0.94,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildSoundProgressItem(
            'K',
            'K Sound',
            'In Progress',
            0.85,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildSoundProgressItem(
            'F',
            'F Sound',
            'Not Started',
            0.0,
            Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartColumn(String day, double heightFactor, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 12,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                heightFactor: heightFactor,
                child: Container(
                  width: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildSoundProgressItem(
    String letter,
    String title,
    String status,
    double progress,
    Color color,
  ) {
    Color statusColor;
    if (status == 'Mastered') {
      statusColor = Colors.green.shade100;
    } else if (status == 'In Progress') {
      statusColor = Colors.blue.shade100;
    } else {
      statusColor = Colors.grey.shade200;
    }

    Color textColor;
    if (status == 'Mastered') {
      textColor = Colors.green.shade800;
    } else if (status == 'In Progress') {
      textColor = Colors.blue.shade800;
    } else {
      textColor = Colors.grey.shade800;
    }

    // Dynamic color based on progress for the bar
    Color barColor;
    if (progress >= 0.90) {
      barColor = Colors.green;
    } else if (progress >= 0.75) {
      barColor = Colors.blue;
    } else {
      barColor = Colors.amber; // Yellow/Amber for < 75%
    }

    // Override if Not Started
    if (progress == 0) barColor = Colors.grey.shade300;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      status == 'Not Started'
                          ? '0 practice sessions'
                          : '${(progress * 20).toInt()} practice sessions', // clear mock data
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          if (progress > 0) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Accuracy',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 8,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionsTab() {
    // Mock Data for Sessions
    final List<Map<String, dynamic>> sessions = [
      {
        'date': 'Today, 2:30 PM',
        'sound': 'S Sound',
        'duration': '15 min',
        'accuracy': '95%',
        'stars': 3,
      },
      {
        'date': 'Yesterday, 4:15 PM',
        'sound': 'R Sound',
        'duration': '12 min',
        'accuracy': '88%',
        'stars': 2,
      },
      {
        'date': 'Feb 5, 10:00 AM',
        'sound': 'TH Sound',
        'duration': '20 min',
        'accuracy': '92%',
        'stars': 3,
      },
      {
        'date': 'Feb 3, 3:45 PM',
        'sound': 'L Sound',
        'duration': '10 min',
        'accuracy': '78%',
        'stars': 2,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('History'),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement export functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting report...')),
                  );
                },
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Export Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // Table Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Date & Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Sound',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Acc.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Stars',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Table Rows
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sessions.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              session['date'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(flex: 2, child: Text(session['sound'])),
                          Expanded(
                            flex: 1,
                            child: Text(
                              session['accuracy'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    (int.parse(
                                          session['accuracy'].replaceAll(
                                            '%',
                                            '',
                                          ),
                                        ) >=
                                        90)
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: List.generate(
                                3,
                                (starIndex) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: starIndex < session['stars']
                                      ? Colors.amber
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Safety Mode Toggle
          const SizedBox(height: 24),

          // Child Profile (Restored)
          _buildSectionTitle('Child Profile'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.6)),
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
                const Text(
                  'Child\'s Name',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: 'Steven',
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Age',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: '6 years old',
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                  ),
                  items:
                      [
                            '4 years old',
                            '5 years old',
                            '6 years old',
                            '7 years old',
                            '8 years old',
                            '8+ years old',
                          ]
                          .map(
                            (age) =>
                                DropdownMenuItem(value: age, child: Text(age)),
                          )
                          .toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                const Text(
                  'Avatar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildAvatarOption(
                              'assets/images/profile_avatar/lion.png',
                            ),
                            const SizedBox(width: 12),
                            _buildAvatarOption(
                              'assets/images/profile_avatar/bear.png',
                            ),
                            const SizedBox(width: 12),
                            _buildAvatarOption(
                              'assets/images/profile_avatar/tiger.png',
                            ),
                            const SizedBox(width: 12),
                            _buildAvatarOption(
                              'assets/images/profile_avatar/rhino.png',
                            ),
                            const SizedBox(width: 12),
                            _buildAvatarOption(
                              'assets/images/profile_avatar/panda.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // App Settings (Restored)
          _buildSectionTitle('App Settings'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.6)),
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
                _buildToggleSetting(
                  'Sound Effects',
                  'Play sounds during practice',
                  _soundEffectsEnabled,
                  (val) => setState(() => _soundEffectsEnabled = val),
                ),
                const Divider(),
                _buildToggleSetting(
                  'Practice Reminders',
                  'Daily notification at 3:00 PM',
                  _practiceRemindersEnabled,
                  (val) => setState(() => _practiceRemindersEnabled = val),
                ),
                const Divider(),
                _buildToggleSetting(
                  'Weekly Progress Report',
                  'Receive email summary',
                  _weeklyReportEnabled,
                  (val) => setState(() => _weeklyReportEnabled = val),
                ),
                const Divider(),
                _buildToggleSetting(
                  'Child Safety Mode',
                  'Restrict app features',
                  _childSafetyModeEnabled,
                  (val) => setState(() => _childSafetyModeEnabled = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          _buildSectionTitle('Account'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSettingsListTile(
                  'Change Parent PIN',
                  onTap: () => _showChangePINDialog(context),
                ),
                const Divider(height: 1),
                _buildSettingsListTile(
                  'Privacy Policy',
                  onTap: () => _showPrivacyPolicyDialog(context),
                ),
                const Divider(height: 1),
                _buildSettingsListTile(
                  'Help & Support',
                  onTap: () => _showHelpSupportDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Settings saved successfully!'),
                  backgroundColor: Colors.green.shade600,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: const Center(
              child: Text(
                'Save Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exit Parent Mode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  Icon(Icons.logout, color: Colors.red.shade700),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingsListTile(String title, {required VoidCallback onTap}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String description,
    required String actionLabel,
    required Color color,
    required Color accentColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateAndSave(BuildContext context, String action) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$action scheduled for ${picked.toString().split(' ')[0]}',
          ),
          backgroundColor: Colors.green.shade600,
        ),
      );
    }
  }

  void _sendPraise(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Praise?'),
        content: const Text(
          'This will send a "Great Job!" notification to Steven.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Praise sent successfully!'),
                  backgroundColor: Colors.green.shade600,
                ),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showChangePINDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Parent PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Current PIN',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'New PIN',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement PIN change logic here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('PIN changed successfully!'),
                    backgroundColor: Colors.green.shade600,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: SingleChildScrollView(
            child: const Text(
              'VocaAid: Sound Safari Adventure respects your privacy.\n\n'
              '1. Data Collection: We collect minimal data necessary for tracking progress (e.g., practice sessions, accuracy scores).\n'
              '2. Usage: Data is stored locally on your device and is not shared with third parties.\n'
              '3. Voice Data: Audio recordings are processed locally for speech recognition and are not uploaded to external servers.\n'
              '4. Child Safety: This app is designed for children and complies with COPPA guidelines.\n\n'
              'For more details, please visit our website at www.vocaaid.com/privacy.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 650, maxWidth: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.shade100.withOpacity(0.95),
                  Colors.amber.shade100.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade200.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade300.withOpacity(0.9),
                            Colors.deepOrange.withOpacity(0.9),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.help_outline_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Help & Support',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Welcome message with glassmorphism
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.shade200.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      '🦁',
                                      style: TextStyle(fontSize: 28),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Need help with VocaAid?\nWe\'re here to help!',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.brown.shade800,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // FAQ Section Title
                            Text(
                              'Frequently Asked Questions',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade800,
                              ),
                            ),
                            const SizedBox(height: 12),

                            _buildFAQItem(
                              '📱 How do I start a practice session?',
                              'Tap on any sound card from the main dashboard to begin practicing that specific sound.',
                              Colors.blue,
                            ),
                            _buildFAQItem(
                              '⭐ How are rewards earned?',
                              'Complete practice sessions with good accuracy to earn stickers and unlock new safari adventures!',
                              Colors.amber.shade700,
                            ),
                            _buildFAQItem(
                              '👨‍👩‍👧 How do I access Parent Dashboard?',
                              'Look for the small parent icon at the bottom of the main screen and enter your PIN.',
                              Colors.green,
                            ),
                            _buildFAQItem(
                              '🔊 Audio not working?',
                              'Check your device volume and ensure microphone permissions are enabled in device settings.',
                              Colors.purple,
                            ),

                            const SizedBox(height: 20),

                            // Contact Section
                            Text(
                              'Still Need Help?',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade800,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _buildContactOption(
                                    Icons.email_outlined,
                                    'Email Support',
                                    'support@vocaaid.com',
                                    Colors.orange,
                                  ),
                                  const Divider(height: 24),
                                  _buildContactOption(
                                    Icons.bug_report_outlined,
                                    'Report an Issue',
                                    'Tap to report bugs',
                                    Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFAQItem(String question, String answer, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            question,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade800,
            ),
          ),
          iconColor: accentColor,
          collapsedIconColor: accentColor.withOpacity(0.7),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey.shade400),
      ],
    );
  }
}
