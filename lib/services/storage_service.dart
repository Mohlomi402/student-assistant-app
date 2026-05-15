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

import 'dart:io';
import 'package:student_assistant_app/services/superbase_service.dart';

class StorageService {
  static final _client = SupabaseService.client;

  static Future<String> uploadCV(File file, String userId) async {
    final fileName = "${userId}_${DateTime.now().millisecondsSinceEpoch}.pdf";

    await _client.storage
        .from('cv')
        .upload(fileName, file);

    final url = _client.storage
        .from('cv')
        .getPublicUrl(fileName);

    return url;
  }
}