import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_pic/View/game_page.dart';
import '../Controller/auth_controller.dart';
import '../Controller/room_controller.dart';

class WaitingScreen extends StatefulWidget {
  final String idRoom;
  final bool isHost;

  const WaitingScreen(this.idRoom, {super.key, required this.isHost});

  @override
  JoinState createState() => JoinState();
}

class JoinState extends State<WaitingScreen> {
  final RoomController _room = RoomController();
  final AuthController _auth = AuthController();
  String userID = "";
  List<String> playerListId = [];
  late Stream<QuerySnapshot> room;
  late Stream<QuerySnapshot> doc;
  bool host = false;

  void init() async {
    await _auth.getUserId().then((data) => {
      setState(() {
        userID = data;
      })
    });
  }

  @override
  void initState() {
    init();
    final id = widget.idRoom;
    if (!widget.isHost) {
    FirebaseDatabase(databaseURL: "https://joseph-d-pictionis-default-rtdb.firebaseio.com/").ref().child('room/$id/active').onValue.listen((DatabaseEvent event) {
      Object? data = event.snapshot.value;
      if (data != null) {
        Map<String, dynamic> dataArray = jsonDecode(jsonEncode(data));
        if (dataArray['play']) {
          toGame();
        }
      }
    });
    }
    room = FirebaseFirestore.instance.collection('room').doc(id).collection("players").snapshots();
    super.initState();
  }

  void initdata(List<QueryDocumentSnapshot<Object?>> data) async {
    playerListId = [];
    data.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      playerListId.add(data['userID']);
    }).toList();
  }

  void toGame() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GameScreen(roomId: widget.idRoom, playerListId: playerListId, isHost: widget.isHost,)));
  }

  Widget userFetch() {
    return StreamBuilder<QuerySnapshot>(
      stream: room,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        initdata(snapshot.data!.docs);
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['pseudo']),
              subtitle: Text(data['pseudo']),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              const Spacer(),
              Center(
                child: Card(
                  child: SizedBox(
                    width: 300,
                    height: 500,
                    child: Center(
                      child: userFetch()
                    ),
                  ),
                ),
              ),
              Center(
                child: Row(
                  children: <Widget>[
                    const Spacer(),
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                      ),
                      child: const Text('Quitter', style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        bool leave = await _room.leaveRoom(widget.idRoom);
                        if (leave) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    
                    const Spacer(),
                    if (widget.isHost)
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                        ),
                        child: const Text('Jouer', style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          bool start = await _room.play(widget.idRoom);
                          if (start) {
                            // Navigator.of(context).pop();
                            final ref = FirebaseDatabase(databaseURL: "https://pictionis-1a293-default-rtdb.europe-west1.firebasedatabase.app").ref();
                            final id = widget.idRoom;
                            ref.child('room/$id/active').update({
                              'play': true,
                            });
                            toGame();
                          }
                        },
                      ),
                    const Spacer(),
                  ]
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
    );
  }
}
