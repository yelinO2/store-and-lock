import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final storageRef = FirebaseStorage.instance.ref();

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

    await ref.putFile(file);

    downloadURL = await ref.getDownloadURL();
    await firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection(collection)
        .doc(fileName)
        .set({'fileName': fileName, 'downloadURL': downloadURL});
  }

  Future deleteFile(
    String uid,
    String path,
    String fileName,
    String collection,
    String doc,
  ) async {
    final ref = storageRef.child('$uid/$path/$fileName');

    await ref.delete().whenComplete(
        () => userCollection.doc(uid).collection(collection).doc(doc).delete());
  }

  Future getFiles(String uid, String collection) async {
    return userCollection.doc(uid).collection(collection).snapshots();
  }
}
