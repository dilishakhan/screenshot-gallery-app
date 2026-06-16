import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'duhi6s6fb';
  static const String uploadPreset = 'screenshot_gallery';

  static Future<String?> uploadImage(Uint8List imageBytes) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString());

      return data['secure_url'];
    }

    return null;
  }
}
