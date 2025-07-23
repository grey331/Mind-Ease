import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final bool isPremium;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final String? profileImageUrl;
  final Map<String, dynamic>? preferences;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.isPremium = false,
    this.createdAt,
    this.lastLogin,
    this.profileImageUrl,
    this.preferences,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? profileImageUrl,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'isPremium': isPremium,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'profileImageUrl': profileImageUrl,
      'preferences': preferences ?? {},
    };
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      isPremium: data['isPremium'] ?? false,
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
      lastLogin: data['lastLogin'] != null ? (data['lastLogin'] as Timestamp).toDate() : null,
      profileImageUrl: data['profileImageUrl'],
      preferences: data['preferences'],
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, phone: $phone, isPremium: $isPremium)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

