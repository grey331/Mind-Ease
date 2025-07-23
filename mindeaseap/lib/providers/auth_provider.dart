import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      final userName = prefs.getString('user_name');
      final userPhone = prefs.getString('user_phone');
      final isPremium = prefs.getBool('is_premium') ?? false;

      if (userEmail != null && userName != null) {
        _user = User(
          id: prefs.getString('user_id') ?? '',
          email: userEmail,
          name: userName,
          phone: userPhone,
          isPremium: isPremium,
        );
        _isAuthenticated = true;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock authentication - in real app, this would be an API call
      if (email.isNotEmpty && password.isNotEmpty) {
        _user = User(
          id: '1',
          email: email,
          name: email.split('@')[0],
          phone: null,
          isPremium: false,
        );
        _isAuthenticated = true;

        // Save to local storage
        await _saveUserSession();

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock registration - in real app, this would be an API call
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        _user = User(
          id: '1',
          email: email,
          name: name,
          phone: null,
          isPremium: false,
        );
        _isAuthenticated = true;

        // Save to local storage
        await _saveUserSession();

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'All fields are required';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _user = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> upgradeToParticipant() async {
    if (_user != null) {
      _user = _user!.copyWith(isPremium: true);
      await _saveUserSession();
      notifyListeners();
    }
  }

  Future<void> _saveUserSession() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _user!.id);
      await prefs.setString('user_email', _user!.email);
      await prefs.setString('user_name', _user!.name);
      if (_user!.phone != null) {
        await prefs.setString('user_phone', _user!.phone!);
      }
      await prefs.setBool('is_premium', _user!.isPremium);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
