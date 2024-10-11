import 'package:cloud_firestore/cloud_firestore.dart';
import '../Controller/auth_controller.dart';
import '../Controller/user_controller.dart';
import '../Model/room.dart';
import '../Model/user.dart';

class RoomService {
  final AuthController _auth = AuthController();
  final UserController _user = UserController();
  final database = FirebaseFirestore.instance;

  create(name, password, private) async {
    dynamic userID = await _auth.getUserId();
    User user = await _user.getUserLog();
    await database.collection("room").doc(name + userID).set({
      'name': name,
      'private': private,
      'play': false,
      'password': password,
      'host': userID,
    });
    await database.collection("room").doc(name + userID).collection("players").doc(userID).set({
      'userID': user.userID,
      'email': user.email,
      'pseudo': user.pseudo,
      'level': user.level,
      'img': user.img,
    });
    return name + userID;
  }

  Future readAll() async {
    List<Room> roomlist = [];
    await database.collection("room").get().then((res) {
      for (var element in res.docs) {
        final data = element.data();
        roomlist.add(
          Room(data["name"], data["private"], data["play"], data["password"], data["host"])
        );
      }
    });
    return(roomlist);
  }

  Future joinRoom(roomId) async {
    dynamic userID = await _auth.getUserId();
    User user = await _user.getUserLog();

    await database.collection("room").doc(roomId).collection("players").doc(userID).set({
      'userID': user.userID,
      'email': user.email,
      'pseudo': user.pseudo,
      'level': user.level,
      'img': user.img,
    });

    return true;
  }

  Future leaveRoom(roomId) async {
    dynamic userID = await _auth.getUserId();
    await database.collection("room").doc(roomId).collection("players").doc(userID).delete();

    await database.collection("room").doc(roomId).collection("players").get().then((res) {
      if (res.docs.isEmpty) {
        database.collection("room").doc(roomId).delete();
      }
    });

    return true;
  }

  Future startRoom(roomId) async {
    await database.collection("room").doc(roomId).update({
      'play': true
    });

    return true;
  }
}
