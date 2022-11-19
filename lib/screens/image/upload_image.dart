import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:store_and_lock/screens/image/select_image.dart';
import 'package:store_and_lock/screens/image/view_image.dart';
import 'package:store_and_lock/services/database_service.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:store_and_lock/widgets/widgets.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  Stream<QuerySnapshot>? images;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String collection = 'images';

  getImages() {
    DatabaseService().getFiles(uid, collection).then((value) {
      setState(() {
        images = value;
      });
    });
  }

  @override
  void initState() {
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Images')),
      body: showImages(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nextScreen(context, const SelectImage());
        },
        child: const Icon(
          Icons.add_photo_alternate_rounded,
          size: 30,
        ),
      ),
    );
  }

  showImages() {
    return StreamBuilder(
        stream: images,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.all(3),
                child: GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    String url = snapshot.data!.docs[index]['downloadURL'];
                    String fileName = snapshot.data!.docs[index]['fileName'];
                    return Hero(
                      tag: "image $index",
                      child: FocusedMenuHolder(
                        menuWidth: MediaQuery.of(context).size.width * 0.5,
                        menuItems: [
                          FocusedMenuItem(
                            title: const Text("Downdoad"),
                            trailingIcon: const Icon(
                              Icons.download_for_offline,
                              color: Colors.black,
                            ),
                            onPressed: () => showSnackBar(
                                context, Colors.grey, 'Downloading....'),
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
                                        showSnackBar(context, Colors.red,
                                            'Item deleted');
                                        Navigator.pop(context);
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
                        onPressed: () {
                          nextScreen(
                              context,
                              ViewImage(
                                fileName: fileName,
                                url: url,
                                heroTag: index,
                              ));
                        },
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return noFileWidget();
            }
          } else {
            return const Center(child: loadingSpinkit);
          }
        });
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
              onTap: () => nextScreen(context, const SelectImage()),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                size: 75,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "No image to show, tap to add image",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
