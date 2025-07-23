import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  bool _darkMode = false;
  bool _notifications = true;
  String _language = 'en';
  bool _isLoading = false;
  String? _error;

  bool get darkMode => _darkMode;
  bool get notifications => _notifications;
  String get language => _language;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserProvider() {
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
      _language = prefs.getString('language') ?? 'en';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode() async {
    _darkMode = !_darkMode;
    notifyListeners();
    await _saveUserSettings();
  }

  Future<void> toggleNotifications() async {
    _notifications = !_notifications;
    notifyListeners();
    await _saveUserSettings();
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    notifyListeners();
    await _saveUserSettings();
  }

  Future<void> _saveUserSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('dark_mode', _darkMode);
      await prefs.setBool('notifications', _notifications);
      await prefs.setString('language', _language);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

