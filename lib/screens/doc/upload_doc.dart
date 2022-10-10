import 'package:flutter/material.dart';

class UploadDoc extends StatefulWidget {
  const UploadDoc({super.key});

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: noFileWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.file_upload_rounded,
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
                Icons.file_upload_rounded,
                size: 75,
              ),
            ),
            const SizedBox(height: 20),
            const Text("No file to show, tap to add file")
          ],
        ),
      ),
    );
  }
}
