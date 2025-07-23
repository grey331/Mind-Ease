import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final String userId;
  final String? sessionId;
  final Map<String, dynamic>? metadata;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.userId,
    this.type = MessageType.text,
    this.sessionId,
    this.metadata,
  });

  Message copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    MessageType? type,
    String? userId,
    String? sessionId,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.name,
      'userId': userId,
      'sessionId': sessionId,
      'metadata': metadata ?? {},
    };
  }

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      text: data['text'] ?? '',
      isUser: data['isUser'] ?? false,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.text,
      ),
      userId: data['userId'] ?? '',
      sessionId: data['sessionId'],
      metadata: data['metadata'],
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, text: $text, isUser: $isUser, timestamp: $timestamp, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum MessageType {
  text,
  image,
  audio,
  video,
  file,
  system,
  suggestion,
}

