
import 'package:flutter/material.dart';
import 'package:my_pic/View/wait_page.dart';
import '../Controller/room_controller.dart';
import '../Model/room.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  JoinState createState() => JoinState();
}

class JoinState extends State<JoinScreen> {
  final RoomController _room = RoomController();
  List<Room> roomList = [];
  String code = '';

  void getAllRoom() async {
    List<Room> getRoom = await _room.getAllRoom();
    setState(() {
      roomList = getRoom;
    });
  }

  void init() {
    getAllRoom();
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
                        color: const Color(0xFFDABFFF)
                      ),
                      child: Center(
                      child: ListView.builder(
                        itemCount: roomList.length,
                        itemBuilder: (_, int index) {
                          return Card(
                            child: ListTile(
                            onTap: () {
                              var idRoom = roomList[index].name+roomList[index].host.toString();
                              if (roomList[index].private) {
                                privateDialog(roomList[index].pwd, idRoom);
                              } else {
                                joinGame(idRoom).then((value) =>
                                  {
                                    if (value) {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WaitingScreen(idRoom, isHost: false,)))
                                    }
                                  });
                                }
                            },
                            title: Text(roomList[index].name),
                            trailing: roomList[index].private ? const Icon(Icons.lock) : null,
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
                    backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFFDABFFF)),
                  ),
                  child: const Text('Refresh', style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    getAllRoom();
                  },
                ),
              const Spacer(),
            ],
          ),
        ),
    );
  }

  Future<void> privateDialog(roomPassword, idRoom) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Private Room"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code secret',
                    isDense: true,
                  ),
                  onChanged: (val) {
                    setState(() => code = val);
                  }
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confimer'),
              onPressed: () {
                bool validPassword = checkSecretCode(roomPassword);
                if (validPassword) {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WaitingScreen(idRoom, isHost: false,)));
                }
              },
            ),
          ],
        );
      },
    );
  }
}