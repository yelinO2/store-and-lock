import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:store_and_lock/constant/file_list.dart';
import 'package:store_and_lock/services/database_service.dart';
import 'package:store_and_lock/services/upload_files.dart';
import 'package:store_and_lock/widgets/widgets.dart';

class UploadAudio extends StatefulWidget {
  const UploadAudio({super.key});

  @override
  State<UploadAudio> createState() => _UploadAudioState();
}

class _UploadAudioState extends State<UploadAudio> {
  Stream<QuerySnapshot>? audio;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String collection = 'audio';
  String path = "audio";

  getAudio() {
    DatabaseService().getFiles(uid, collection).then((value) {
      setState(() {
        audio = value;
      });
    });
  }

  @override
  void initState() {
    getAudio();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Files')),
      body: showFiles(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickAudio();
        },
        child: GestureDetector(
          onTap: () => pickAudio(),
          child: const Icon(
            Icons.audio_file_rounded,
            size: 30,
          ),
        ),
      ),
    );
  }

  Future pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.audio,
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
                Icons.audio_file_rounded,
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

  showFiles() {
    return StreamBuilder(
      stream: audio,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                String fileName = snapshot.data!.docs[index]['fileName'];
                final String fullPath = snapshot.data!.docs[index]['fullPath'];

                print("fullPath from upload audio--------------------");
                print(fullPath);

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
