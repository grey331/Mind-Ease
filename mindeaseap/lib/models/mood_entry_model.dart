import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntry {
  final String id;
  final MoodType mood;
  final DateTime timestamp;
  final String? notes;
  final List<String> factors;
  final String userId;
  final double? latitude;
  final double? longitude;

  MoodEntry({
    required this.id,
    required this.mood,
    required this.timestamp,
    required this.userId,
    this.notes,
    this.factors = const [],
    this.latitude,
    this.longitude,
  });

  MoodEntry copyWith({
    String? id,
    MoodType? mood,
    DateTime? timestamp,
    String? notes,
    List<String>? factors,
    String? userId,
    double? latitude,
    double? longitude,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
      factors: factors ?? this.factors,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'mood': mood.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'notes': notes,
      'factors': factors,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory MoodEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MoodEntry(
      id: doc.id,
      mood: MoodType.values.firstWhere(
        (e) => e.name == data['mood'],
        orElse: () => MoodType.neutral,
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      notes: data['notes'],
      factors: List<String>.from(data['factors'] ?? []),
      userId: data['userId'] ?? '',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
    );
  }

  @override
  String toString() {
    return 'MoodEntry(id: $id, mood: $mood, timestamp: $timestamp, notes: $notes, factors: $factors, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoodEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum MoodType {
  veryHappy(value: 10, label: 'Very Happy', color: Colors.green, emoji: '😄'),
  happy(value: 8, label: 'Happy', color: Colors.lightGreen, emoji: '😊'),
  good(value: 6, label: 'Good', color: Colors.yellow, emoji: '🙂'),
  neutral(value: 5, label: 'Neutral', color: Colors.amber, emoji: '😐'),
  okay(value: 4, label: 'Okay', color: Colors.orange, emoji: '😕'),
  sad(value: 2, label: 'Sad', color: Colors.deepOrange, emoji: '😢'),
  verySad(value: 1, label: 'Very Sad', color: Colors.red, emoji: '😭');

  const MoodType({
    required this.value,
    required this.label,
    required this.color,
    required this.emoji,
  });

  final int value;
  final String label;
  final Color color;
  final String emoji;

  static List<String> get moodFactors => [
    'Work stress',
    'Relationship issues',
    'Financial concerns',
    'Health issues',
    'Sleep problems',
    'Exercise',
    'Social activities',
    'Weather',
    'Medication',
    'Therapy session',
    'Family time',
    'Hobbies',
    'Achievement',
    'Disappointment',
    'Anxiety',
    'Gratitude',
    'Loneliness',
    'Excitement',
    'Frustration',
    'Contentment',
  ];
}

