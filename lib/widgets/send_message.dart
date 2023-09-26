import 'package:asispnia/utils/iluminance_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/logs.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget(
      {super.key,
      required this.controller,
      required this.width,
      required this.height,
      required this.fontSize,
      required this.function});
  final TextEditingController controller;
  final double width;
  final double height;
  final double fontSize;
  final Function() function;
  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  bool canSendB = false;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(canSend);
  }

  void canSend() {
    setState(() {
      if (widget.controller.text.isEmpty) {
        canSendB = false;
      } else {
        canSendB = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: widget.width * 8.3 / 10,
            height: widget.height,
            child: TextFormField(
              controller: widget.controller,
              cursorColor: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).scaffoldBackgroundColor,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: widget.fontSize,
                height: 1,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).primaryColor,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20)),
                hintText: "Envía un mensaje",
                hintStyle: TextStyle(
                  height: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize,
                  color: Theme.of(context).disabledColor.withAlpha(180),
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: widget.function,
              icon: Icon(
                CupertinoIcons.arrow_right_circle_fill,
                size: widget.width * .95 / 10,
                color: canSendB
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).disabledColor,
              ))
        ],
      ),
    );
  }
}
