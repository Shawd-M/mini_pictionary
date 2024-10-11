import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_pic/Controller/auth_controller.dart';
import '../Controller/chat_controller.dart';


class ChatScreen extends StatefulWidget {
  final String contactID;
  final String contactPseudo;
  final String contactImg;

  const ChatScreen({Key? key,required this.contactID, required this.contactPseudo, required this.contactImg}): super(key: key);

  @override
  State createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {
  final ChatController _chat = ChatController();
  final AuthController _auth = AuthController();

  TextEditingController messageEditingController = TextEditingController();
  String chatRoomId = "";
  String userID = "";
  String contactID = "";

  void init() async {
    await _auth.getUserId().then((data) => {
      setState(() {
        userID = data;
      })
    });

    setState(() {
      contactID = widget.contactID;
    });
    if (userID.hashCode <= contactID.hashCode) {
      chatRoomId = '$userID-$contactID';
    } else {
      chatRoomId = '$contactID-$userID';
    }
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("messages").doc(chatRoomId).collection("chats").orderBy('time').snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                        message: snapshot.data!.docs[index]["message"],
                        sendByMe: snapshot.data!.docs[index]["sendBy"] == userID ? true : false,
                      );
                    })
                  )
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": userID,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      _chat.createMessage(chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(62.5),
                  image: DecorationImage(
                      image: NetworkImage(widget.contactImg), fit: BoxFit.cover)
              ),
            ),
            Text(widget.contactPseudo),
          ]
          )
      ),
      body: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageEditingController,
                    decoration: const InputDecoration(
                      hintText: "Message ...",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      addMessage();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 66, 165, 245),
                                Color.fromARGB(255, 66, 165, 245),
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight),
                          borderRadius: BorderRadius.circular(40)),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  const MessageTile({super.key, required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [
                      const Color.fromARGB(255, 66, 165, 245),
                      const Color.fromARGB(220, 66, 165, 245),
                    ]
                  : [
                      const Color.fromRGBO(0, 155, 0, 1.0),
                      const Color.fromRGBO(0, 155, 0, 1.0),
                    ],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
