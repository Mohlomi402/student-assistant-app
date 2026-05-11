import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  SupabaseClient get _supabase => Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isLoggedIn {
    try {
      return _supabase.auth.currentSession != null;
    } catch (e) {
      return false;
    }
  }
  
  String? get currentUserEmail {
    try {
      return _supabase.auth.currentUser?.email;
    } catch (e) {
      return null;
    }
  }

  String? get currentUserId {
    try {
      return _supabase.auth.currentUser?.id;
    } catch (e) {
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
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

  
  Future<bool> register(String email, String password, {String role = 'student'}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
      );

      if (response.user != null) {
        await _supabase.from('users').insert({
          'id': response.user!.id,
          'email': email.trim(),
          'role': role, 
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      return response.user != null;
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
      final userId = currentUserId;
      if (userId == null) return null;
      
      final response = await _supabase
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();
      
      return response?['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<void> logOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }
}