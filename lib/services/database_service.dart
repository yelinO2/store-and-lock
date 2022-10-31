import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  UploadTask? uploadTask;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future savingUserData(
    String userName,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      'fullName': userName,
      'email': email,
      'uid': uid,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();

    return snapshot;
  }

  Future uploadFile(String uid, String path, dynamic file, String collection,
      String fileName) async {
    String? downloadURL;
    Reference ref =
        FirebaseStorage.instance.ref().child('$uid/$path').child(fileName);

    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    downloadURL = await snapshot.ref.getDownloadURL();
    await firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection(collection)
        .add({'fileName': fileName, 'downloadURL': downloadURL});

    uploadTask = null;
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 50,
            );
          }
        },
      );

  Future getImages(String uid) async {
    return userCollection.doc(uid).collection("images").snapshots();
  }

  Future getFiles(String uid, String collection) async {
    return userCollection.doc(uid).collection(collection).snapshots();
  }
}
