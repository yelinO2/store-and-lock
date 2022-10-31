import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:store_and_lock/services/database_service.dart';

import '../../widgets/widgets.dart';

class SelectImage extends StatefulWidget {
  const SelectImage({super.key});

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  List<PlatformFile> platformFiles = [];
  bool upload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Images"),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                platformFiles.isEmpty
                    ? showSnackBar(context, Colors.red, 'No image selected!')
                    : setState(() {
                        upload = true;
                      });
                uploadImage();
              },
              child: const Text(
                'Upload',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: platformFiles.length + 1,
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                        ),
                      )
                    : Image.file(
                        File(platformFiles[index - 1].path!),
                        fit: BoxFit.cover,
                      );
              },
            ),
          ),
          upload
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      uploadSpinkit,
                      SizedBox(
                        height: 10,
                      ),
                      uploadingText,
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result == null) return;
    setState(() {
      platformFiles = result.files;
    });
  }

  Future uploadImage() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    const path = 'images';
    const collection = 'images';
    for (var platformFile in platformFiles) {
      final file = File(platformFile.path!);
      DatabaseService()
          .uploadFile(
        uid,
        path,
        file,
        collection,
        platformFile.name,
      )
          .whenComplete(() {
        setState(() {
          upload = false;
        });
        showSnackBar(context, Colors.greenAccent, "Upload Complete");
      });
    }
  }
}
