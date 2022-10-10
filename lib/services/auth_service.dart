import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_and_lock/helper/helper_funs.dart';
import 'package:store_and_lock/services/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUser(String userName, String email, String password) async {
    try {
      User? newUser = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (newUser != null) {
        await DatabaseService(uid: newUser.uid).savingUserData(userName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future loggedIn(String email, String password) async {
    try {
      User? newUser = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (newUser != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedinStatus(false);
      await HelperFunctions.saveUserEmail('');
      await HelperFunctions.saveUsername('');
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
