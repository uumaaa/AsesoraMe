import 'dart:math';

import 'package:asispnia/model/counseling.dart';
import 'package:asispnia/pages/end_counseling_page.dart';
import 'package:asispnia/widgets/dialogs.dart';
import 'package:asispnia/widgets/message_widget.dart';
import 'package:asispnia/widgets/send_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../utils/logs.dart';
import '../utils/responsive.dart';
import '../widgets/change_theme_button.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String idChat;
  final String sender;
  final PrivateCounseling counseling;
  final bool canEnd;
  const ChatPage(
      {super.key,
      required this.userMap,
      required this.idChat,
      required this.sender,
      required this.counseling,
      required this.canEnd});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _storage = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool endCouseling = true;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": widget.sender,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };
      await _storage
          .collection("chatroom")
          .doc(widget.idChat)
          .collection("chats")
          .add(messages);
    }
    _message.clear();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    if (context.isLandscape) {
      return Container();
    } else {
      return verticalView(context, responsive, _storage, _message);
    }
  }

  Scaffold verticalView(BuildContext context, Responsive responsive,
          FirebaseFirestore _storage, TextEditingController _message) =>
      Scaffold(
        appBar: AppBar(
          title: Text("Chat con ${widget.userMap["username"]}"),
          actions: [
            widget.canEnd
                ? InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EndCounselingPage(
                            counseling: widget.counseling,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: responsive.wp(34),
                      height: responsive.hp(4),
                      child: Center(
                        child: Text(
                          "Finalizar asesoria",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
          backgroundColor: Theme.of(context).primaryColor,
          leading: CupertinoButton(
              child: Icon(
                CupertinoIcons.back,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.all(responsive.wp(3)),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _storage
                        .collection("chatroom")
                        .doc(widget.idChat)
                        .collection("chats")
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return Container(
                          width: responsive.wp(94),
                          height: responsive.hp(76),
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => MessageWidget(
                              text: snapshot.data!.docs[index]["message"],
                              time: snapshot.data!.docs[index]["time"],
                              isMine: snapshot.data!.docs[index]["sendby"] ==
                                  widget.sender,
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  SendMessageWidget(
                    controller: _message,
                    width: responsive.wp(94),
                    height: responsive.hp(6.5),
                    fontSize: responsive.dp(2),
                    function: onSendMessage,
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
