
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../widgets/gradient_background.dart';
import 'gallery_screen.dart';
import 'package:screenshot_gallery/services/cloudinary_service.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalImages = 0;

  @override
  void initState() {
    super.initState();
    loadImageCount();
  }

  Future<void> loadImageCount() async {
    final count = await FirestoreService.getImageCount();

    setState(() {
      totalImages = count;
    });
  }

  Future<void> uploadImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result == null) return;

    final bytes = result.files.single.bytes;

    if (bytes == null) return;

    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Uploading image...')));

      final imageUrl = await CloudinaryService.uploadImage(bytes);

      if (imageUrl == null) {
        throw Exception('Upload failed');
      }

      await FirestoreService.saveScreenshot(
        title: result.files.single.name,
        description: '',
        imageUrl: imageUrl,
      );

      await loadImageCount();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        const Icon(
                          Icons.photo_library_rounded,
                          size: 90,
                          color: Colors.indigo,
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Screenshot Manager",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Manage and organize your screenshots effortlessly",
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 35),

                        Container(
                          width: 400,
                          height: 200,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),

                            border: Border.all(color: Colors.indigo, width: 2),
                          ),

                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Icon(
                                Icons.cloud_upload_rounded,
                                size: 70,
                                color: Colors.indigo,
                              ),

                              SizedBox(height: 15),

                              Text(
                                "Supported Formats",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text("JPG • JPEG • PNG"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        ElevatedButton.icon(
                          onPressed: uploadImage,

                          icon: const Icon(Icons.upload),

                          label: const Text("Upload Screenshot"),
                        ),

                        const SizedBox(height: 25),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              const Icon(Icons.image, color: Colors.indigo),

                              const SizedBox(width: 10),

                              Text(
                                "Total Images : $totalImages",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        FilledButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GalleryScreen(),
                              ),
                            );

                            loadImageCount();
                          },

                          icon: const Icon(Icons.photo_library),

                          label: const Text("View Gallery"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
