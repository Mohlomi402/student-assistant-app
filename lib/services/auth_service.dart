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

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:student_assistant_app/services/superbase_service.dart';

class AuthService {

  Future<AuthResponse> login(
      String email,
      String password,
      ) async {

    try {

      return await SupabaseService.client.auth
          .signInWithPassword(
        email: email.trim(),
        password: password,
      );

    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future<AuthResponse> register(
      String email,
      String password,
      ) async {

    try {

      return await SupabaseService.client.auth
          .signUp(
        email: email.trim(),
        password: password,
      );

    } catch (e) {
      throw Exception("Register failed: $e");
    }
  }

  Future<void> logout() async {
    await SupabaseService.client.auth.signOut();
  }

  String? get currentUserId =>
      SupabaseService.client.auth.currentUser?.id;

  String? get currentUserEmail =>
      SupabaseService.client.auth.currentUser?.email;
}