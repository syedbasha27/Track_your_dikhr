import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/routes.dart';
import '../config/theme.dart';
import '../constants/app_strings.dart';
import '../providers/auth_provider.dart' as app_auth;
import '../providers/daily_log_provider.dart';
import '../providers/streak_provider.dart';
import '../utils/noor_calculator.dart';
import '../widgets/circular_progress.dart';
import 'salah_tracker_screen.dart';
import 'dhikr_screen.dart';
import 'character_screen.dart';

/// Main home dashboard with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load today's data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _listenForSignOut();
    });
  }

  /// Redirect to onboarding when the user logs out
  void _listenForSignOut() {
    context.read<app_auth.AuthProvider>().addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    final auth = context.read<app_auth.AuthProvider>();
    if (!auth.isAuthenticated && mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.onboarding, (_) => false);
    }
  }

  @override
  void dispose() {
    context.read<app_auth.AuthProvider>().removeListener(_onAuthChanged);
    super.dispose();
  }

  Future<void> _loadData() async {
    final uid =
        context.read<app_auth.AuthProvider>().firebaseUser?.uid;
    if (uid == null) return;
    final streakProvider = context.read<StreakProvider>();
    final logProvider = context.read<DailyLogProvider>();
    await streakProvider.loadStreak(uid);
    await logProvider.loadTodayLog(uid);
  }

  @override
  Widget build(BuildContext context) {
    const List<Widget> _pages = [
      _DashboardTab(),
      SalahTrackerScreen(),
      DhikrScreen(),
      CharacterScreen(),
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: AppStrings.navHome),
          BottomNavigationBarItem(
              icon: Icon(Icons.mosque_outlined),
              activeIcon: Icon(Icons.mosque),
              label: AppStrings.navSalah),
          BottomNavigationBarItem(
              icon: Icon(Icons.spa_outlined),
              activeIcon: Icon(Icons.spa),
              label: AppStrings.navDhikr),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement_outlined),
              activeIcon: Icon(Icons.self_improvement),
              label: AppStrings.navCharacter),
        ],
      ),
    );
  }
}

/// Dashboard tab content
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<app_auth.AuthProvider>();
    final log = context.watch<DailyLogProvider>().log;
    final streak = context.watch<StreakProvider>().streak;
    final name =
        auth.userModel?.displayName ?? auth.firebaseUser?.displayName ?? '';

    final completedPrayers =
        log != null ? NoorCalculator.completedPrayers(log) : 0;
    final completedCharacter =
        log != null ? NoorCalculator.completedCharacterDeeds(log) : 0;
    final completedDhikr =
        log != null ? NoorCalculator.completedDhikrSets(log) : 0;
    final noorScore = log?.noorScore ?? 0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundBeige,
      appBar: AppBar(
        title: Text(
          '${AppStrings.homeTitle}${name.isNotEmpty ? ', $name' : ''}',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppStrings.logout,
            onPressed: () => context.read<app_auth.AuthProvider>().logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Noor Score hero card
            _NoorScoreCard(
                score: noorScore, streak: streak.currentStreak),
            const SizedBox(height: 20),
            // Stats row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: '🕌',
                    label: AppStrings.todayPrayers,
                    value: '$completedPrayers/5',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: '📿',
                    label: 'Dhikr Sets',
                    value: '$completedDhikr/3',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: '🪞',
                    label: AppStrings.characterDeeds,
                    value: '$completedCharacter/4',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: '🔥',
                    label: AppStrings.currentStreak,
                    value: '${streak.currentStreak} ${AppStrings.days}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Prayer progress circle
            Center(
              child: CircularProgressWidget(
                completed: completedPrayers,
                total: 5,
                label: AppStrings.todayPrayers,
                size: 120,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _NoorScoreCard extends StatelessWidget {
  final int score;
  final int streak;

  const _NoorScoreCard({required this.score, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryDarkGreen, Color(0xFF1A5E5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDarkGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✨ ${AppStrings.noorScore}',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            streak > 1 ? '🔥 $streak-day streak (+10% bonus active!)' : 'Keep going — build your streak!',
            style: const TextStyle(
              color: AppTheme.accentGold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDarkGreen,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}
