import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormGlobal extends StatefulWidget {
  const TextFormGlobal(
      {super.key,
      required this.controller,
      required this.textHint,
      required this.textInputType,
      required this.obscureText,
      required this.width,
      required this.height,
      required this.separation,
      required this.fontSize});
  final TextEditingController controller;
  final String textHint;
  final TextInputType textInputType;
  final bool obscureText;
  final double width;
  final double height;
  final double separation;
  final double fontSize;
  @override
  State<TextFormGlobal> createState() => _TextFormGlobalState();
}

class _TextFormGlobalState extends State<TextFormGlobal> {
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: widget.separation),
            Text(
              widget.textHint,
              style: TextStyle(
                  fontSize: widget.fontSize,
                  height: 1,
                  color: Theme.of(context).iconTheme.color,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Center(
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: TextFormField(
              controller: widget.controller,
              cursorColor: Theme.of(context).iconTheme.color,
              keyboardType: widget.textInputType,
              obscureText: widget.obscureText ? isPasswordVisible : false,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: widget.fontSize,
                height: 1,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).iconTheme.color!),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: Theme.of(context).hintColor),
                ),
                suffixIcon: widget.controller.text.isEmpty
                    ? Container(
                        width: 0,
                      )
                    : widget.obscureText
                        ? IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              size: widget.fontSize,
                            ),
                            color: Theme.of(context).iconTheme.color,
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              CupertinoIcons.xmark,
                              size: widget.fontSize,
                            ),
                            color: Theme.of(context).iconTheme.color,
                            onPressed: () {
                              widget.controller.clear();
                            },
                          ),
                hintText: widget.textHint,
                hintStyle: TextStyle(
                  height: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TextFormGlobalWoutTitle extends StatefulWidget {
  const TextFormGlobalWoutTitle(
      {super.key,
      required this.controller,
      required this.textHint,
      required this.textInputType,
      required this.obscureText,
      required this.width,
      required this.height,
      required this.separation,
      required this.fontSize});
  final TextEditingController controller;
  final String textHint;
  final TextInputType textInputType;
  final bool obscureText;
  final double width;
  final double height;
  final double separation;
  final double fontSize;

  @override
  State<TextFormGlobalWoutTitle> createState() =>
      _TextFormGlobalWoutTitleState();
}

class _TextFormGlobalWoutTitleState extends State<TextFormGlobalWoutTitle> {
  bool isPasswordVisible = true;
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: TextFormField(
              controller: widget.controller,
              cursorColor: Theme.of(context).iconTheme.color,
              keyboardType: widget.textInputType,
              obscureText: widget.obscureText ? isPasswordVisible : false,
              textAlign: TextAlign.start,
              style: TextStyle(
                height: 1,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).iconTheme.color!),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: Theme.of(context).hintColor),
                ),
                suffixIcon: widget.controller.text.isEmpty
                    ? Container(
                        width: 0,
                      )
                    : widget.obscureText
                        ? IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              size: widget.fontSize,
                            ),
                            color: Theme.of(context).iconTheme.color,
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              CupertinoIcons.xmark,
                              size: widget.fontSize,
                            ),
                            color: Theme.of(context).iconTheme.color,
                            onPressed: () {
                              widget.controller.clear();
                            },
                          ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TextFormGlobalWoutTitleWithHint extends StatefulWidget {
  const TextFormGlobalWoutTitleWithHint(
      {super.key,
      required this.controller,
      required this.textHint,
      required this.textInputType,
      required this.obscureText,
      required this.width,
      required this.height,
      required this.separation,
      required this.fontSize});
  final TextEditingController controller;
  final String textHint;
  final TextInputType textInputType;
  final bool obscureText;
  final double width;
  final double height;
  final double separation;
  final double fontSize;

  @override
  State<TextFormGlobalWoutTitleWithHint> createState() =>
      _TextFormGlobalWoutTitleWithHintState();
}

class _TextFormGlobalWoutTitleWithHintState
    extends State<TextFormGlobalWoutTitleWithHint> {
  bool isPasswordVisible = true;
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: TextFormField(
              controller: widget.controller,
              cursorColor: Theme.of(context).iconTheme.color,
              keyboardType: widget.textInputType,
              obscureText: widget.obscureText ? isPasswordVisible : false,
              textAlign: TextAlign.start,
              style: TextStyle(
                height: 1,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).iconTheme.color!),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: Theme.of(context).hintColor),
                ),
                suffixIcon: widget.controller.text.isEmpty
                    ? Container(
                        width: 0,
                      )
                    : widget.obscureText
                        ? IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              size: widget.fontSize,
                            ),
                            color: Theme.of(context).iconTheme.color,
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              CupertinoIcons.xmark,
                              size: widget.fontSize,
                            ),
                            color: Theme.of(context).iconTheme.color,
                            onPressed: () {
                              widget.controller.clear();
                            },
                          ),
                hintText: widget.textHint,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
