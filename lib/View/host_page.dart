// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_pic/View/test.dart';
import 'package:my_pic/View/wait_page.dart';
import '../Controller/room_controller.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  HostState createState() => HostState();
}

class HostState extends State<HostScreen> {

  String name = '';
  String code = '';
  String error = '';
  bool private = false;
  final RoomController _room = RoomController();
  var limit = [for (var i = 1; i <= 8; i++) i];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            const Spacer(),
            Center(
              child: Card(
                child: SizedBox(
                  width: 300,
                  height: 325,
                  child: Center(child: Form(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            width: 225,
                            height: 50,
                            child: Text(
                              'Créér une partie',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                           SizedBox(
                            width: 225, 
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nom de la salle',
                                isDense: true,
                              ),
                              onChanged: (val) {
                                setState(() => name = val);
                              }
                            ),
                          ),
                          const SizedBox(height: 25),
                          if (private)
                              SizedBox(
                                width: 225, 
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Code secret',
                                    isDense: true,
                                  ),
                                  onChanged: (val) {
                                    setState(() => code = val);
                                  }
                                ),
                              ),
                          SwitchListTile(
                            // This bool value toggles the switch.
                            title: const Text('Salle privée ?'),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
                            value: private,
                            activeColor: const Color(0xFF7FDEFF),
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                private = value;
                              });
                            },
                          ),
                          
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                            ),
                            child: const Text('Créer le salon', style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (name.isNotEmpty) {
                                var roomId = await createRoom();
                                final ref = FirebaseDatabase(databaseURL: "https://pictionis-1a293-default-rtdb.europe-west1.firebasedatabase.app").ref();
                                ref.child('room/$roomId/active').set({
                                  'play': false,
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WaitingScreen(roomId, isHost: true,)));
                              }
                            }
                          ),
                        ],
                      ),
                    ),
                  )),
                  ),
                ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
  
  createRoom() async {
    var roomId = await _room.createRoom(name, code, private);
    return roomId;
  }
}