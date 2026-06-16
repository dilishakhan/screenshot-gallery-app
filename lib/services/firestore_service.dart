import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> saveScreenshot({
    required String title,
    required String description,
    required String imageUrl,
  }) async {
    await _db.collection('screenshots').add({
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'uploadedAt': Timestamp.now(),
    });
  }

  static Future<int> getImageCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('screenshots')
        .get();

    return snapshot.docs.length;
  }

  static Stream<QuerySnapshot> getScreenshots() {
    return _db
        .collection('screenshots')
        .orderBy('uploadedAt', descending: true)
        .snapshots();
  }

  static Future<void> deleteScreenshot(String docId) async {
    await _db.collection('screenshots').doc(docId).delete();
  }
}
