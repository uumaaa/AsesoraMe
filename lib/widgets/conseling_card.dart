import 'package:asispnia/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/logs.dart';

class CounselingCardWidget extends StatefulWidget {
  const CounselingCardWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.name,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.advisorsNames,
      required this.advisorsKeys,
      required this.currentID});
  final double width;
  final double height;
  final String name;
  final String day;
  final String startTime;
  final String endTime;
  final List<String> advisorsNames;
  final List<String> advisorsKeys;
  final String currentID;

  @override
  State<CounselingCardWidget> createState() => _CounselingCardWidgetState();
}

class _CounselingCardWidgetState extends State<CounselingCardWidget> {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return GestureDetector(
      onTap: () {
        bool isContained = false;
        for (var idKey in widget.advisorsKeys) {
          if (widget.currentID == idKey) {
            isContained = true;
          }
        }
        if (!isContained) {
          return;
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
        width: widget.width,
        height: widget.height,
        child: Row(
          children: [
            Container(
              width: widget.width * 4 / 8,
              padding: EdgeInsets.all(responsive.wp(2)),
              height: widget.height * 0.85,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.dp(2.3),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).iconTheme.color
                          : Theme.of(context).scaffoldBackgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.day,
                    style: TextStyle(
                      fontSize: responsive.dp(3.8),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).iconTheme.color
                          : Theme.of(context).scaffoldBackgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Asesores",
                    style: TextStyle(
                      fontSize: responsive.dp(2),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).iconTheme.color
                          : Theme.of(context).scaffoldBackgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                      itemCount: widget.advisorsNames.length,
                      shrinkWrap: true,
                      itemBuilder: (context, item) {
                        return Center(
                          child: Text(
                            widget.advisorsNames[item],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsive.dp(1),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(context).scaffoldBackgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                ],
              )),
            ),
            Container(
              width: widget.width * 4 / 8,
              height: widget.height,
              decoration: BoxDecoration(
                border:
                    Border.all(width: 4, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(CupertinoIcons.clock,
                          size: responsive.wp(7.5),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).primaryColor),
                      Text(
                        widget.startTime,
                        style: TextStyle(
                          fontSize: responsive.dp(2.3),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        CupertinoIcons.clock_fill,
                        size: responsive.wp(7.5),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).primaryColor,
                      ),
                      Text(
                        widget.endTime,
                        style: TextStyle(
                          fontSize: responsive.dp(2.3),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Salon",
                        style: TextStyle(
                          fontSize: responsive.dp(3),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: responsive.wp(17),
                        height: responsive.hp(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            "101",
                            style: TextStyle(
                              fontSize: responsive.dp(3.2),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(context).scaffoldBackgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
