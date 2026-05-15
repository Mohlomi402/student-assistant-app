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

class AdminViewModel extends ChangeNotifier {

  final supabase = Supabase.instance.client;

  // =====================================================
  // DATA
  // =====================================================
  List<Map<String, dynamic>> applications = [];

  bool isLoading = false;

  // =====================================================
  // COUNTS
  // =====================================================
  int get pendingCount =>
      applications.where((app) =>
      (app['status'] ?? '')
          .toString()
          .toLowerCase() ==
          'pending').length;

  int get approvedCount =>
      applications.where((app) =>
      (app['status'] ?? '')
          .toString()
          .toLowerCase() ==
          'approved').length;

  // =====================================================
  // FETCH APPLICATIONS
  // =====================================================
  Future<void> fetchApplications() async {

    try {

      isLoading = true;

      notifyListeners();

      final response = await supabase
          .from('applications')
          .select()
          .order('created_at',
          ascending: false);

      applications =
          List<Map<String, dynamic>>
              .from(response);

    } catch (e) {

      debugPrint(
        "ADMIN FETCH ERROR: $e",
      );

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }

  // =====================================================
  // UPDATE STATUS
  // =====================================================
  Future<void> updateStatus(

      int id,
      String status,

      ) async {

    try {

      await supabase
          .from('applications')
          .update({

        'status': status,

      }).eq('id', id);

      await fetchApplications();

    } catch (e) {

      debugPrint(
        "STATUS UPDATE ERROR: $e",
      );
    }
  }
}