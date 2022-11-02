import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:store_and_lock/widgets/widgets.dart';

import '../../services/database_service.dart';

class UploadFiles extends StatefulWidget {
  final List<PlatformFile> platformFiles;
  final ValueChanged<PlatformFile> onOpenedFile;
  final String path;
  final String collection;
  const UploadFiles({
    super.key,
    required this.platformFiles,
    required this.onOpenedFile,
    required this.collection,
    required this.path,
  });

  @override
  State<UploadFiles> createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
  bool upload = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Files'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              uploadFiles(widget.platformFiles);
              setState(() {
                upload = true;
              });
            },
            child: const Text(
              "Upload",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
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
          upload
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      uploadSpinkit,
                      SizedBox(height: 10),
                      uploadingText,
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget buildFile(PlatformFile file) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final fileSize =
        mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = file.extension ?? 'none';

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
      DatabaseService()
          .uploadFile(
        uid,
        path,
        file,
        collection,
        platformFile.name,
      ).whenComplete(() {
        setState(() {
          upload = false;
        });
        showSnackBar(context, Colors.greenAccent, "Upload Complete");
        Navigator.pop(context);
      });
    }
  }
}
