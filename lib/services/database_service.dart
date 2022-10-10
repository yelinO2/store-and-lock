import 'package:cloud_firestore/cloud_firestore.dart';

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
      'group': [],
      'profilePic': '',
      'uid': uid,
    });
  }
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();

    return snapshot;
  }
}
