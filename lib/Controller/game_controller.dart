import '../Controller/auth_controller.dart';
import '../Service/game_service.dart';

class GameController {
  final AuthController _auth = AuthController();
  final GameService _game = GameService();

  saveByteData(data) async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      var roomId = await _game.saveByteData(data);
      return roomId;
    }
  }
}
