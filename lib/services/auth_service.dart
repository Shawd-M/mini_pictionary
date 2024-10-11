import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserToFirestore(String userId, String username) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'username': username,
    });
    print("Utilisateur ajouté à Firestore avec succès !");
  } catch (e) {
    print("Erreur lors de l'ajout de l'utilisateur à Firestore : $e");
  }
}
