import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  loginWithEmail(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    return user != null;
  }

  registerWithEmail(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  getUserId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    dynamic result = auth.currentUser!;
    if (result != null) {
      return result.uid;
    } else {
      return null;
    }
  }

  logout() {
    _auth.signOut();
  }
}
