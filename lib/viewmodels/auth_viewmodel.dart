import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class AuthViewModel extends ChangeNotifier {

  
  // SERVICES
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isLoggedIn =>
      _authService.currentUserId != null;

  String? get currentUserEmail =>
      _authService.currentUserEmail;

  String? get currentUserId =>
      _authService.currentUserId;

  // LOGIN

  Future<bool> login(
      String email,
      String password,
      ) async {

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {

      final response =
      await _authService.login(
        email,
        password,
      );

      return response.user != null;

    } catch (e) {

      _errorMessage = e.toString();

      return false;

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================
  // REGISTER
  // =========================
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    String role = 'student',
  }) async {

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {

      // PASSWORD VALIDATION
      if (password != confirmPassword) {

        _errorMessage =
        "Passwords do not match";

        return false;
      }

      // CREATE AUTH ACCOUNT
      final response =
      await _authService.register(
        email,
        password,
      );

      final user = response.user;

      if (user == null) {

        _errorMessage =
        "Registration failed";

        return false;
      }

      // CREATE USER PROFILE
      await _userService.createUserProfile({

        'id': user.id,

        'first_name': firstName,

        'last_name': lastName,

        'email': email.trim(),

        'role': role,

        'created_at':
        DateTime.now().toIso8601String(),
      });

      return true;

    } catch (e) {

      _errorMessage = e.toString();

      return false;

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }

  Future<String?> getUserRole() async {

    try {

      final userId =
          _authService.currentUserId;

      if (userId == null) {
        return null;
      }

      return await _userService
          .getUserRole(userId);

    } catch (e) {

      return null;
    }
  }

  Future<void> logOut() async {

    await _authService.logout();

    notifyListeners();
  }
}