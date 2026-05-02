import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dklrl3bz7';
  static const String uploadPreset = 'mindmatch';

  Future<String> uploadImage(File imageFile) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..folder = 'mind_match_avatars'
      ..files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Cloudinary upload failed: $responseBody');
    }

    final data = jsonDecode(responseBody);
    return data['secure_url'];
  }
}

extension on http.MultipartRequest {
  set folder(String value) {
    fields['folder'] = value;
  }
}
