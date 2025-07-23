import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/mood_entry_model.dart';
import '../services/firebase_service.dart';

class MoodProvider with ChangeNotifier {
  List<MoodEntry> _moodEntries = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _entriesSubscription;

  List<MoodEntry> get moodEntries => List.unmodifiable(_moodEntries);
  bool get isLoading => _isLoading;
  String? get error => _error;

  @override
  void dispose() {
    _entriesSubscription?.cancel();
    super.dispose();
  }

  // Initialize with real-time updates
  Future<void> initialize() async {
    if (FirebaseService.auth.currentUser == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Cancel any existing subscription
      _entriesSubscription?.cancel();

      final userId = FirebaseService.auth.currentUser!.uid;
      
      _entriesSubscription = FirebaseService.firestore
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots()
          .listen((snapshot) {
            _moodEntries = snapshot.docs
                .map((doc) => MoodEntry.fromFirestore(doc))
                .toList();
            notifyListeners();
          }, onError: (error) {
            _error = 'Failed to listen to mood entries: $error';
            notifyListeners();
          });

      _error = null;
    } catch (e) {
      _error = 'Failed to initialize mood entries: $e';
      _moodEntries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new mood entry
  Future<void> addMoodEntry(MoodEntry entry) async {
    if (FirebaseService.auth.currentUser == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = FirebaseService.auth.currentUser!.uid;
      final entryData = entry.toFirestore();
      entryData['userId'] = userId;
      entryData['timestamp'] = Timestamp.now();

      await FirebaseService.firestore
          .collection('mood_entries')
          .add(entryData);

      _error = null;
    } catch (e) {
      _error = 'Failed to save mood entry: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get mood entries for today
  List<MoodEntry> getTodayMoodEntries() {
    final today = DateTime.now();
    return _moodEntries.where((entry) {
      return entry.timestamp.year == today.year &&
          entry.timestamp.month == today.month &&
          entry.timestamp.day == today.day;
    }).toList();
  }

  // Get mood entries for this week
  List<MoodEntry> getWeekMoodEntries() {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day - now.weekday + 1);
    final weekEnd = weekStart.add(const Duration(days: 6));

    return _moodEntries.where((entry) {
      return !entry.timestamp.isBefore(weekStart) && 
             !entry.timestamp.isAfter(weekEnd);
    }).toList();
  }

  // Get mood distribution
  Map<MoodType, int> getMoodDistribution() {
    final distribution = <MoodType, int>{};
    
    for (final entry in _moodEntries) {
      distribution.update(
        entry.mood,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    
    return distribution;
  }

  // Get most common factors
  Map<String, int> getMostCommonFactors() {
    final factorsCount = <String, int>{};
    
    for (final entry in _moodEntries) {
      for (final factor in entry.factors) {
        factorsCount.update(
          factor,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }
    
    // Sort by count descending
    final sortedEntries = factorsCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Return top 5 factors
    return Map.fromEntries(sortedEntries.take(5));
  }

  // Get mood streak
  int getMoodStreak() {
    if (_moodEntries.isEmpty) return 0;

    int streak = 0;
    DateTime currentDate = DateTime.now();
    final uniqueDates = _moodEntries
        .map((e) => DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    for (final date in uniqueDates) {
      if (date.year == currentDate.year &&
          date.month == currentDate.month &&
          date.day == currentDate.day) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  // Delete mood entry
  Future<void> deleteMoodEntry(String entryId) async {
    try {
      await FirebaseService.firestore
          .collection('mood_entries')
          .doc(entryId)
          .delete();
    } catch (e) {
      _error = 'Failed to delete mood entry: $e';
      notifyListeners();
      rethrow;
    }
  }

  // Clear data
  void clearData() {
    _entriesSubscription?.cancel();
    _entriesSubscription = null;
    _moodEntries = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}