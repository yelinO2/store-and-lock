import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:store_and_lock/services/upload_files.dart';
import 'package:store_and_lock/widgets/widgets.dart';

class UploadVideos extends StatefulWidget {
  const UploadVideos({super.key});

  @override
  State<UploadVideos> createState() => _UploadVideosState();
}

class _UploadVideosState extends State<UploadVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video files')),
      body: noFileWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.video,
          );
          if (result == null) return;
          openFiles(result.files);
        },
        child: const Icon(
          Icons.video_collection_outlined,
          size: 30,
        ),
      ),
    );
  }

  void openFiles(List<PlatformFile> files) => nextScreen(
      context,
      UploadFiles(
        platformFiles: files,
        onOpenedFile: openFile,
        path: "videos",
        collection: "videos",
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
                Icons.video_file,
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
