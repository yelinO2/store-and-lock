import 'package:flutter/material.dart';
import 'package:store_and_lock/widgets/widgets.dart';

class FileList extends StatefulWidget {
  final String fileName;
  const FileList({super.key, required this.fileName});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
}
