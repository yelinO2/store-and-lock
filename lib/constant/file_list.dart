// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:store_and_lock/services/database_service.dart';
import 'package:store_and_lock/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class FileList extends StatefulWidget {
  final String path;
  final String fileName;
  final String collectionPath;
  final String docName;
  final Uri url;
  final String uid;
  final String fullPath;
  const FileList({
    super.key,
    required this.fileName,
    required this.url,
    required this.path,
    required this.collectionPath,
    required this.docName,
    required this.uid,
    required this.fullPath,
  });

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  Future delete() async {
    print("fullpath from file list <---------------------------->");
    print(widget.fullPath);

    await DatabaseService().deleteFiles(
      widget.uid,
      widget.fullPath,
      widget.collectionPath,
      widget.docName,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      menuWidth: MediaQuery.of(context).size.width * 0.5,
      menuItems: [
        FocusedMenuItem(
          title: const Text("Downdoad"),
          trailingIcon: const Icon(
            Icons.download_for_offline,
            color: Colors.black,
          ),
          onPressed: () =>
              showSnackBar(context, Colors.grey, 'Downloading....'),
        ),
        FocusedMenuItem(
          title: const Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
          trailingIcon: const Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'Delete permanently?',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await delete().whenComplete(() {
                        showSnackBar(
                          context,
                          Colors.red,
                          "Item deleted successfully",
                        );
                        Navigator.pop(context);
                      });
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
      blurBackgroundColor: Colors.blueGrey,
      menuOffset: 10,
      openWithTap: false,
      onPressed: () => lauchURL(),
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
