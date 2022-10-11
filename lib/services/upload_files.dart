import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:store_and_lock/services/database_service.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  PlatformFile? pickedFile;
  bool uploading = false;
  List<File> files = [];
  double val = 0;
  String collection = 'images';
  UploadTask? uploadTask;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Files'),
        actions: [
          TextButton(
            onPressed: () {
              uploadImage();
            },
            child: const Text(
              'Upload',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: GridView.builder(
              itemCount: files.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            !uploading ? selectImage() : null;
                          },
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(files[index - 1]),
                              fit: BoxFit.cover),
                        ),
                      );
              },
            ),
          ),
          uploading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Uploading.....'),
                      const SizedBox(height: 10),
                      CircularProgressIndicator(
                        value: val,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Future selectImage() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    if (result == null) {
      return;
    } else {
      setState(() {
        files = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  Future uploadImage() async {
    int i = 1;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    for (var file in files) {
      setState(() {
        val = i / files.length;
      });
      final path = Path.basename(file.path).toString();
      DatabaseService().uploadFile(uid, path, file, collection);
    }
  }
}
