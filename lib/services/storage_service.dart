import 'package:shared_preferences/shared_preferences.dart';

import '../models/image_item.dart';

class StorageService {
  static const String key = "gallery_images";

  static Future<List<ImageItem>> getImages() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(key);

    if (data == null) {
      return [];
    }

    return ImageItem.decode(data);
  }

  static Future<void> saveImages(List<ImageItem> images) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, ImageItem.encode(images));
  }
}
