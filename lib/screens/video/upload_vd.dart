import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:store_and_lock/services/database_service.dart';
import 'package:store_and_lock/services/upload_files.dart';
import 'package:store_and_lock/widgets/widgets.dart';
import '../../constant/file_list.dart';

class UploadVideos extends StatefulWidget {
  const UploadVideos({super.key});

  @override
  State<UploadVideos> createState() => _UploadVideosState();
}

class _UploadVideosState extends State<UploadVideos> {
  Stream<QuerySnapshot>? video;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String collection = 'videos';
  String path = "videos";
  getVd() {
    DatabaseService().getFiles(uid, collection).then((value) {
      setState(() {
        video = value;
      });
    });
  }

  @override
  void initState() {
    getVd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video files')),
      body: displayFiles(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pickVd(),
        child: GestureDetector(
          onTap: () => pickVd(),
          child: const Icon(
            Icons.video_collection_outlined,
            size: 30,
          ),
        ),
      ),
    );
  }

  Future pickVd() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );
    if (result == null) return;
    openFiles(result.files);
  }

  void openFiles(List<PlatformFile> files) => nextScreen(
      context,
      UploadFiles(
        platformFiles: files,
        onOpenedFile: openFile,
        path: path,
        collection: collection,
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
            const Text(
              "No file to show, tap to add file",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  displayFiles() {
    return StreamBuilder(
      stream: video,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                String fileName = snapshot.data!.docs[index]['fileName'];
                final String fullPath = snapshot.data!.docs[index]['fullPath'];
                final Uri url =
                    Uri.parse(snapshot.data!.docs[index]['downloadURL']);
                return FileList(
                  uid: uid,
                  collectionPath: collection,
                  docName: fileName,
                  fullPath: fullPath,
                  fileName: fileName,
                  url: url,
                  path: path,
                );
              },
            );
          } else {
            return noFileWidget();
          }
        } else {
          return const Center(child: loadingSpinkit);
        }
      },
    );
  }
}
