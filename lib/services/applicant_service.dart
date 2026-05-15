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

import 'superbase_service.dart';

class ApplicationService {

  final client = SupabaseService.client;

  Future<void> createApplication({
    required String studentId,
    required String yearLevel,

    required String module1,
    required String module1Level,

    String? module2,
    String? module2Level,

    required String cvUrl,
  }) async {

    await client.from('applications').insert({
      'student_id': studentId,
      'year_level': yearLevel,

      'module1': module1,
      'module1_level': module1Level,

      'module2': module2,
      'module2_level': module2Level,

      'cv_url': cvUrl,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getApplications(String studentId) async {
    final res = await client
        .from('applications')
        .select()
        .eq('student_id', studentId);

    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> deleteApplication(int id) async {
    await client.from('applications').delete().eq('id', id);
  }
}