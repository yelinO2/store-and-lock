import 'package:flutter/material.dart';

class OpenImage extends StatefulWidget {
  final String url;
  final int heroTag;
  const OpenImage({
    super.key,
    required this.url,
    required this.heroTag,
  });

  @override
  State<OpenImage> createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo'),
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
