import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_pic/Controller/user_controller.dart';
import '../Controller/auth_controller.dart';
import '../Model/user.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  ProfilState createState() => ProfilState();
}

class ProfilState extends State<ProfilScreen> {
  final UserController _user= UserController();
  String _image = "https://i.pinimg.com/564x/86/76/4b/86764b1a79732b1adc2c0210400d1baa.jpg";
  int _level = 0;
  String _pseudo = "";
  String _userID = "";

  void getUser() async {
    
    User user = await _user.getUserLog();
    setState(() {
      _image = user.img;
      _level = user.level;
      _pseudo = user.pseudo;
      _userID = user.userID;
    });
  }

  void init() {
    getUser();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 125.0,
                width: 125.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(62.5),
                    image: DecorationImage(
                        image: NetworkImage(_image), fit: BoxFit.cover)
                ),
              ),
              IconButton(
                icon: const Icon(Icons.photo_camera),
                onPressed: () => uploadImage(),
              ),
              Text(
                _pseudo,
                style: const TextStyle(fontFamily: 'Montserrat', color: Colors.black, fontSize: 15),
              ),
              Text(
                'Level : $_level',
                style: const TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
              ),
              buildContenus("Partie(s) jouée(s)"),
              buildContenus("Partie(s) gagnée(s)"),
            ],
          )
        ],
      ),
    );
  }

  Widget buildContenus(pcontext) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                pcontext + ":",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 15.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  uploadImage() async {
    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

      var snapshot = await storage
          .ref()
          .child('profilePicture/$_userID')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _image = downloadUrl;
      });

      _user.updatePicture(downloadUrl);
  }
}
