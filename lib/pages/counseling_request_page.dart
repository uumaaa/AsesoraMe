import 'package:asispnia/utils/iluminance_color.dart';
import 'package:asispnia/widgets/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/account_api.dart';
import '../api/counseling_api.dart';
import '../data/authentication_client.dart';
import '../data/enum_lists.dart';
import '../model/counseling.dart';
import '../model/day.dart';
import '../model/http_response.dart';
import '../model/user.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';
import '../widgets/action_button_sized.dart';
import '../widgets/change_theme_button.dart';
import '../widgets/day_button.dart';

class CounselingAnswerView extends StatefulWidget {
  const CounselingAnswerView({super.key, required this.counseling});
  final PrivateCounseling counseling;

  @override
  State<CounselingAnswerView> createState() => _CounselingAnswerViewState();
}

class _CounselingAnswerViewState extends State<CounselingAnswerView> {
  final AuthenticationClient apiClient = GetIt.instance<AuthenticationClient>();
  final AccountApi accountApi = GetIt.instance<AccountApi>();
  final CounselingApi counselingApi = GetIt.instance<CounselingApi>();
  late final User user;
  late final List<String> daysAdvisedSelectedString;
  late final Future<void> future;
  bool allRequirements = false;
  bool updateRequest = false;
  List<Day> daysSelected = [];
  List<String> daysSelectedString = [];

  Future<void> loadUser() async {
    final HttpResponse<User> response = await accountApi.getUserInfo();
    if (response.data != null) {
      user = response.data!;
    }
  }

