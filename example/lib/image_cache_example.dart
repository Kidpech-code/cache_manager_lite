import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

/// Example showing image caching scenario.
/// ตัวอย่างแสดงสถานการณ์การแคชรูปภาพ
class ImageCacheExample extends StatefulWidget {
  const ImageCacheExample({super.key});

  @override
  State<ImageCacheExample> createState() => _ImageCacheExampleState();
}

class _ImageCacheExampleState extends State<ImageCacheExample> {
  late final CacheManagerLite cacheManager;
  Uint8List? imageBytes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cacheManager = CacheManagerLite.medium(
      appType: AppType.social,
    );
  }

  Future<void> loadImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      final bytes = await cacheManager.getBytes(
        'https://picsum.photos/300/200',
        policy: CachePolicy(
          maxAge: Duration(hours: 12), // Custom policy for this image
        ),
      );
      setState(() {
        imageBytes = Uint8List.fromList(bytes);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Cache Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator()
            else if (imageBytes != null)
              Image.memory(
                imageBytes!,
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Text('No image loaded'),
            SizedBox(height: 20),
            ElevatedButton(onPressed: loadImage, child: Text('Load Image')),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await cacheManager.clear();
                setState(() {
                  imageBytes = null;
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cache cleared')),
                  );
                }
              },
              child: Text('Clear Cache'),
            ),
          ],
        ),
      ),
    );
  }
}
