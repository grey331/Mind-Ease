import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';
import '../models/message_model.dart';
import '../models/mood_entry_model.dart';
import 'firebase_service.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static final firebase_auth.FirebaseAuth _auth = FirebaseService.auth;

  // Collections
  static const String _usersCollection = 'users';
  static const String _messagesCollection = 'messages';
  static const String _moodEntriesCollection = 'mood_entries';
  static const String _counsellorsCollection = 'counsellors';
  static const String _sessionsCollection = 'sessions';

  // User Operations
  static Future<void> createUser(User user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  static Future<User?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return User.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  static Future<void> updateUser(User user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .update(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Message Operations
  static Future<String> saveMessage(Message message) async {
    try {
      final docRef = await _firestore
          .collection(_messagesCollection)
          .add(message.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save message: $e');
    }
  }

  static Stream<List<Message>> getMessagesStream(String userId) {
    return _firestore
        .collection(_messagesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromFirestore(doc))
            .toList());
  }

  static Future<List<Message>> getMessages(String userId, {int limit = 50}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_messagesCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Message.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  // Mood Entry Operations
  static Future<String> saveMoodEntry(MoodEntry moodEntry) async {
    try {
      final docRef = await _firestore
          .collection(_moodEntriesCollection)
          .add(moodEntry.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save mood entry: $e');
    }
  }

  static Stream<List<MoodEntry>> getMoodEntriesStream(String userId) {
    return _firestore
        .collection(_moodEntriesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MoodEntry.fromFirestore(doc))
            .toList());
  }

  static Future<List<MoodEntry>> getMoodEntries(String userId, {int limit = 100}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_moodEntriesCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => MoodEntry.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get mood entries: $e');
    }
  }

  static Future<List<MoodEntry>> getMoodEntriesForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_moodEntriesCollection)
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => MoodEntry.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get mood entries for date range: $e');
    }
  }

  static Future<void> updateMoodEntry(MoodEntry moodEntry) async {
    try {
      await _firestore
          .collection(_moodEntriesCollection)
          .doc(moodEntry.id)
          .update(moodEntry.toFirestore());
    } catch (e) {
      throw Exception('Failed to update mood entry: $e');
    }
  }

  static Future<void> deleteMoodEntry(String moodEntryId) async {
    try {
      await _firestore
          .collection(_moodEntriesCollection)
          .doc(moodEntryId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete mood entry: $e');
    }
  }

  // Analytics Operations
  static Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
    try {
      final now = DateTime.now();
      final last30Days = now.subtract(const Duration(days: 30));
      
      final moodEntries = await getMoodEntriesForDateRange(userId, last30Days, now);
      
      if (moodEntries.isEmpty) {
        return {
          'totalEntries': 0,
          'averageMood': 0.0,
          'moodDistribution': {},
          'commonFactors': [],
        };
      }

      final totalEntries = moodEntries.length;
      final averageMood = moodEntries.fold<double>(
        0.0,
        (sum, entry) => sum + entry.mood.value,
      ) / totalEntries;

      final moodDistribution = <String, int>{};
      final factorCount = <String, int>{};

      for (final entry in moodEntries) {
        // Count mood distribution
        final moodName = entry.mood.name;
        moodDistribution[moodName] = (moodDistribution[moodName] ?? 0) + 1;

        // Count factors
        for (final factor in entry.factors) {
          factorCount[factor] = (factorCount[factor] ?? 0) + 1;
        }
      }

      // Get top 5 factors
      final sortedFactors = factorCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final commonFactors = sortedFactors.take(5).map((e) => e.key).toList();

      return {
        'totalEntries': totalEntries,
        'averageMood': averageMood,
        'moodDistribution': moodDistribution,
        'commonFactors': commonFactors,
      };
    } catch (e) {
      throw Exception('Failed to get user analytics: $e');
    }
  }

  // Backup Operations
  static Future<void> backupUserData(String userId) async {
    try {
      final batch = _firestore.batch();
      
      // Create backup collection
      final backupRef = _firestore
          .collection('user_backups')
          .doc(userId)
          .collection('backup_${DateTime.now().millisecondsSinceEpoch}');

      // Backup user data
      final user = await getUser(userId);
      if (user != null) {
        batch.set(backupRef.doc('user'), user.toFirestore());
      }

      // Backup messages
      final messages = await getMessages(userId, limit: 1000);
      for (int i = 0; i < messages.length; i++) {
        batch.set(backupRef.doc('message_$i'), messages[i].toFirestore());
      }

      // Backup mood entries
      final moodEntries = await getMoodEntries(userId, limit: 1000);
      for (int i = 0; i < moodEntries.length; i++) {
        batch.set(backupRef.doc('mood_$i'), moodEntries[i].toFirestore());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to backup user data: $e');
    }
  }

  // Cleanup Operations
  static Future<void> cleanupOldData() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 365));
      
      // Delete old messages
      final oldMessages = await _firestore
          .collection(_messagesCollection)
          .where('timestamp', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      final batch = _firestore.batch();
      for (final doc in oldMessages.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to cleanup old data: $e');
    }
  }
}

