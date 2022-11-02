import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:store_and_lock/constant/file_list.dart';
import 'package:store_and_lock/widgets/widgets.dart';
import 'package:store_and_lock/services/upload_files.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_and_lock/services/database_service.dart';

class UploadDoc extends StatefulWidget {
  const UploadDoc({super.key});

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  Stream<QuerySnapshot>? docs;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String collection = 'Documents';

  getDoc() {
    DatabaseService().getFiles(uid, collection).then((value) {
      setState(() {
        docs = value;
      });
    });
  }

  @override
  void initState() {
    getDoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: showDocs(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickFiles();
        },
        child: GestureDetector(
          onTap: () => pickFiles(),
          child: const Icon(
            Icons.file_upload_rounded,
            size: 30,
          ),
        ),
      ),
    );
  }

  showDocs() {
    return StreamBuilder(
        stream: docs,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String docName = snapshot.data!.docs[index]['fileName'];
                  final Uri url =
                      Uri.parse(snapshot.data!.docs[index]['downloadURL']);

                  return FileList(fileName: docName, url: url);
                },
              );
            } else {
              return noFileWidget();
            }
          } else {
            return const Center(child: loadingSpinkit);
          }
        });
  }

  Future pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        "pdf",
        "doc",
        "docx",
        "html",
        "htm",
        "xls",
        "xlsx",
        "txt",
        "ppt",
        "pptx",
        "odp",
        "key",
      ],
    );
    if (result == null) return;

    openFiles(result.files);
  }

  void openFiles(List<PlatformFile> files) => nextScreen(
      context,
      UploadFiles(
        platformFiles: files,
        onOpenedFile: openFile,
        path: "Documents",
        collection: "Documents",
      ));

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
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
            const Text(
              "No file to show, tap to add file",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
