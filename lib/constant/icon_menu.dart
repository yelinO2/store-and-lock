import 'package:flutter/material.dart';

class IconsMenu {
  static const items = <IconMenu>[
    download,
    delete,
  ];

  static const download = IconMenu(
    text: 'Download',
    icon: Icons.download_for_offline_outlined,
  );

  static const delete = IconMenu(
    text: 'Delete',
    icon: Icons.delete_outline,
  );
}

class IconMenu {
  final String text;
  final IconData icon;

  const IconMenu({required this.text, required this.icon});
}
