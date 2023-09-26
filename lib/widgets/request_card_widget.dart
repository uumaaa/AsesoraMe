import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/counseling_api.dart';
import '../data/modules.dart';
import '../model/day.dart';
import '../model/http_response.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';
import 'dialogs.dart';

class RequestCard extends StatefulWidget {
  const RequestCard({
    super.key,
    required this.responsive,
    required this.mapKey,
    required this.mapValue,
    required this.item,
    required this.counselingID,
  });

  final Responsive responsive;
  final String mapKey;
  final int item;
  final int counselingID;
  final List<Day> mapValue;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  Map<String, List<Day>> mapDays = {};
  Map<String, double> mapTimeDays = {};
  double totalTime = 0;
  bool isExtended = false;
  bool accept = false;
  final CounselingApi counselingApi = GetIt.instance<CounselingApi>();
  @override
  void initState() {
    super.initState();
    for (Day day in widget.mapValue) {
      if (mapDays.containsKey(day.day)) {
        mapDays[day.day]!.add(day);
        mapTimeDays[day.day] =
            mapTimeDays[day.day]! + (day.idModuleEnd - day.idModuleStart) / 5;
        totalTime += (day.idModuleEnd - day.idModuleStart) / 30;
        if (mapTimeDays[day.day]! >= 1) {
          mapTimeDays[day.day] = 1;
        }
      } else {
        mapDays[day.day] = [day];
        mapTimeDays[day.day] = (day.idModuleEnd - day.idModuleStart) / 5;
        totalTime += (day.idModuleEnd - day.idModuleStart) / 30;
        if (mapTimeDays[day.day]! >= 1) {
          mapTimeDays[day.day] = 1;
        }
      }
    }
    if (totalTime >= 1) {
      totalTime = 1;
    }
  }

  @override
  Widget build(BuildContext context) => isExtended
      ? Stack(
          children: [
            Container(
              height: widget.responsive.hp(25),
              padding: EdgeInsets.all(widget.responsive.wp(3)),
              margin: EdgeInsets.all(widget.responsive.wp(3)),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.deepPurple
                            : Colors.deepPurpleAccent,
                        blurRadius: 6)
                  ],
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.deepPurple
                      : Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: widget.responsive.wp(5),
                      ),
                      Text(
                        widget.mapKey,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).scaffoldBackgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.responsive.dp(2.3),
                        ),
                      ),
                      SizedBox(
                        width: widget.responsive.wp(2),
                      ),
                      Container(
                        width: totalTime * widget.responsive.wp(34),
                        height: widget.responsive.hp(2.2),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: widget.responsive.hp(1.6),
                  ),
                  Container(
                    padding: EdgeInsets.all(widget.responsive.wp(1)),
                    width: widget.responsive.wp(92),
                    height: widget.responsive.hp(14),
                    child: ListView.builder(
                      itemCount: mapDays.length,
                      itemBuilder: ((context, index) {
                        List<MapEntry<String, List<Day>>> entriesList =
                            mapDays.entries.toList();
                        List<Day> days = entriesList[index].value;
                        List<MapEntry<String, double>> entriesListTime =
                            mapTimeDays.entries.toList();
                        double mapValueTime = entriesListTime[index].value;
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: widget.responsive.wp(4),
                                ),
                                Text(
                                  widget.mapValue[index].day,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Theme.of(context).iconTheme.color
                                        : Theme.of(context)
                                            .scaffoldBackgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: widget.responsive.dp(1.8),
                                  ),
                                ),
                                SizedBox(
                                  width: widget.responsive.wp(2),
                                ),
                                Container(
                                  width:
                                      mapValueTime * widget.responsive.wp(45),
                                  height: widget.responsive.hp(1.6),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                )
                              ],
                            ),
                            Container(
                              width: widget.responsive.wp(70),
                              height: widget.responsive.hp(5),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: days.length,
                                  itemExtent: widget.responsive.wp(20),
                                  itemBuilder: (context, hour) {
                                    return Column(
                                      children: [
                                        Text(
                                          modules[days[hour].idModuleStart]
                                              .startHour,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Theme.of(context)
                                                    .iconTheme
                                                    .color
                                                : Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: widget.responsive.dp(1.3),
                                          ),
                                        ),
                                        Text(
                                          modules[days[hour].idModuleEnd]
                                              .endHour,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Theme.of(context)
                                                    .iconTheme
                                                    .color
                                                : Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: widget.responsive.dp(1.3),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: widget.responsive.hp(1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          await Dialogs.acceptCounseling(context,
                              title: "¿Aceptar solicitud?",
                              callbackFunction: ((p0) {
                            setState(() {
                              accept = true;
                            });
                          }));
                          if (!accept) {
                            return;
                          }
                          await ProgressDialog.show(context);
                          HttpResponse<bool> response =
                              await counselingApi.acceptCounseling(
                                  widget.mapKey, widget.counselingID);
                          await ProgressDialog.dismiss(context);
                          if (response.data == null) {
                            return;
                          }
                          if (response.data! == false) {
                            return;
                          }

                          Navigator.pop(context);
                        },
                        child: Text(
                          "Aceptar solicitud",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: widget.responsive.dp(2),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Transform.translate(
              offset:
                  Offset(widget.responsive.wp(79), widget.responsive.hp(1.5)),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isExtended = !isExtended;
                    });
                  },
                  icon: Icon(
                    CupertinoIcons.minus,
                    size: widget.responsive.wp(8),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  )),
            )
          ],
        )
      : Stack(
          children: [
            Container(
              height: widget.responsive.hp(6),
              padding: EdgeInsets.all(widget.responsive.wp(3)),
              margin: EdgeInsets.all(widget.responsive.wp(3)),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.deepPurple
                            : Colors.deepPurpleAccent,
                        blurRadius: 6)
                  ],
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.deepPurple
                      : Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: widget.responsive.wp(5),
                      ),
                      Text(
                        widget.mapKey,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).scaffoldBackgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.responsive.dp(2.3),
                        ),
                      ),
                      SizedBox(
                        width: widget.responsive.wp(2),
                      ),
                      Container(
                        width: totalTime * widget.responsive.wp(34),
                        height: widget.responsive.hp(2.2),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Transform.translate(
              offset:
                  Offset(widget.responsive.wp(79), widget.responsive.hp(1.5)),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isExtended = !isExtended;
                    });
                  },
                  icon: Icon(
                    CupertinoIcons.add,
                    size: widget.responsive.wp(8),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  )),
            )
          ],
        );
}
