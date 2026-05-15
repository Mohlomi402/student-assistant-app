//Members
// 220044173 Mohlomi_T
// 221013252 Kwetle_ME
// 221019628 Makhetha_L
// 223008010 Brits_T
// 221008431 Choane SRT
// 221003714 Leeuw SA
// 221027626 Mokhele M
// 223043312 Choeu TM
// 223038645 Ndlovu N

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {

  final supabase = Supabase.instance.client;

  String? currentUserEmail;
  String? errorMessage;

  bool isLoading = false;
  bool sessionChecked = false;
  bool isLoggedIn = false;

  String role = 'student';

  // =====================================================
  // LOGIN
  // =====================================================
  Future<bool> login(
    String email,
    String password,
  ) async {

    try {

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response =
          await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {

        isLoading = false;
        errorMessage = "Invalid login details";
        notifyListeners();
        return false;
      }

      currentUserEmail = user.email;

      final userData = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      role = (userData['role'] ?? 'student')
          .toString()
          .toLowerCase();

      isLoggedIn = true;
      sessionChecked = true;

      isLoading = false;
      notifyListeners();

      return true;

    } catch (e) {

      isLoading = false;
      errorMessage = e.toString();

      notifyListeners();

      return false;
    }
  }

  // =====================================================
  // SESSION CHECK
  // =====================================================
  Future<void> checkSession() async {

    try {

      final user = supabase.auth.currentUser;

      if (user == null) {

        isLoggedIn = false;
        sessionChecked = true;
        notifyListeners();
        return;
      }

      isLoggedIn = true;
      currentUserEmail = user.email;

      final userData = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      role = (userData['role'] ?? 'student')
          .toString()
          .toLowerCase();

      sessionChecked = true;

      notifyListeners();

    } catch (e) {

      isLoggedIn = false;
      sessionChecked = true;
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  // =====================================================
  // LOGOUT
  // =====================================================
  Future<void> logout(BuildContext context) async {

    await supabase.auth.signOut();

    isLoggedIn = false;
    role = 'student';
    sessionChecked = false;

    notifyListeners();

    Navigator.pushReplacementNamed(
      context,
      '/login',
    );
  }
  Future<bool> register({
  required String firstName,
  required String lastName,
  required String email,
  required String password,
  required String confirmPassword,
}) async {

  try {

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // ❌ safety check (extra protection)
    if (password != confirmPassword) {
      errorMessage = "Passwords do not match";
      isLoading = false;
      notifyListeners();
      return false;
    }

    // ===============================
    // 1. CREATE AUTH USER (SUPABASE)
    // ===============================
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      errorMessage = "Registration failed";
      isLoading = false;
      notifyListeners();
      return false;
    }

    // ===============================
    // 2. INSERT INTO USERS TABLE
    // ===============================
    await supabase.from('users').insert({
      'uuid': user.id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': 'student',
    });

    isLoading = false;
    notifyListeners();

    return true;

  } catch (e) {

    isLoading = false;
    errorMessage = e.toString();
    notifyListeners();

    return false;
  }
}
}