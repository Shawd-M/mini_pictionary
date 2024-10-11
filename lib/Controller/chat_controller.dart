import 'package:my_pic/services/chat_service.dart';
import '../Controller/auth_controller.dart';

class ChatController {
  final AuthController _auth = AuthController();
  final ChatService _chat = ChatService();

  getChats(String chatRoomId) async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      return _chat.readChat(chatRoomId);
    }
  }

  createMessage(String chatRoomId, chatMessageData) async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      await _chat.addMessage(chatRoomId, chatMessageData);
    }
  }
}
