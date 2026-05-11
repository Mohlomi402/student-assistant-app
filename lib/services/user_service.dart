import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  // CREATE USER PROFILE
  Future<void> createUserProfile(Map<String, dynamic> data) async {
    await _client.from('users').insert(data);
  }

  // GET USER PROFILE
  Future<UserModel?> getUser(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;

    return UserModel.fromJson(response);
  }

  // GET USER ROLE
  Future<String?> getUserRole(String userId) async {
    final response = await _client
        .from('users')
        .select('role')
        .eq('id', userId)
        .maybeSingle();

    return response?['role'];
  }
}