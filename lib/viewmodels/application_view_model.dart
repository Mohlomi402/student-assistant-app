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

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicationViewModel extends ChangeNotifier {

  final supabase = Supabase.instance.client;

  // =====================================================
  // APPLICATION LIST
  // =====================================================
  List<Map<String, dynamic>> applications = [];

  bool isLoading = false;

  // =====================================================
  // FETCH MY APPLICATIONS
  // =====================================================
  Future<void> fetchMyApplications() async {

    try {

      isLoading = true;
      notifyListeners();

      final user =
          supabase.auth.currentUser;

      if (user == null) {

        isLoading = false;
        notifyListeners();

        return;
      }

      final response = await supabase
          .from('applications')
          .select()
          .eq('user_id', user.id)
          .order(
            'created_at',
            ascending: false,
          );

      applications =
          List<Map<String, dynamic>>
              .from(response);

    } catch (e) {

      debugPrint(
        "FETCH APPLICATION ERROR: $e",
      );

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // SUBMIT APPLICATION
  // =====================================================
  Future<bool> submitApplication( {

  required String module1,
  required String module1Level,
  String? module2,
  String? module2Level,
  required String yearLevel,

  required Uint8List cvBytes,
  required String fileName,

}) async {

  try {

    isLoading = true;
    notifyListeners();

    final user = supabase.auth.currentUser;

    if (user == null) {

      debugPrint("NO USER LOGGED IN");

      isLoading = false;
      notifyListeners();

      return false;
    }

    // =========================================
    // CHECK EXISTING APPLICATION
    // =========================================
    final existing = await supabase
        .from('applications')
        .select()
        .eq('user_id', user.id);

    if (existing.isNotEmpty) {

      debugPrint(
        "USER ALREADY HAS APPLICATION",
      );

      isLoading = false;
      notifyListeners();

      return false;
    }

    // =========================================
    // CREATE FILE NAME
    // =========================================
    final safeFileName = fileName.trim();
    final uniqueFileName =
    "${DateTime.now().millisecondsSinceEpoch}_$safeFileName";

    // =========================================
    // UPLOAD FILE
    // =========================================
    await supabase.storage
        .from('cv-documents')
        .uploadBinary(
          uniqueFileName,
          cvBytes,
        );

    // =========================================
    // GET FILE URL
    // =========================================
    final fileUrl = supabase.storage
        .from('cv-documents')
        .getPublicUrl(uniqueFileName);

    // =========================================
    // INSERT APPLICATION
    // =========================================
    await supabase
        .from('applications')
        .insert({

      'user_id': user.id,

      'module1': module1,

      'module1_level': module1Level,

      'module2': module2,

      'module2_level': module2Level,

      'year_level': yearLevel,

      'cv_url': fileUrl,

      'status': 'pending',
    });

    // =========================================
    // REFRESH
    // =========================================
    await fetchMyApplications();

    isLoading = false;
    notifyListeners();

    return true;

  } catch (e) {

    debugPrint(
      "SUBMIT APPLICATION ERROR: $e",
    );

    isLoading = false;
    notifyListeners();

    return false;
  }
}
  // =====================================================
  // UPDATE APPLICATION
  // =====================================================
  Future<bool> updateApplication({

    required int id,

    required String module1,

    required String module1Level,

    String? module2,

    String? module2Level,

    required String yearLevel,

  }) async {

    try {

      await supabase
          .from('applications')
          .update({

        'module1': module1,

        'module1_level': module1Level,

        'module2': module2,

        'module2_level': module2Level,

        'year_level': yearLevel,

      })
          .eq('id', id);

      await fetchMyApplications();

      debugPrint(
        "APPLICATION UPDATED",
      );

      return true;

    } catch (e) {

      debugPrint(
        "UPDATE APPLICATION ERROR: $e",
      );

      return false;
    }
  }

  // =====================================================
  // DELETE APPLICATION
  // =====================================================
  Future<void> deleteApplication(
    int id,
  ) async {

    try {

      await supabase
          .from('applications')
          .delete()
          .eq('id', id);

      await fetchMyApplications();

      debugPrint(
        "APPLICATION DELETED",
      );

    } catch (e) {

      debugPrint(
        "DELETE APPLICATION ERROR: $e",
      );
    }
  }

  // =====================================================
  // ADMIN - FETCH ALL APPLICATIONS
  // =====================================================
  Future<List<Map<String, dynamic>>>
      fetchAllApplications() async {

    try {

      final response = await supabase
          .from('applications')
          .select()
          .order(
            'created_at',
            ascending: false,
          );

      return List<Map<String, dynamic>>
          .from(response);

    } catch (e) {

      debugPrint(
        "ADMIN FETCH ERROR: $e",
      );

      return [];
    }
  }

  // =====================================================
  // ADMIN - UPDATE STATUS
  // =====================================================
  Future<void> updateApplicationStatus(
  dynamic id,
  String status,
) async {

  try {

    await supabase
        .from('applications')
        .update({
          'status': status,
        })
        .eq('id', id);

    await fetchAllApplications();

  } catch (e) {

    debugPrint(
      "STATUS UPDATE ERROR: $e",
    );
  }
}
}