import 'package:flutter/material.dart';
import 'package:store_and_lock/constant/icon_menu.dart';

import 'package:store_and_lock/widgets/widgets.dart';

class ViewImage extends StatefulWidget {
  final String url;
  final int heroTag;
  final String fileName;
  const ViewImage(
      {super.key,
      required this.url,
      required this.heroTag,
      required this.fileName});

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
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
                  showSnackBar(context, Colors.grey, 'Downleading...');
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
                              showSnackBar(context, Colors.red, 'Item deleted');
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
      body: Center(
        child: Hero(
          tag: "image ${widget.heroTag}",
          child: Image.network(
            widget.url,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