  void verifyAllRequirements() {
    setState(() {
      allRequirements = false;
      if (daysSelected.isNotEmpty) {
        allRequirements = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    daysAdvisedSelectedString =
        List.from(widget.counseling.days.map((e) => e.day));
    future = loadUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return verticalView(responsive);
  }

  FutureBuilder verticalView(Responsive responsive) {
    return FutureBuilder(
        future: future,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  actions: const [
                    ChangeThemeButton(),
                  ],
                  backgroundColor: Theme.of(context).primaryColor,
                  leading: CupertinoButton(
                      child: Icon(
                        CupertinoIcons.home,
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
                      padding: EdgeInsets.all(responsive.wp(3)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: responsive.hp(2),
                          ),
                          Center(
                            child: Text(
                              "Datos de la asesoria",
                              style: TextStyle(
                                  fontSize: responsive.dp(2.2),
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).iconTheme.color),
                            ),
                          ),
                          SizedBox(
                            height: responsive.hp(2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Nombre:",
                                style: TextStyle(
                                    fontSize: responsive.dp(2.2),
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).iconTheme.color),
                              ),
                              SizedBox(
                                width: responsive.wp(60),
                                height: responsive.wp(10),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: responsive.dp(2.5),
                                      fontWeight: FontWeight.bold),
                                  initialValue: widget.counseling.name,
                                  enabled: false,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: responsive.hp(2)),
                          Center(
                            child: Text(
                              "Temas",
                              style: TextStyle(
                                  fontSize: responsive.dp(2.2),
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).iconTheme.color),
                            ),
                          ),
                          SizedBox(height: responsive.hp(2)),
                          SizedBox(
                            height: widget.counseling.topics == null
                                ? 0
                                : responsive.hp(9) *
                                    ((widget.counseling.topics!
                                                    .split(",")
                                                    .length -
                                                1) ~/
                                            3 +
                                        1),
                            child: GridView.builder(
                              itemCount: widget.counseling.topics == null
                                  ? 0
                                  : widget.counseling.topics!.split(",").length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 6 / 3,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 10),
                              itemBuilder: ((context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? const Color(0x00000000).brightenColor(
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  .1)
                                              : const Color(0x00000000).darkenColor(
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  .1)),
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? const Color(0x00000000).brightenColor(
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              .06)
                                          : const Color(0x00000000).darkenColor(
                                              Theme.of(context).scaffoldBackgroundColor, .06)),
                                  child: Center(
                                    child: Text(
                                      widget.counseling.topics!
                                          .split(",")[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).hintColor),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Días",
                              style: TextStyle(
                                  fontSize: responsive.dp(2.2),
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).iconTheme.color),
                            ),
                          ),
                          SizedBox(height: responsive.hp(2)),
                          SizedBox(
                            width: responsive.wp(94),
                            height: responsive.hp(10),
                            child: ListView.builder(
                                itemCount: 7,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  List<int> firstModules = [];
                                  List<int> lastModules = [];
                                  Iterable<Day> days = widget.counseling.days
                                      .where((element) =>
                                          element.day == NAMEOFDAYS[index]);
                                  for (var day in days) {
                                    firstModules.add(day.idModuleStart);
                                    lastModules.add(day.idModuleEnd);
                                  }
                                  return DayButtonRestricted(
                                      firstModules: firstModules,
                                      lastModules: lastModules,
                                      isEnabled: daysAdvisedSelectedString
                                          .contains(NAMEOFDAYS[index]),
                                      selected: daysSelectedString
                                          .contains(NAMEOFDAYS[index]),
                                      callbackFunction: (p0) {
                                        setState(() {
                                          List<Day> copyList =
                                              List<Day>.from(daysSelected);
                                          for (var dayInList in daysSelected) {
                                            if (dayInList.day ==
                                                NAMEOFDAYS[index]) {
                                              copyList.remove(dayInList);
                                            }
                                          }
                                          daysSelected =
                                              List<Day>.from(copyList);

                                          for (int i = 0;
                                              i < p0.length;
                                              i += 2) {
                                            daysSelected.add(Day(
                                                day: NAMEOFDAYS[index],
                                                idModuleStart: p0[i],
                                                idModuleEnd: p0[i + 1],
                                                confirmed: false));
                                          }
                                          daysSelectedString =
                                              List<String>.from(daysSelected
                                                  .map((e) => e.day));
                                          verifyAllRequirements();
                                        });
                                      },
                                      width: responsive.wp(17),
                                      height: responsive.hp(10),
                                      letter: NAMEOFDAYS[index][0],
                                      number: index);
                                }),
                          ),
                          SizedBox(height: responsive.hp(3)),
                          SizedBox(
                            height: responsive.hp(3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ActionButtonSizedAltColor(
                                  buttonContent: "Cancelar",
                                  function: () {},
                                  width: responsive.wp(30),
                                  height: responsive.hp(5),
                                  fontSize: responsive.dp(2),
                                  isEnable: true),
                              SizedBox(width: responsive.wp(5)),
                              ActionButtonSized(
                                  buttonContent: "Crear",
                                  function: () async {
                                    Map<String, dynamic> data = {
                                      "idCounseling":
                                          widget.counseling.idCounseling,
                                      "days": daysToJson(daysSelected),
                                      "idAdvisor": user.idUser
                                    };
                                    HttpResponse<bool> response =
                                        await counselingApi
                                            .verifyPreviousRequests(
                                                user.idUser,
                                                widget
                                                    .counseling.idCounseling!);

                                    if (response.data == null) return;
                                    if (!response.data!) {
                                      await Dialogs.createDayOfCounseling(
                                        context,
                                        title: "ERROR",
                                        description:
                                            "Ya creaste una solicitud con anterioridad\n¿Quieres actualizar tu solicitud con los datos actuales?",
                                        callbackFunction: (p0) {
                                          setState(() {
                                            updateRequest = p0;
                                          });
                                        },
                                      );
                                      if (!updateRequest) {
                                        return;
                                      }
                                    }

                                    HttpResponse<Map<String, dynamic>>
                                        response2 =
                                        await counselingApi.postDays(data);
                                    if (response2.data == null) {
                                      return;
                                    }
                                    if (response2.data!.containsKey("error")) {
                                      Dialogs.alert(context,
                                          title: "Error",
                                          description:
                                              "Hubo un error al crear la peticion");
                                      return;
                                    }

                                    Navigator.pop(context);
                                  },
                                  width: responsive.wp(30),
                                  height: responsive.hp(5),
                                  fontSize: responsive.dp(2),
                                  isEnable: allRequirements)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          } else {
            return Container();
          }
        }));
  }
}
