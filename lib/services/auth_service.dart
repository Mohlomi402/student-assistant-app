import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:student_assistant_app/services/superbase_service.dart';

class AuthService {

  // LOGIN
  Future<AuthResponse> login(
      String email,
      String password,
      ) async {

    return await SupabaseService.client.auth
        .signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  // REGISTER
  Future<AuthResponse> register(
      String email,
      String password,
      ) async {

    return await SupabaseService.client.auth
        .signUp(
      email: email.trim(),
      password: password,
    );
  }

  // LOGOUT
  Future<void> logout() async {

    await SupabaseService.client.auth.signOut();
  }

  // CURRENT USER ID
  String? get currentUserId =>
      SupabaseService.client.auth.currentUser?.id;

  // CURRENT USER EMAIL
  String? get currentUserEmail =>
      SupabaseService.client.auth.currentUser?.email;
}