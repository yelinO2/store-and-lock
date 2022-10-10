import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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

  Future uploadFile(String uid, String path, dynamic file) async {
    final postID = DateTime.now().microsecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('$uid/$path')
        .child('post_$postID');
    await ref.putFile(file);
  }
}
