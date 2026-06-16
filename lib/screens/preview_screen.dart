import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imageUrl;

  const PreviewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: Hero(
            tag: imageUrl,
            child: Image.network(
              imageUrl,

              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return const Center(child: CircularProgressIndicator());
              },

              errorBuilder: (context, error, stackTrace) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.white, size: 100),

                    SizedBox(height: 16),

                    Text(
                      "Failed to load image",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
