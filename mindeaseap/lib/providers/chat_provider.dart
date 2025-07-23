import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../services/ai_service.dart';
import '../services/firebase_service.dart';

class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;
  final AIService _aiService = AIService();
  final Uuid _uuid = const Uuid();

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ChatProvider() {
    _initializeChat();
  }

  void _initializeChat() {
    // Load messages from Firebase when initializing
    loadMessages();
  }

  // Load messages from Firebase
  Future<void> loadMessages() async {
    if (FirebaseService.auth.currentUser == null) {
      _addWelcomeMessage();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = FirebaseService.auth.currentUser!.uid;
      final snapshot = await FirebaseService.firestore
          .collection('messages')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .limit(100) // Limit to recent messages
          .get();

      _messages.clear();
      
      if (snapshot.docs.isEmpty) {
        _addWelcomeMessage();
      } else {
        for (final doc in snapshot.docs) {
          final message = Message.fromFirestore(doc);
          _messages.add(message);
        }
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to load messages: $e';
      _addWelcomeMessage(); // Fallback to welcome message
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add welcome message
  void _addWelcomeMessage() {
    if (_messages.isEmpty) {
      _messages.add(Message(
        id: _uuid.v4(),
        text: "Hello! I'm your AI mental health companion. How are you feeling today?",
        isUser: false,
        timestamp: DateTime.now(),
        userId: FirebaseService.auth.currentUser?.uid ?? '',
      ));
      notifyListeners();
    }
  }

  // Send message with Firebase integration
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userId = FirebaseService.auth.currentUser?.uid ?? '';
    
    // Add user message
    final userMessage = Message(
      id: _uuid.v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      userId: userId,
    );
    
    _messages.add(userMessage);
    notifyListeners();

    // Save user message to Firebase
    if (userId.isNotEmpty) {
      try {
        await FirebaseService.firestore
            .collection('messages')
            .add(userMessage.toFirestore());
      } catch (e) {
        print('Failed to save user message: $e');
      }
    }

    // Set loading state
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get AI response
      final aiResponse = await _aiService.generateResponse(text, _messages);
      
      // Add AI response
      final aiMessage = Message(
        id: _uuid.v4(),
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        userId: userId,
      );
      
      _messages.add(aiMessage);
      
      // Save AI message to Firebase
      if (userId.isNotEmpty) {
        try {
          await FirebaseService.firestore
              .collection('messages')
              .add(aiMessage.toFirestore());
        } catch (e) {
          print('Failed to save AI message: $e');
        }
      }
      
    } catch (e) {
      _error = e.toString();
      // Add error message
      final errorMessage = Message(
        id: _uuid.v4(),
        text: "I'm sorry, I'm having trouble responding right now. Please try again.",
        isUser: false,
        timestamp: DateTime.now(),
        userId: userId,
      );
      _messages.add(errorMessage);
      
      // Save error message to Firebase
      if (userId.isNotEmpty) {
        try {
          await FirebaseService.firestore
              .collection('messages')
              .add(errorMessage.toFirestore());
        } catch (e) {
          print('Failed to save error message: $e');
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear chat (both local and Firebase)
  Future<void> clearChat() async {
    final userId = FirebaseService.auth.currentUser?.uid;
    
    // Clear local messages
    _messages.clear();
    
    // Clear Firebase messages
    if (userId != null) {
      try {
        final batch = FirebaseService.firestore.batch();
        final snapshot = await FirebaseService.firestore
            .collection('messages')
            .where('userId', isEqualTo: userId)
            .get();
        
        for (final doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
        
        await batch.commit();
      } catch (e) {
        print('Failed to clear chat from Firebase: $e');
      }
    }
    
    _initializeChat();
    notifyListeners();
  }

  // Get messages stream for real-time updates
  Stream<List<Message>> getMessagesStream() {
    if (FirebaseService.auth.currentUser == null) {
      return Stream.value([]);
    }

    final userId = FirebaseService.auth.currentUser!.uid;
    return FirebaseService.firestore
        .collection('messages')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromFirestore(doc))
            .toList());
  }

  // Delete specific message
  Future<void> deleteMessage(String messageId) async {
    try {
      await FirebaseService.firestore
          .collection('messages')
          .doc(messageId)
          .delete();

      _messages.removeWhere((message) => message.id == messageId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete message: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear data (for logout)
  void clearData() {
    _messages.clear();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  List<String> getSuggestedResponses() {
    return [
      "I'm feeling anxious today",
      "I need help with stress management",
      "I'm having trouble sleeping",
      "I feel overwhelmed with work",
      "I want to talk about my relationships",
      "I need some coping strategies",
    ];
  }

  bool shouldSuggestCounsellor() {
    // Logic to determine if user should be connected to a counsellor
    // based on message content, frequency, or severity
    final recentMessages = _messages.where(
      (msg) => msg.isUser && msg.timestamp.isAfter(
        DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ).length;

    return recentMessages > 10; // Example threshold
  }

  // Get chat statistics
  Map<String, int> getChatStatistics() {
    final userMessages = _messages.where((msg) => msg.isUser).length;
    final aiMessages = _messages.where((msg) => !msg.isUser).length;
    
    return {
      'userMessages': userMessages,
      'aiMessages': aiMessages,
      'totalMessages': _messages.length,
    };
  }
}

