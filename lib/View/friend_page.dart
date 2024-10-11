import 'package:flutter/material.dart';
import 'package:my_pic/Controller/user_controller.dart';
import 'package:my_pic/View/chat_page.dart';
import 'package:my_pic/View/wait_page.dart';
import '../Controller/room_controller.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  FriendState createState() => FriendState();
}

class FriendState extends State<FriendScreen> {
  final RoomController _room = RoomController();
  final UserController _user = UserController();
  List friendList = [];
  String code = '';

  void getFriends() async {
    List getFriend = await _user.getFriends();
    setState(() {
      friendList = getFriend;
    });
  }

  void init() {
    getFriends();
  }

  Future<bool> joinGame(id) async {
    var join = await _room.joinRoom(id);
    return join;
  }

  bool checkSecretCode(roomPassword) {
    if (code == roomPassword) {
      return true;
    }
    return false;
  }
  
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              const Spacer(flex: 2),
              Center(
                child: Card(
                  child: SizedBox(
                    width: 300,
                    height: 400,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0xFFB3EFB2)
                      ),
                      child: Center(
                      child: ListView.builder(
                        itemCount: friendList.length,
                        itemBuilder: (_, int index) {
                          return Card(
                            child: ListTile(
                            onTap: () {
                              if (friendList[index]["userId"].isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => 
                                  ChatScreen(
                                    contactID: friendList[index]["userId"],
                                    contactPseudo: friendList[index]["pseudo"],
                                    contactImg: friendList[index]["img"],
                                  )
                                ));
                              }
                            },
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(62.5),
                                  image: DecorationImage(
                                      image: NetworkImage(friendList[index]["img"]), fit: BoxFit.cover)
                              ),
                            ),
                            title: Text(friendList[index]["pseudo"]),
                          )
                        );
                      })
                    ),
                    ),
                  ),
                ),
              ),
               ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFFB3EFB2)),
                  ),
                  child: const Text('Refresh', style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    getFriends();
                  },
                ),
              const Spacer(),
            ],
          ),
        ),
    );
  }
}