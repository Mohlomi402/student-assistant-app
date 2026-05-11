import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:student_assistant_app/services/superbase_service.dart';

class StorageService {

  // UPLOAD IMAGE
  Future<String> uploadImage({
    required String bucket,
    required XFile file,
  }) async {

    // Convert image to bytes
    final Uint8List fileBytes =
        await file.readAsBytes();

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

    // Upload image
    await SupabaseService.client.storage
        .from(bucket)
        .uploadBinary(fileName, fileBytes);

    // Get public URL
    final publicUrl = SupabaseService.client.storage
        .from(bucket)
        .getPublicUrl(fileName);

    return publicUrl;
  }

  // DELETE IMAGE
  Future<void> deleteImage({
    required String bucket,
    required String filePath,
  }) async {

    await SupabaseService.client.storage
        .from(bucket)
        .remove([filePath]);
  }
}