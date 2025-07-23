import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "your-api-key",
        authDomain: "mindease-app.firebaseapp.com",
        projectId: "mindease-app",
        storageBucket: "mindease-app.appspot.com",
        messagingSenderId: "123456789",
        appId: "1:123456789:web:abcdef123456",
        measurementId: "G-XXXXXXXXXX",
      ),
    );
  }
}

