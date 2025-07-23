import 'dart:math';
import '../models/message_model.dart';

class AIService {
  // Response banks
  final List<String> _supportiveResponses = [
    "I understand you're going through a difficult time. Would you like to talk about what's troubling you?",
    "It's completely normal to feel this way. Many people experience similar emotions.",
    "Thank you for sharing that with me. How long have you been feeling this way?",
    "That sounds really challenging. You're being very brave by reaching out.",
    "I'm here to listen. What would be most helpful for you right now?",
    "It's okay to not be okay. Taking care of your mental health is important.",
    "Your feelings are valid. Would you like to explore some coping strategies?",
  ];

  final List<String> _anxietyResponses = [
    "Anxiety can feel overwhelming, but you're not alone. Let's try some breathing exercises together.",
    "When you feel anxious, try the 5-4-3-2-1 technique: name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, and 1 you can taste.",
    "Progressive muscle relaxation can help with anxiety. Would you like me to guide you through it?",
    "Remember, anxiety is temporary. This feeling will pass. What usually helps you feel calmer?",
    "Have you tried mindfulness meditation? It can be very effective for managing anxiety.",
  ];

  final List<String> _stressResponses = [
    "Stress is a normal part of life, but it's important to manage it effectively. What's causing you the most stress right now?",
    "Let's break down your stressors into manageable pieces. What feels most urgent to you?",
    "Taking regular breaks and practicing self-care can help reduce stress. What do you do to relax?",
    "Time management and prioritization can help reduce overwhelm. Would you like some strategies?",
    "Physical exercise is a great stress reliever. Even a short walk can make a difference.",
  ];

  final List<String> _depressionResponses = [
    "I'm sorry you're feeling this way. Depression is a serious condition, but it's treatable.",
    "You've taken an important step by reaching out. That shows strength and courage.",
    "Even small steps forward are progress. What's one small thing you could do today for yourself?",
    "Building a routine can help with depression. What does a typical day look like for you?",
    "Connecting with others is important. Do you have supportive people in your life?",
  ];

  final List<String> _generalMentalHealthTips = [
    "Regular sleep, exercise, and healthy eating can significantly impact your mental health.",
    "Practicing gratitude daily can help shift your perspective and improve mood.",
    "Setting boundaries is important for your mental wellbeing. It's okay to say no.",
    "Journaling can be a helpful way to process emotions and track your progress.",
    "Remember that seeking help is a sign of strength, not weakness.",
  ];

  // Keyword banks with improved matching
  final List<String> _crisisKeywords = [
    'suicide',
    'kill myself',
    'end it all',
    'not worth living',
    'hurt myself',
    'self harm',
    'die',
    'death',
    'hopeless',
    'worthless'
  ];

  final List<String> _anxietyKeywords = [
    'anxious',
    'anxiety',
    'panic',
    'worried',
    'nervous',
    'overwhelmed',
    'stressed'
  ];

  final List<String> _depressionKeywords = [
    'depressed',
    'sad',
    'down',
    'hopeless',
    'empty',
    'worthless',
    'tired'
  ];

  final List<String> _stressKeywords = [
    'stressed',
    'overwhelmed',
    'pressure',
    'burden',
    'too much',
    'exhausted'
  ];

  final Random _random = Random();

  /// Generates an appropriate response based on user input and conversation history
  Future<String> generateResponse(
      String userMessage, List<Message> conversationHistory) async {
    // Simulate API delay with proper random calculation
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    final lowerMessage = userMessage.toLowerCase();

    // Check for crisis keywords first (highest priority)
    if (_containsKeywords(lowerMessage, _crisisKeywords)) {
      return _generateCrisisResponse();
    }

    // Check for specific mental health topics
    if (_containsKeywords(lowerMessage, _anxietyKeywords)) {
      return _getRandomResponse(_anxietyResponses);
    }

    if (_containsKeywords(lowerMessage, _depressionKeywords)) {
      return _getRandomResponse(_depressionResponses);
    }

    if (_containsKeywords(lowerMessage, _stressKeywords)) {
      return _getRandomResponse(_stressResponses);
    }

    // General supportive responses for emotional expressions
    if (_isEmotionalExpression(lowerMessage)) {
      return _getRandomResponse(_supportiveResponses);
    }

    // Provide mental health tips when asked for help
    if (_isAskingForHelp(lowerMessage)) {
      return _getRandomResponse(_generalMentalHealthTips);
    }

    // Default response based on conversation context
    return _generateContextualResponse(userMessage, conversationHistory);
  }

