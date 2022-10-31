import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_and_lock/screens/image/select_image.dart';
import 'package:store_and_lock/screens/image/view_image.dart';
import 'package:store_and_lock/services/database_service.dart';

import 'package:store_and_lock/widgets/widgets.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  Stream<QuerySnapshot>? images;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  getImages() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseService().getImages(uid).then((value) {
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
                    return GestureDetector(
                      onTap: () {
                        nextScreen(
                            context,
                            OpenImage(
                              url: url,
                              heroTag: index,
                            ));
                      },
                      child: Hero(
                        tag: "image $index",
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
            return const Center(
              child: loadingSpinkit
            );
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
            const Text("No image to show, tap to add image")
          ],
        ),
      ),
    );
  }
}
