import 'package:flutter/material.dart';
import 'package:store_and_lock/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class FileList extends StatefulWidget {
  final String fileName;
  final Uri url;
  const FileList({super.key, required this.fileName, required this.url});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => lauchURL(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor:
                getColor(widget.fileName.substring(0, 1).toLowerCase()),
            child: Text(
              textAlign: TextAlign.center,
              widget.fileName.substring(0, 1).toLowerCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            widget.fileName,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> lauchURL() async {
    final Uri url = widget.url;

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
