import 'package:asispnia/pages/accept_counseling_request_page.dart';
import 'package:asispnia/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/modules.dart';
import '../model/counseling.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';

class PrivateCardWidget extends StatefulWidget {
  const PrivateCardWidget({
    super.key,
    required this.responsive,
    required this.data,
  });
  final Responsive responsive;
  final PrivateCounseling data;

  @override
  State<PrivateCardWidget> createState() => _PrivateCardWidgetState();
}

class _PrivateCardWidgetState extends State<PrivateCardWidget> {
  void openChat() async {
    Map<String, dynamic> userMap = {};
    FirebaseFirestore _storage = FirebaseFirestore.instance;
    await _storage
        .collection("users")
        .where("id", isEqualTo: widget.data.advisorKey)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
      });
    });
    String idChat =
        chatRoomID(widget.data.advisedName, widget.data.advisorName!);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          userMap: userMap,
          counseling: widget.data,
          idChat: "$idChat${widget.data.name}",
          sender: widget.data.advisedName,
          canEnd: true,
        ),
      ),
    );
  }

  String chatRoomID(String u1, String u2) {
    if (u1[0].toLowerCase().codeUnits[0] > u2[0].toLowerCase().codeUnits[0]) {
      return "$u1$u2";
    } else {
      return "$u2$u1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.data.requestDays!.isNotEmpty
          ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AcceptCounselingRequestView(counseling: widget.data)),
              );
            }
          : openChat,
      child: Stack(
        children: [
          Card(
            borderOnForeground: true,
            elevation: 9,
            shape: Border.all(
                style: BorderStyle.solid,
                width: 3,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).iconTheme.color!
                    : Colors.black),
            shadowColor: widget.data.advisorName == null
                ? Theme.of(context).progressIndicatorTheme.linearTrackColor
                : Theme.of(context).progressIndicatorTheme.color,
            margin: EdgeInsets.all(widget.responsive.wp(3)),
            color: widget.data.advisorName == null
                ? Theme.of(context).progressIndicatorTheme.linearTrackColor
                : Theme.of(context).progressIndicatorTheme.color,
            child: SizedBox(
              height: widget.responsive.hp(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: widget.responsive.wp(40),
                        height: widget.responsive.hp(18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.data.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  fontSize: widget.responsive.dp(2.5),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: widget.responsive.wp(40),
                        height: widget.responsive.hp(18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.data.advisorName == null
                              ? [
                                  Text(
                                    "Pendiente",
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Theme.of(context).iconTheme.color!
                                            : Theme.of(context).hintColor,
                                        fontSize: widget.responsive.dp(2.3),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]
                              : [
                                  Text(
                                    "Asesor",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.black
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor,
                                        fontSize: widget.responsive.dp(1.7),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.data.advisorName!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Theme.of(context).iconTheme.color
                                            : Theme.of(context).hintColor,
                                        fontSize: widget.responsive.dp(1.7),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.data.advisorKey!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Theme.of(context).iconTheme.color
                                            : Theme.of(context).hintColor,
                                        fontSize: widget.responsive.dp(1.6),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: widget.responsive.hp(5),
                    child: ListView.builder(
                        itemCount: widget.data.days.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: widget.responsive.wp(4)),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      widget.data.days[index].day,
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.black
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                          fontSize: widget.responsive.dp(1.9),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "${modules[widget.data.days[index].idModuleStart].startHour} - ",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                  : Theme.of(context).hintColor,
                                              fontSize:
                                                  widget.responsive.dp(1.4),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          modules[widget
                                                  .data.days[index].idModuleEnd]
                                              .endHour,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                  : Theme.of(context).hintColor,
                                              fontSize:
                                                  widget.responsive.dp(1.4),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )),
                  )
                ],
              ),
            ),
          ),
          widget.data.requestDays!.isNotEmpty
              ? Container(
                  width: widget.responsive.wp(12),
                  height: widget.responsive.wp(12),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 3,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color!
                              : Colors.black),
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context)
                          .progressIndicatorTheme
                          .linearTrackColor),
                  child: Center(
                    child: Text(
                      widget.data.requestDays!.length.toString(),
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color!
                              : Theme.of(context).scaffoldBackgroundColor,
                          fontSize: widget.responsive.dp(3),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : widget.data.advisorKey != null
                  ? Container(
                      width: widget.responsive.wp(12),
                      height: widget.responsive.wp(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              width: 3,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context).iconTheme.color!
                                  : Colors.black),
                          color:
                              Theme.of(context).progressIndicatorTheme.color),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.bubble_left_fill,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ))
                  : Container()
        ],
      ),
    );
  }
}
