import 'package:student_assistant_app/services/superbase_service.dart';

class ApplicationService {

  // CREATE APPLICATION
  Future<void> createApplication({
    required String studentId,
    required String firstName,
    required String lastName,
    required String email,
    required String yearLevel,
    required List<String> modules,
  }) async {

    await SupabaseService.client
        .from('applications')
        .insert({
      'student_id': studentId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'year_level': yearLevel,
      'modules': modules.join(', '),
      'status': 'Pending',
    });
  }

  // READ APPLICATIONS
  Future<List<Map<String, dynamic>>> getApplications(
      String studentId) async {

    final response = await SupabaseService.client
        .from('applications')
        .select()
        .eq('student_id', studentId);

    return List<Map<String, dynamic>>.from(response);
  }

  // ADMIN - GET ALL
  Future<List<Map<String, dynamic>>> getAllApplications() async {

    final response = await SupabaseService.client
        .from('applications')
        .select();

    return List<Map<String, dynamic>>.from(response);
  }

  // UPDATE STATUS
  Future<void> updateStatus({
    required int id,
    required String status,
  }) async {

    await SupabaseService.client
        .from('applications')
        .update({
      'status': status,
    }).eq('id', id);
  }

  // DELETE
  Future<void> deleteApplication(int id) async {

    await SupabaseService.client
        .from('applications')
        .delete()
        .eq('id', id);
  }
}