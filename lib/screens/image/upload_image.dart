import 'package:flutter/material.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Images')),
      body: noFileWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add_photo_alternate_rounded,
          size: 30,
        ),
      ),
    );
  }

  noFileWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                size: 75,
              ),
            ),
            const SizedBox(height: 20),
            const Text("No image to show, tap to add image")
          ],
        ),
      ),
    );
  }
}
