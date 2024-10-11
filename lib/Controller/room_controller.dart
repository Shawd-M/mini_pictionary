import '../Model/room.dart';
import '../Controller/auth_controller.dart';
import '../services/room_service.dart';

class RoomController {
  final AuthController _auth = AuthController();
  final RoomService _room = RoomService();

  createRoom(name, password, private) async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      var roomId = await _room.create(name, password, private);
      return roomId;
    }
  }

  getAllRoom() async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      List<Room> roomList = await _room.readAll();
      return roomList;
    }
  }

  joinRoom(roomId) async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      bool join = await _room.joinRoom(roomId);
      return join;
    }
  }

  leaveRoom(roomId) async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      bool join = await _room.leaveRoom(roomId);
      return join;
    }
  }

  play(roomId) async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      bool join = await _room.startRoom(roomId);
      return join;
    }
  }
}
