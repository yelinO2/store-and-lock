import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:store_and_lock/widgets/widgets.dart';

import 'file_page.dart';

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
        onPressed: () async {
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
        },
        child: const Icon(
          Icons.file_upload_rounded,
          size: 30,
        ),
      ),
    );
  }

  void openFiles(List<PlatformFile> files) => nextScreen(
      context,
      FilesPage(
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
            const Text("No file to show, tap to add file")
          ],
        ),
      ),
    );
  }
}
