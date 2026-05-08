import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/application_model.dart';

class ApplicationViewModel extends ChangeNotifier {

  final SupabaseClient supabase =
      Supabase.instance.client;

  List<ApplicationModel> _applications = [];

  List<ApplicationModel> get applications =>
      _applications;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchApplications() async {

    try {

      _isLoading = true;
      notifyListeners();

      final response = await supabase
          .from('applications')
          .select();

      _applications = (response as List)
          .map((item) =>
              ApplicationModel.fromMap(item))
          .toList();

    } catch (e) {

      debugPrint(e.toString());

    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> addApplication(
      ApplicationModel application) async {

    try {

      await supabase
          .from('applications')
          .insert(application.toMap());

      await fetchApplications();

    } catch (e) {

      debugPrint(e.toString());
    }
  }
  Future<void> updateApplication(
    String id,
    ApplicationModel application,
  ) async {

    try {

      await supabase
          .from('applications')
          .update(application.toMap())
          .eq('id', id);

      await fetchApplications();

    } catch (e) {

      debugPrint(e.toString());
    }
  }

  Future<void> deleteApplication(
      String id) async {

    try {

      await supabase
          .from('applications')
          .delete()
          .eq('id', id);

      await fetchApplications();

    } catch (e) {

      debugPrint(e.toString());
    }
  }
  Future<void> updateStatus(
      String id,
      String status) async {

    try {

      await supabase
          .from('applications')
          .update({
            'status': status,
          })
          .eq('id', id);

      await fetchApplications();

    } catch (e) {

      debugPrint(e.toString());
    }
  }
}
