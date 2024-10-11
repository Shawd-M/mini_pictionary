import 'package:cloud_firestore/cloud_firestore.dart';

class GameService {
  final database = FirebaseFirestore.instance;

  saveByteData(data) async {
    await database.collection("game").doc("game2").set({
      'byte': data,
    });
  }
}