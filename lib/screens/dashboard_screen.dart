import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';
import '../widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _storageService = StorageService();
  User? _user;
  List<Habit> _habits = [];
  String _todayDate = '';
  int _completedToday = 0;
  int _totalDaysConsistent = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _storageService.getUser();
    final habits = await _storageService.getHabits();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    int completed = 0;
    for (var habit in habits) {
      if (habit.history.contains(today)) {
        completed++;
      }
    }

    // Calculate total consistent days (simplified)
    int consistentDays = 0;
    if (habits.isNotEmpty) {
      consistentDays = habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
    }

    setState(() {
      _user = user;
      _habits = habits;
      _todayDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());
      _completedToday = completed;
      _totalDaysConsistent = consistentDays;
    });
  }

  Future<void> _toggleHabit(Habit habit) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<String> newHistory = List.from(habit.history);
    
    if (newHistory.contains(today)) {
      newHistory.remove(today);
    } else {
      newHistory.add(today);
    }

    // Calculate streak
    int streak = _calculateStreak(newHistory);

    final updatedHabit = habit.copyWith(
      history: newHistory,
      streak: streak,
    );

    await _storageService.updateHabit(updatedHabit);
    await _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newHistory.contains(today)
                ? '✅ ${habit.nama} diselesaikan!'
                : '❌ ${habit.nama} dibatalkan',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  int _calculateStreak(List<String> history) {
    if (history.isEmpty) return 0;

    history.sort((a, b) => b.compareTo(a)); // Sort descending
    int streak = 0;
    DateTime lastDate = DateTime.parse(history[0]);

    for (var dateStr in history) {
      DateTime date = DateTime.parse(dateStr);
      if (streak == 0) {
        streak = 1;
      } else {
        final diff = lastDate.difference(date).inDays;
        if (diff == 1) {
          streak++;
          lastDate = date;
        } else {
          break;
        }
      }
    }

    return streak;
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final progress = _habits.isEmpty ? 0.0 : _completedToday / _habits.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with greeting
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, ${_user!.username}! 👋',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _todayDate,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Statistics Card
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.orange.shade400, Colors.deepOrange.shade400],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '🔥 Streak Terpanjang',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '$_totalDaysConsistent hari',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Progress Section
                          const Text(
                            'Progress Hari Ini',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$_completedToday dari ${_habits.length} kebiasaan',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${(progress * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 10,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Today's Habits
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Kebiasaan Hari Ini',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/habits');
                                },
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Lihat Semua'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          _habits.isEmpty
                              ? Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.inbox_outlined,
                                            size: 64,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Belum ada kebiasaan',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.pushNamed(context, '/add-habit');
                                            },
                                            icon: const Icon(Icons.add),
                                            label: const Text('Tambah Kebiasaan'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _habits.length,
                                  itemBuilder: (context, index) {
                                    final habit = _habits[index];
                                    final isChecked = habit.history.contains(today);
                                    final color = _getColorFromString(habit.color);

                                    return Card(
                                      elevation: 2,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            habit.icon,
                                            style: const TextStyle(fontSize: 24),
                                          ),
                                        ),
                                        title: Text(
                                          habit.nama,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            decoration: isChecked
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '🔥 ${habit.streak} hari berturut-turut',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        trailing: Checkbox(
                                          value: isChecked,
                                          activeColor: color,
                                          onChanged: (value) {
                                            _toggleHabit(habit);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-habit');
          _loadData();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}