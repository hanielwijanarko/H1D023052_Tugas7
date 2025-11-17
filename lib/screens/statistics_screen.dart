import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';
import '../widgets/app_drawer.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _storageService = StorageService();
  List<Habit> _habits = [];
  bool _isLoading = true;

  int _totalHabits = 0;
  String _longestStreakHabit = '';
  int _longestStreak = 0;
  double _weeklyCompletion = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    final habits = await _storageService.getHabits();

    // Calculate statistics
    int totalHabits = habits.length;
    String longestHabitName = '-';
    int longestStreak = 0;
    
    for (var habit in habits) {
      if (habit.streak > longestStreak) {
        longestStreak = habit.streak;
        longestHabitName = habit.nama;
      }
    }

    // Calculate weekly completion
    double weeklyCompletion = 0.0;
    if (habits.isNotEmpty) {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      int totalPossible = habits.length * 7;
      int totalCompleted = 0;

      for (var habit in habits) {
        for (var i = 0; i < 7; i++) {
          final checkDate = weekStart.add(Duration(days: i));
          final dateStr = DateFormat('yyyy-MM-dd').format(checkDate);
          if (habit.history.contains(dateStr)) {
            totalCompleted++;
          }
        }
      }

      weeklyCompletion = totalPossible > 0 ? (totalCompleted / totalPossible) * 100 : 0;
    }

    setState(() {
      _habits = habits;
      _totalHabits = totalHabits;
      _longestStreakHabit = longestHabitName;
      _longestStreak = longestStreak;
      _weeklyCompletion = weeklyCompletion;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistik',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Statistik',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Total Kebiasaan
                    _buildStatCard(
                      title: 'Total Kebiasaan',
                      value: '$_totalHabits',
                      icon: Icons.list_alt,
                      color: Colors.blue,
                      subtitle: 'Kebiasaan yang dibuat',
                    ),
                    const SizedBox(height: 16),

                    // Longest Streak
                    _buildStatCard(
                      title: 'Streak Terpanjang',
                      value: '$_longestStreak hari',
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                      subtitle: _longestStreakHabit,
                    ),
                    const SizedBox(height: 16),

                    // Weekly Completion
                    _buildStatCard(
                      title: 'Penyelesaian Minggu Ini',
                      value: '${_weeklyCompletion.toStringAsFixed(1)}%',
                      icon: Icons.trending_up,
                      color: Colors.green,
                      subtitle: 'Dari semua kebiasaan',
                    ),
                    const SizedBox(height: 30),

                    // Detail per Habit
                    if (_habits.isNotEmpty) ...[
                      const Text(
                        'Detail Kebiasaan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _habits.length,
                        itemBuilder: (context, index) {
                          final habit = _habits[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  habit.icon,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              title: Text(
                                habit.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    '🔥 Streak: ${habit.streak} hari',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    '✅ Total: ${habit.history.length} kali',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Icon(
                              Icons.bar_chart_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada data statistik',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mulai tambahkan kebiasaan!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}