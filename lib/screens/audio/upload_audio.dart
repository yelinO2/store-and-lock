import 'package:flutter/material.dart';

class UploadAudio extends StatefulWidget {
  const UploadAudio({super.key});

  @override
  State<UploadAudio> createState() => _UploadAudioState();
}

class _UploadAudioState extends State<UploadAudio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Files')),
      body: noFileWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.audio_file_rounded,
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
                Icons.audio_file_rounded,
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
