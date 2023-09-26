import 'package:asispnia/pages/counseling_request_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/modules.dart';
import '../model/counseling.dart';
import '../pages/chat_page.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';

class PrivateCardOtherWidget extends StatelessWidget {
  const PrivateCardOtherWidget(
      {super.key,
      required this.responsive,
      required this.data,
      required this.item});
  final Responsive responsive;
  final List<PrivateCounseling> data;
  final int item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CounselingAnswerView(counseling: data[item])),
        );
      },
      child: Card(
        borderOnForeground: true,
        elevation: 9,
        shape: Border.all(
            style: BorderStyle.solid,
            width: 4,
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).iconTheme.color!
                : Colors.black),
        shadowColor: Theme.of(context).secondaryHeaderColor,
        margin: EdgeInsets.all(responsive.wp(3)),
        color: Theme.of(context).secondaryHeaderColor,
        child: SizedBox(
          height: responsive.hp(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: responsive.wp(45),
                    height: responsive.hp(7),
                    child: Center(
                      child: Text(
                        data[item].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).scaffoldBackgroundColor,
                            fontSize: responsive.dp(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                      width: responsive.wp(31),
                      height: responsive.hp(7),
                      margin: EdgeInsets.all(responsive.wp(2)),
                      child: Center(
                        child: GridView.builder(
                          itemCount: data[item].days.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 6 / 4,
                                  mainAxisSpacing: responsive.wp(1),
                                  crossAxisSpacing: responsive.wp(1)),
                          itemBuilder: (context, index) => Container(
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                data[item].days[index].day.substring(0, 2),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Theme.of(context)
                                            .scaffoldBackgroundColor
                                        : Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              Text(
                data[item].advisedName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: responsive.dp(2),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                data[item].idAdvisedUser,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                    fontSize: responsive.dp(1.2),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  height: responsive.hp(5),
                  child: ListView.builder(
                    itemCount: data[item].topics == null
                        ? 0
                        : data[item].topics!.split(",").length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      List<String> splitTopics = data[item].topics!.split(",");
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: responsive.wp(4)),
                        child: Center(
                          child: Text(
                            splitTopics[index],
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: responsive.dp(1.9),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivateCardMineWidget extends StatefulWidget {
  const PrivateCardMineWidget(
      {super.key,
      required this.responsive,
      required this.data,
      required this.item});
  final Responsive responsive;
  final List<PrivateCounseling> data;
  final int item;

  @override
  State<PrivateCardMineWidget> createState() => _PrivateCardMineWidgetState();
}

class _PrivateCardMineWidgetState extends State<PrivateCardMineWidget> {
  void openChat() async {
    Map<String, dynamic> userMap = {};
    FirebaseFirestore _storage = FirebaseFirestore.instance;
    await _storage
        .collection("users")
        .where("id", isEqualTo: widget.data[widget.item].idAdvisedUser)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
      });
    });
    Logs.p.e(userMap);
    String idChat = chatRoomID(widget.data[widget.item].advisedName,
        widget.data[widget.item].advisorName!);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          counseling: widget.data[widget.item],
          userMap: userMap,
          idChat: "$idChat${widget.data[widget.item].name}",
          sender: widget.data[widget.item].advisorName!,
          canEnd: false,
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
      onTap: openChat,
      child: Stack(
        children: [
          Card(
            borderOnForeground: true,
            elevation: 9,
            shape: Border.all(
                style: BorderStyle.solid,
                width: 4,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            shadowColor: Theme.of(context).progressIndicatorTheme.color,
            margin: EdgeInsets.all(widget.responsive.wp(3)),
            color: Theme.of(context).progressIndicatorTheme.color,
            child: SizedBox(
              height: widget.responsive.hp(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: widget.responsive.wp(94),
                    height: widget.responsive.hp(7),
                    child: Center(
                      child: Text(
                        widget.data[widget.item].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).scaffoldBackgroundColor,
                            fontSize: widget.responsive.dp(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Text(
                    widget.data[widget.item].advisedName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Theme.of(context).scaffoldBackgroundColor,
                        fontSize: widget.responsive.dp(2),
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: widget.responsive.wp(40),
                    height: widget.responsive.hp(10),
                    margin: EdgeInsets.all(widget.responsive.wp(2)),
                    child: Center(
                      child: GridView.builder(
                        itemCount: widget.data[widget.item].days.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            mainAxisSpacing: widget.responsive.wp(1),
                            crossAxisSpacing: widget.responsive.wp(1)),
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              widget.data[widget.item].days[index].day
                                  .substring(0, 2),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Theme.of(context).hintColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(-2, 5),
            child: Container(
                width: widget.responsive.wp(12),
                height: widget.responsive.wp(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        width: 3,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).iconTheme.color!
                            : Colors.black),
                    color: Theme.of(context).progressIndicatorTheme.color),
                child: Center(
                  child: Icon(
                    CupertinoIcons.bubble_left_fill,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
