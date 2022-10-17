import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../services/database_service.dart';

class FilesPage extends StatefulWidget {
  final List<PlatformFile> platformFiles;
  final ValueChanged<PlatformFile> onOpenedFile;
  final String path;
  final String collection;
  const FilesPage({
    super.key,
    required this.platformFiles,
    required this.onOpenedFile,
    required this.collection,
    required this.path,
  });

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doc Files'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => uploadFiles(widget.platformFiles),
            child: const Text(
              "Upload",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: widget.platformFiles.length,
          itemBuilder: (context, index) {
            final platformFile = widget.platformFiles[index];

            return buildFile(platformFile);
          },
        ),
      ),
    );
  }

  Widget buildFile(PlatformFile file) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final fileSize =
        mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = file.extension ?? 'none';
    // final color = getColor(extension);

    return InkWell(
      onTap: () => widget.onOpenedFile(file),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '.$extension',
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              file.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fileSize,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future uploadFiles(List<PlatformFile> platformFiles) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String path = widget.path;
    String collection = widget.collection;
    for (var platformFile in platformFiles) {
      final file = File(platformFile.path!);
      DatabaseService().uploadFile(
        uid,
        path,
        file,
        collection,
        platformFile.name,
      );
    }
  }
}
