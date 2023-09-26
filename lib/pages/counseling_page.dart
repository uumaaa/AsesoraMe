import 'dart:io';

import 'package:asispnia/api/counseling_api.dart';
import 'package:asispnia/data/modules.dart';
import 'package:asispnia/model/counseling.dart';
import 'package:asispnia/model/specific_counseling.dart';
import 'package:asispnia/widgets/conseling_card.dart';
import 'package:asispnia/widgets/day_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../model/http_response.dart';
import '../model/user.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';

class CounselingView extends StatefulWidget {
  const CounselingView({super.key, required this.user});
  final User user;

  @override
  State<CounselingView> createState() => _CounselingViewState();
}

class _CounselingViewState extends State<CounselingView> {
  final CounselingApi counselingApi = GetIt.instance<CounselingApi>();
  final TextEditingController dateController = TextEditingController();
  late DateTime now;
  List<bool> days = List<bool>.generate(7, (index) => true);

  Future<List<MainCounseling>> getCounselings() async {
    List<MainCounseling> counselings = [];
    List<int> idCounselings = [];
    HttpResponse<List<int>> response = await counselingApi.getMainCounselings();
    if (response.data != null) {
      idCounselings = response.data!;
    }
    for (var idCounseling in idCounselings) {
      HttpResponse<MainCounseling> counselingResponse =
          await counselingApi.getMainCounselingByID(idCounseling);
      if (counselingResponse.data != null) {
        counselings.add(counselingResponse.data!);
      }
    }
    return counselings;
  }

  List<SpecificCounseling> generateCounselingDays(MainCounseling counseling) {
    String formattedDayOfWeek = DateFormat('EEEE').format(now);
    int day = 7;
    if (formattedDayOfWeek == 'Monday') {
      day = 1;
    }
    if (formattedDayOfWeek == 'Tuesday') {
      day = 2;
    }
    if (formattedDayOfWeek == 'Wednesday') {
      day = 3;
    }
    if (formattedDayOfWeek == 'Thursday') {
      day = 4;
    }
    if (formattedDayOfWeek == 'Friday') {
      day = 5;
    }
    if (formattedDayOfWeek == 'Saturday') {
      day = 6;
    }
    List<SpecificCounseling> toShow = [];
    if (counseling.endTime!.isBefore(DateTime.now())) {
      return [];
    }
    if (counseling.startTime
        .isAfter(DateTime.now().add(const Duration(days: 8)))) {
      return [];
    }
    for (var specificDay in counseling.days) {
      int counselingDay = 7;
      if (specificDay.day == "Lunes") {
        counselingDay = 1;
      }
      if (specificDay.day == "Martes") {
        counselingDay = 2;
      }
      if (specificDay.day == "Miercoles") {
        counselingDay = 3;
      }
      if (specificDay.day == "Jueves") {
        counselingDay = 4;
      }
      if (specificDay.day == "Viernes") {
        counselingDay = 5;
      }
      if (specificDay.day == "Sabado") {
        counselingDay = 6;
      }
      if (days[counselingDay - 1] == true) {
        int diff = day - counselingDay;
        if (diff <= 1) {
          toShow.add(
            SpecificCounseling(
              advisorsNames: counseling.advisorsNames,
              idDayOfCounseling: specificDay.idDay!,
              name: counseling.name,
              day: specificDay.day,
              idModule_start: specificDay.idModuleStart,
              idModule_end: specificDay.idModuleEnd,
              advisorsKeys: counseling.advisorsKeys,
              date: now.add(
                Duration(days: diff),
              ),
            ),
          );
        }
      }
    }
    return toShow;
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return FutureBuilder(
      future: Future.wait([getCounselings()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<SpecificCounseling> spcCounselings = [];
          for (var counseling in snapshot.data![0]) {
            List<SpecificCounseling> spcC = generateCounselingDays(counseling);
            for (var specificCounseling in spcC) {
              spcCounselings.add(specificCounseling);
            }
          }
          spcCounselings.sort((a, b) {
            int dateDiff = b.date.compareTo(a.date);
            if (dateDiff == 0) {
              return a.idModule_start! - b.idModule_start!;
            }
            return dateDiff;
          });
          if (context.isLandscape) {
            return horizontalView(responsive, spcCounselings);
          } else {
            return verticalView(responsive, spcCounselings);
          }
        } else {
          return Container();
        }
      },
    );
  }

  SingleChildScrollView verticalView(
          Responsive responsive, List<SpecificCounseling> counselings) =>
      SingleChildScrollView(
        child: SafeArea(
            child: Container(
          width: responsive.wp(94),
          height: responsive.hp(79),
          padding: EdgeInsets.only(top: responsive.hp(.5)),
          child: Column(
            children: [
              Text(
                "Filtrar por día",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.dp(3)),
              ),
              Container(
                width: responsive.wp(90),
                margin: EdgeInsets.only(
                    top: responsive.hp(1), bottom: responsive.hp(1)),
                height: responsive.hp(6),
                child: ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (contex, item) => DayButtonWoutLogic(
                    width: responsive.wp(16),
                    height: responsive.wp(16) * 2 / 3,
                    number: item,
                    callBackFunction: (p0) {
                      setState(() {
                        days[item] = p0;
                      });
                    },
                    selected: days[item],
                  ),
                ),
              ),
              Container(
                width: responsive.wp(90),
                height: responsive.hp(66),
                child: ListView.builder(
                  itemCount: counselings.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Center(
                      child: CounselingCardWidget(
                        width: responsive.wp(90),
                        height: responsive.hp(22),
                        name: counselings[index].name!,
                        day: counselings[index].day!,
                        advisorsKeys: counselings[index].advisorsKeys,
                        startTime: modules[counselings[index].idModule_start!]
                            .startHour,
                        endTime:
                            modules[counselings[index].idModule_start!].endHour,
                        advisorsNames: counselings[index].advisorsNames!,
                        currentID: widget.user.idUser,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )),
      );

  SingleChildScrollView horizontalView(
          Responsive responsive, List<SpecificCounseling> counselings) =>
      SingleChildScrollView(
        child: SafeArea(
          child: Container(),
        ),
      );
}
