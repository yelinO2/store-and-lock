// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:store_and_lock/constant/icon_menu.dart';

import 'package:store_and_lock/widgets/widgets.dart';

import '../../services/database_service.dart';

class ViewImage extends StatefulWidget {
  final String url;
  final int heroTag;
  final String fileName;
  final String collectionPath;
  final String uid;
  final String fullPath;
  const ViewImage({
    super.key,
    required this.url,
    required this.heroTag,
    required this.fileName,
    required this.collectionPath,
    required this.fullPath,
    required this.uid,
  });

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  bool downloading = false;
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future download() async {
    await DatabaseService()
        .downloadFile(
      widget.fullPath,
      widget.fileName,
    )
        .whenComplete(() {
      setState(() {
        downloading = false;
      });
      showSnackBar(
        context,
        Colors.green,
        "${widget.fileName} downloaded successfully",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
        actions: [
          PopupMenuButton<IconMenu>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (value) {
              switch (value) {
                case IconsMenu.download:
                  download();
                  setState(() {
                    downloading = true;
                  });
                  break;
                case IconsMenu.delete:
                  showDialog(
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
                              await DatabaseService()
                                  .deleteFiles(
                                widget.uid,
                                widget.fullPath,
                                widget.collectionPath,
                                widget.fileName,
                              )
                                  .whenComplete(() {
                                showSnackBar(context, Colors.red,
                                    "Image deleted successfully");
                                Navigator.pop(context);
                              });
                              Navigator.pop(context);
                              setState(() {});
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
                  );
                  break;
              }
            },
            itemBuilder: (context) => IconsMenu.items
                .map(
                  (item) => PopupMenuItem<IconMenu>(
                    value: item,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(item.icon, color: Colors.white),
                      title: Text(
                        item.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: "image ${widget.heroTag}",
              child: Image.network(
                widget.url,
                fit: BoxFit.fill,
              ),
            ),
          ),
          downloading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      downloadSpinkit,
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
