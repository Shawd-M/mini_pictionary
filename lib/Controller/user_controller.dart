import '../Controller/auth_controller.dart';
import '../Model/user.dart';
import '../services/user_service.dart';

class UserController {
  final UserService _user = UserService();
  final AuthController _auth = AuthController();

  createUser(email, pseudo) async {

    dynamic security = await _auth.getUserId();
    if (security != null) {
      await _user.create(email, pseudo);
    }
  }

  getUserLog() async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      User user = await _user.getCurrentUser();
      return (user);
    }
  }

  getUserById(id) async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      User user = await _user.getUserById(id);
      return (user);
    }
  }

  getFriends() async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      List friends = await _user.getFriends();
      return (friends);
    }
  }

  updatePicture(imgUrl) async {
    dynamic security = await _auth.getUserId();
    if (security != null) {
      await _user.updatePicture(imgUrl);
    }
  }
}