import 'package:asispnia/utils/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.text,
    required this.time,
    required this.isMine,
  });
  final String text;
  final Timestamp? time;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    String seconds = time == null
        ? "0"
        : time!.toDate().minute < 10
            ? "0" + time!.toDate().minute.toString()
            : time!.toDate().minute.toString();
    String hours = time == null ? "0" : time!.toDate().hour.toString();
    Responsive responsive = Responsive(context);
    return Transform.translate(
      offset: Offset(
          isMine
              ? text.length >= 30
                  ? responsive.wp(16)
                  : responsive.wp(16.4) +
                      (30 - text.length) * responsive.wp(.70)
              : text.length >= 30
                  ? -responsive.wp(16)
                  : -responsive.wp(16) -
                      (30 - text.length) * responsive.wp(.70),
          0),
      child: UnconstrainedBox(
        child: Container(
          height: responsive.hp(8) + ((text.length / 35) * responsive.hp(2)),
          width: text.length >= 30
              ? responsive.wp(60)
              : responsive.wp(1.4) * text.length + responsive.wp(14),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30),
                  topRight: const Radius.circular(30),
                  bottomRight: Radius.circular(isMine ? 0 : 30),
                  bottomLeft: Radius.circular(isMine ? 30 : 0)),
              color: isMine
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor),
          padding: EdgeInsets.only(
              top: responsive.hp(2),
              bottom: responsive.hp(2),
              left: responsive.wp(4),
              right: responsive.wp(4)),
          margin: EdgeInsets.symmetric(vertical: responsive.hp(.4)),
          child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isMine
                        ? Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Theme.of(context).iconTheme.color
                        : Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).hintColor
                            : Theme.of(context).focusColor,
                  ),
                ),
                Text(
                  "$hours:$seconds",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: isMine
                        ? Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Theme.of(context).iconTheme.color
                        : Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).hintColor
                            : Theme.of(context).focusColor,
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
