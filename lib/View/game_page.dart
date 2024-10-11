import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_pic/Controller/auth_controller.dart';

class GameScreen extends StatefulWidget {
  final String roomId;
  final List<String> playerListId;
  final bool isHost;

  const GameScreen({super.key, required this.roomId, required this.playerListId, required this.isHost});
  
  @override
  GameState createState() => GameState();
  
}

class GameState extends State<GameScreen> {
  final AuthController _auth = AuthController();
  
  Timer? timer;
  Color selectedColor = Colors.black;
  String userID = "";
  String selectedWord = "";
  String value = "";
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  List<DrawingPoint?> getPoint = [];
  List<Offset> getPoints = [];
  List<Color> colors = [
    Colors.black,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.yellow,
    Colors.purple,
    Colors.white,
  ];
  List<String> words = [
    "terrain",
    "grue",
    "jaguar",
    "yeux",
    "président",
  ];
  bool gamer = false;
  bool host = false;

  game(userId) async {
    final idRoom = widget.roomId;
    final ref = FirebaseDatabase(databaseURL: "https://joseph-d-pictionis-default-rtdb.firebaseio.com/").ref();
    ref.child('room/$idRoom/player').set({
      'userID': userId,
    });
  }

  void init() async {
    await _auth.getUserId().then((data) => {
      setState(() {
        userID = data;
        if (widget.isHost) {
          gamer = true;
        }
      })
    });
  }

  @override
  void initState() {
    var id = widget.roomId;
    init();
        FirebaseDatabase(databaseURL: "https://joseph-d-pictionis-default-rtdb.firebaseio.com/").ref().child('room/$id/points').onValue.listen((DatabaseEvent event) {
          Object? data = event.snapshot.value;
          if (data != null) {
              Map<String, dynamic> dataArray = jsonDecode(jsonEncode(data));
              if (dataArray["word"] == value) {
                  final ref = FirebaseDatabase(databaseURL: "https://joseph-d-pictionis-default-rtdb.firebaseio.com").ref();
                  ref.child('room/$id/active').update({
                    'play': true,
                  });
              }
          }
        });
        if (!gamer) {
          FirebaseDatabase(databaseURL: "https://joseph-d-pictionis-default-rtdb.firebaseio.com").ref().child('room/$id/points').onValue.listen((DatabaseEvent event) {
            Object? data = event.snapshot.value;
            if (data != null) {
              Map<String, dynamic> dataArray = jsonDecode(jsonEncode(data));
              var newmap = {};
              var keys = [...dataArray.keys]..sort((a, b) => a.compareTo(b));
              for (String key in keys) {
                newmap[key] = dataArray[key];
              }
              setState(() {
                drawingPoints = [];
                getPoint = [];
              });
              
              newmap.forEach((k,v) => {
                if (v["offset"] != "") {
                  getPoint.add(
                    DrawingPoint(
                      Offset(v["offset"][0], v["offset"][1]),
                      Paint()
                        // ..color = v["color"]
                        ..color = selectedColor
                        ..isAntiAlias = true
                        ..strokeWidth = strokeWidth
                    ),
                  )
                } else {
                  getPoint.add(null)
                }
              });
              drawingPoints = getPoint;
            }
          });
        // }
        }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          Card(
            child: SizedBox(
              height: 425,
              width: 500,
              child: gamer ? GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    drawingPoints.add(
                      DrawingPoint(
                        details.localPosition,
                        Paint()
                          ..color = selectedColor
                          ..isAntiAlias = true
                          ..strokeWidth = strokeWidth
                      ),
                    );
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    drawingPoints.add(
                      DrawingPoint(
                        details.localPosition,
                        Paint()
                          ..color = selectedColor
                          ..isAntiAlias = false
                          ..strokeWidth = strokeWidth
                      ),
                    );
                  });
                },
                // onPanEnd: (details) {
                //   setState(() {
                //     drawingPoints.add(null);
                //   });
                // },
                child: CustomPaint(
                  painter: _DrawingPainter(drawingPoints, gamer, widget.roomId),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ) : 
              CustomPaint(
                painter: _DrawingPainter(drawingPoints, gamer, widget.roomId),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
          if (gamer)
          Positioned(
            top: 40,
            right: 75,
            child: Row(
              children: [
                Slider(
                  min: 0,
                  max: 40,
                  value: strokeWidth,
                  onChanged: (val) => setState(() => strokeWidth = val),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => { drawingPoints = []}),
                  icon: const Icon(Icons.clear),
                  label: const Text("Tout effacer"),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => { wordSelectDialog() }),
                  icon: const Icon(Icons.clear),
                  label: const Text("Select word"),
                )
              ],
            ),
          ),
          Positioned(
            top: 25,
            right: 2,
            child: Container(
              width: 50,
              height: 410,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  colors.length,
                  (index) => _buildColorChose(colors[index]),
                ),
              ),
            ),
          ),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Entrez votre email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) {
                        setState(() => value = val);
                      }),
        ],
      ),
    )   
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }

  Future<void> wordSelectDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ecrivez un mot"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Votre mot',
                    isDense: true,
                  ),
                  onChanged: (val) {
                    setState(() => selectedWord = val);
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
                final idRoom = widget.roomId;
                final ref = FirebaseDatabase(databaseURL: "https://pictionis-1a293-default-rtdb.europe-west1.firebasedatabase.app").ref();
                ref.child('room/$idRoom/active').update({
                  'word': selectedWord,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;
  String roomId = "";
  bool gamer = false;

  _DrawingPainter(this.drawingPoints, this.gamer, this.roomId);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) async {
    for (int i = 0; i < drawingPoints.length; i++) {
      if (drawingPoints[i] != null && i != drawingPoints.length - 1 && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i]!.offset, drawingPoints[i + 1]!.offset,
            drawingPoints[i]!.paint);
      } else {
        if (drawingPoints[i] != null) {
          offsetsList.clear();
          offsetsList.add(drawingPoints[i]!.offset);
          canvas.drawPoints(PointMode.points, offsetsList, drawingPoints[i]!.paint);
        }
        
        if (gamer && drawingPoints[i] != null) {
            final ref = FirebaseDatabase(databaseURL: "https://pictionis-1a293-default-rtdb.europe-west1.firebasedatabase.app").ref();
            ref.child('room/$roomId/points').push().set({
              'offset': [drawingPoints[i]!.offset.dx, drawingPoints[i]!.offset.dy],
              'color': drawingPoints[i]!.paint.color.toString(),
            });
        } 
        else if (gamer) {
            final ref = FirebaseDatabase(databaseURL: "https://pictionis-1a293-default-rtdb.europe-west1.firebasedatabase.app").ref();
            ref.child('room/$roomId/points').push().set({
              'offset': "",
              'color': Colors.white.toString(),
            });  
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}