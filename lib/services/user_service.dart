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