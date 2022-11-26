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
    String? fullPath;

    Reference ref =
        FirebaseStorage.instance.ref().child('$uid/$path').child(fileName);

    await ref.putFile(file);

    downloadURL = await ref.getDownloadURL();
    fullPath = ref.fullPath;
    await firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection(collection)
        .doc(fileName)
        .set({
      'fileName': fileName,
      'downloadURL': downloadURL,
      'fullPath': fullPath
    });
  }

  Future<void> deleteFiles(String uid, String fullPath, String collectionPath,
      String docName) async {
    final ref = storageRef.child(fullPath);
   
   
    print('this is fullPath from database service >>>>>>>>>>>>');
    print(fullPath);

    await ref.delete().whenComplete(() => userCollection
        .doc(uid)
        .collection(collectionPath)
        .doc(docName)
        .delete());
  }

  Future getFiles(String uid, String collection) async {
    return userCollection.doc(uid).collection(collection).snapshots();
  }
}
