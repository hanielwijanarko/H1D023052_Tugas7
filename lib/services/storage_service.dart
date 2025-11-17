import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/habit.dart';

class StorageService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUser = 'user';
  static const String _keyHabits = 'habits';

  // Login Status
  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // User Data
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUser);
    if (userString != null) {
      return User.fromJson(jsonDecode(userString));
    }
    return null;
  }

  // Habits Data
  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = habits.map((h) => h.toJson()).toList();
    await prefs.setString(_keyHabits, jsonEncode(habitsJson));
  }

  Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsString = prefs.getString(_keyHabits);
    if (habitsString != null) {
      final List<dynamic> habitsJson = jsonDecode(habitsString);
      return habitsJson.map((json) => Habit.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> addHabit(Habit habit) async {
    final habits = await getHabits();
    habits.add(habit);
    await saveHabits(habits);
  }

  Future<void> updateHabit(Habit habit) async {
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      await saveHabits(habits);
    }
  }

  Future<void> deleteHabit(String id) async {
    final habits = await getHabits();
    habits.removeWhere((h) => h.id == id);
    await saveHabits(habits);
  }

  Future<Habit?> getHabitById(String id) async {
    final habits = await getHabits();
    try {
      return habits.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // Clear all data
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}