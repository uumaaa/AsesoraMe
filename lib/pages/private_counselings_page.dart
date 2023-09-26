import 'dart:ffi';
import 'dart:math';

import 'package:asispnia/api/counseling_api.dart';
import 'package:asispnia/data/enum_lists.dart';
import 'package:asispnia/widgets/category_button.dart';
import 'package:asispnia/widgets/dropdown_menu.dart';
import 'package:asispnia/widgets/text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_it/get_it.dart';

import '../model/counseling.dart';
import '../model/http_response.dart';
import '../model/user.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';
import '../widgets/private_card_other.dart';
import '../widgets/private_card_widget.dart';

class PrivateCounselingsView extends StatefulWidget {
  const PrivateCounselingsView({super.key, required this.user});
  final User user;
  @override
  State<PrivateCounselingsView> createState() => _PrivateCounselingsViewState();
}

class _PrivateCounselingsViewState extends State<PrivateCounselingsView> {
  late final Future<List<PrivateCounseling>> privateOthers;
  late final Future<List<PrivateCounseling>> privateMine;
  final CounselingApi counselingApi = GetIt.instance<CounselingApi>();
  late bool otherCounseling;
  late bool mineCounseling;

  @override
  void initState() {
    super.initState();
    otherCounseling = false;
    mineCounseling = false;
    privateOthers = getPrivateCounselings();
    privateMine = getPrivateCounselingsMine();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Theme.of(context).iconTheme.color!;
    }
    return Theme.of(context).iconTheme.color!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<int>> getPrivateCounselingsIDs() async {
    HttpResponse<List<int>> response =
        await counselingApi.getPrivateCounselings();
    if (response.data != null) {
      return response.data!;
    } else {
      return [];
    }
  }

  Future<List<int>> getPrivateCounselingsIDsMine() async {
    HttpResponse<List<int>> response =
        await counselingApi.getPrivateCounselingsMine();
    if (response.data != null) {
      return response.data!;
    } else {
      return [];
    }
  }

  Future<List<PrivateCounseling>> getPrivateCounselings() async {
    List<int> idCounselings = await getPrivateCounselingsIDs();
    List<PrivateCounseling> privCounselings = [];
    for (var id in idCounselings) {
      HttpResponse<PrivateCounseling> response =
          await counselingApi.getPrivateCounselingByID(id);
      if (response.data != null) {
        privCounselings.add(response.data!);
      }
    }
    return privCounselings;
  }

  Future<List<PrivateCounseling>> getPrivateCounselingsMine() async {
    List<int> idCounselings = await getPrivateCounselingsIDsMine();
    List<PrivateCounseling> privCounselings = [];
    for (var id in idCounselings) {
      HttpResponse<PrivateCounseling> response =
          await counselingApi.getPrivateCounselingByID(id);
      if (response.data != null) {
        privCounselings.add(response.data!);
      }
    }
    return privCounselings;
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    if (context.isLandscape) {
      return Container();
    } else {
      return verticalView(responsive);
    }
  }

  FutureBuilder verticalView(Responsive responsive) =>
      FutureBuilder<List<List<PrivateCounseling>>>(
          future: Future.wait([privateOthers, privateMine]),
          builder: (BuildContext context,
              AsyncSnapshot<List<List<PrivateCounseling>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    width: responsive.wp(94),
                    margin: EdgeInsets.all(
                      responsive.wp(3),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: responsive.wp(92),
                          height: responsive.hp(6),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(14)),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  "Tus asesorias",
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Theme.of(context).iconTheme.color
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.dp(
                                        2.4,
                                      )),
                                ),
                              ),
                              Transform.rotate(
                                angle: mineCounseling ? pi / 2 : -pi / 2,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        mineCounseling = !mineCounseling;
                                      });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.chevron_back,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Theme.of(context).iconTheme.color
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor,
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: responsive.wp(94),
                          height: mineCounseling
                              ? snapshot.data![1].isEmpty
                                  ? 0
                                  : responsive.hp(32)
                              : 0,
                          child: ListView.builder(
                              itemCount: snapshot.data![1].length,
                              itemBuilder: (context, index) {
                                return PrivateCardMineWidget(
                                  responsive: responsive,
                                  data: snapshot.data![1],
                                  item: index,
                                );
                              }),
                        ),
                        SizedBox(
                          height: responsive.hp(2),
                        ),
                        Container(
                          width: responsive.wp(92),
                          height: responsive.hp(6),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(14)),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  "Otras asesorias",
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Theme.of(context).iconTheme.color
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.dp(
                                        2.4,
                                      )),
                                ),
                              ),
                              Transform.rotate(
                                angle: otherCounseling ? pi / 2 : -pi / 2,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        otherCounseling = !otherCounseling;
                                      });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.chevron_back,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Theme.of(context).iconTheme.color
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor,
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: responsive.wp(94),
                          height: otherCounseling
                              ? snapshot.data![0].isEmpty
                                  ? 0
                                  : snapshot.data![1].isEmpty || !mineCounseling
                                      ? responsive.hp(70)
                                      : responsive.hp(32)
                              : 0,
                          child: ListView.builder(
                              itemCount: snapshot.data![0].length,
                              itemBuilder: (context, index) {
                                return PrivateCardOtherWidget(
                                  responsive: responsive,
                                  data: snapshot.data![0],
                                  item: index,
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          });
}
