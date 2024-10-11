import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final database = FirebaseFirestore.instance;

  readChat(String chatRoomId) async {
    return database
        .collection("messages")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData) async {
    await database
        .collection("messages")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData);
  }
}