  /// Generates a crisis response with emergency resources
  String _generateCrisisResponse() {
    return "I'm concerned about your safety. Please reach out to a mental health professional immediately. "
        "In the US, you can call 988 (Suicide & Crisis Lifeline) or text HOME to 741741 (Crisis Text Line). "
        "Would you like me to connect you with a counsellor right now?";
  }

  /// Returns a random response from the provided list
  String _getRandomResponse(List<String> responses) {
    return responses[_random.nextInt(responses.length)];
  }

  /// Checks if the message contains any of the provided keywords
  bool _containsKeywords(String message, List<String> keywords) {
    return keywords.any((keyword) => message
        .contains(RegExp(r'\b' + keyword + r'\b', caseSensitive: false)));
  }

  /// Determines if the message appears to be an emotional expression
  bool _isEmotionalExpression(String message) {
    final emotionalKeywords = [
      'feeling',
      'feel',
      'emotional',
      'upset',
      'happy',
      'sad',
      'angry',
      'frustrated'
    ];
    return _containsKeywords(message, emotionalKeywords);
  }

  /// Determines if the message is asking for help or advice
  bool _isAskingForHelp(String message) {
    final helpKeywords = [
      'help',
      'advice',
      'what should i do',
      'how can i',
      'suggestions',
      'tips'
    ];
    return _containsKeywords(message, helpKeywords);
  }

  /// Generates a response based on conversation context
  String _generateContextualResponse(
      String userMessage, List<Message> history) {
    // Filter only user messages from history
    final userMessages = history.where((msg) => msg.isUser).toList();

    if (userMessages.isEmpty) {
      return "I'm here to listen and support you. What would you like to talk about today?";
    }

    // If user is engaging regularly, provide encouragement
    if (userMessages.length > 3) {
      "💙 You Are Not Alone"
          "I know things feel heavy right now, and I want you to know:"
          "Your feelings matter. It’s okay to not be okay. You don’t have to carry this weight alone."
          "Take a deep breath with me. Inhale… exhale…"
          "You’ve survived every hard day so far, even when it didn’t feel like you could. That’s proof of your strength, even if it doesn’t feel that way today."
          "This pain won’t last forever. Like clouds passing, emotions shift and change. For now, just be kind to yourself. Rest if you need to. Cry if you need to. You’re human, and that’s more than enough."
          "If you can, try one small act of care:"
          "☕ Sip a warm drink"
          "📞 Text someone who loves you"
          "🌱 Step outside for 60 seconds"
          "You matter more than you know."
          "I’m here, and I believe in you.";
    }

    // Check if this is a follow-up to a previous topic
    final lastUserMessage = userMessages.last;
    if (_containsKeywords(
        lastUserMessage.text.toLowerCase(), _anxietyKeywords)) {
      return "You mentioned feeling anxious earlier. How is that feeling now?";
    }

    if (_containsKeywords(
        lastUserMessage.text.toLowerCase(), _depressionKeywords)) {
      return "You shared some feelings of depression before. Would you like to talk more about that?";
    }

    // Default supportive response
    return "Take a deep breath with me. Inhale… exhale…"
        "You’ve survived every hard day so far, even when it didn’t feel like you could. That’s proof of your strength, even if it doesn’t feel that way today.";
  }

  /// Returns a list of coping strategies
  List<String> getCopingStrategies() {
    return [
      "Deep breathing exercises (4-7-8 technique)",
      "Progressive muscle relaxation",
      "Mindfulness meditation",
      "Journaling your thoughts and feelings",
      "Physical exercise or movement",
      "Listening to calming music",
      "Talking to a trusted friend or family member",
      "Engaging in a hobby you enjoy",
      "Taking a warm bath or shower",
      "Practicing gratitude",
    ];
  }

  /// Returns a list of emergency contacts
  List<String> getEmergencyContacts() {
    return [
      "National Suicide Prevention Lifeline: 988",
      "Crisis Text Line: Text HOME to 741741",
      "National Alliance on Mental Illness: 1-800-950-NAMI (6264)",
      "SAMHSA National Helpline: 1-800-662-4357",
      "International Association for Suicide Prevention: https://www.iasp.info/resources/Crisis_Centres/",
    ];
  }
}
