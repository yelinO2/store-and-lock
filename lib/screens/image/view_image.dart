import 'package:flutter/material.dart';

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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
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
