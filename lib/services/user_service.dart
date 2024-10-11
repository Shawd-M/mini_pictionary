import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_pic/Model/user.dart';
import '../Controller/auth_controller.dart';

class UserService {
  final AuthController _auth = AuthController();
  final database = FirebaseFirestore.instance;

  create(email, pseudo) async {
    dynamic userID = await _auth.getUserId();
    await database.collection("user").doc(userID).set({
      'userID': userID,
      'email': email,
      'pseudo': pseudo,
      'level': 0,
      'img': "https://i.pinimg.com/564x/86/76/4b/86764b1a79732b1adc2c0210400d1baa.jpg",
    });
  }

  getCurrentUser() async {
    dynamic userID = await _auth.getUserId();
    dynamic result;

    await database.collection("user").doc(userID).get().then(
      (DocumentSnapshot doc) {
        result = doc.data() as Map<String, dynamic>;
      },
    );

    User user = User(result["userID"], result["email"], result["pseudo"], result["level"], result["img"]);
    return(user);
  }

  getUserById(id) async {
    dynamic result;

    await database.collection("user").doc(id).get().then(
      (DocumentSnapshot doc) {
        result = doc.data() as Map<String, dynamic>;
      },
    );

    User user = User(result["userID"], result["email"], result["pseudo"], result["level"], result["img"]);
    return(user);
  }

  getImgByUserId(id) async {
    dynamic result;

    await database.collection("user").doc(id).get().then(
      (DocumentSnapshot doc) {
        result = doc.data() as Map<String, dynamic>;
      },
    );

    return(result["img"]);
  }

  getFriends() async {
    dynamic userID = await _auth.getUserId();

    List friend = [];
    await database.collection("user").doc(userID).collection("friends").get().then((res) async {
      for (var element in res.docs) {
        final data = element.data();
        var img = await getImgByUserId(data["userId"]);
        data["img"] = img;
        friend.add(data);
      }
    });
    return(friend);
  }

  updatePicture(imgUrl) async {
    dynamic userID = await _auth.getUserId();
    await database
        .collection("user")
        .doc(userID)
        .update({'img': imgUrl});
  }
}
