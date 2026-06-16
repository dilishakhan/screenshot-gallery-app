import 'dart:convert';

class ImageItem {
  final String fileName;
  final String uploadDate;
  final String imageData;

  ImageItem({
    required this.fileName,
    required this.uploadDate,
    required this.imageData,
  });

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'uploadDate': uploadDate,
      'imageData': imageData,
    };
  }

  factory ImageItem.fromMap(Map<String, dynamic> map) {
    return ImageItem(
      fileName: map['fileName'],
      uploadDate: map['uploadDate'],
      imageData: map['imageData'],
    );
  }

  static String encode(List<ImageItem> images) {
    return jsonEncode(images.map((e) => e.toMap()).toList());
  }

  static List<ImageItem> decode(String data) {
    final decoded = jsonDecode(data) as List<dynamic>;

    return decoded.map((e) => ImageItem.fromMap(e)).toList();
  }
}
