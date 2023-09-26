import 'package:asispnia/api/counseling_api.dart';
import 'package:asispnia/data/enum_lists.dart';
import 'package:asispnia/model/extra_category.dart';
import 'package:asispnia/utils/responsive.dart';
import 'package:asispnia/widgets/action_button_sized.dart';
import 'package:asispnia/widgets/category_button.dart';
import 'package:asispnia/widgets/day_button.dart';
import 'package:asispnia/widgets/dialogs.dart';
import 'package:asispnia/widgets/text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/account_api.dart';
import '../data/authentication_client.dart';
import '../model/counseling.dart';
import '../model/day.dart';
import '../model/http_response.dart';
import '../model/user.dart';
import '../utils/logs.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/change_theme_button.dart';

class CreateCounselingView extends StatefulWidget {
  const CreateCounselingView({super.key, required this.user});
  final User user;

  @override
  State<CreateCounselingView> createState() => _CreateCounselingViewState();
}

class _CreateCounselingViewState extends State<CreateCounselingView> {
  final AuthenticationClient apiClient = GetIt.instance<AuthenticationClient>();
  final AccountApi accountApi = GetIt.instance<AccountApi>();
  final CounselingApi counselingApi = GetIt.instance<CounselingApi>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  int? categorySelected;
  int advisors = 1;
  String? category;
  List<TextEditingController> advisorsController = [];
  List<Day> daysSelected = [];
  List<String> daysSelectedString = [];
  final List<String> groupCategory = ["Asesoria", "Actividad extracurricular"];
  late final Future<Map<int, String>> categoriesNames;
  bool allRequirements = false;

  Future<Map<int, String>> getCategoriesExtra() async {
    Map<int, String> map = {};
    HttpResponse<List<ExtracurricularCategory>> response =
        await counselingApi.getCategories();
    if (response.data != null) {
      for (var category in response.data!) {
        if (!map.containsKey(category.idCategory)) {
          map[category.idCategory] = category.name;
        }
      }
    }
    return map;
  }

  void verifyAllRequirements() {
    setState(() {
      allRequirements = false;
      if (nameController.value.text.length >= 7 &&
          category != null &&
          daysSelected.isNotEmpty &&
          startTimeController.value.text.isNotEmpty &&
          endTimeController.value.text.isNotEmpty) {
        for (var controller in advisorsController) {
          if (controller.value.text.isEmpty ||
              controller.value.text.length != 10) {
            return;
          }
        }
        if (category == groupCategory[1] && categorySelected == null) {
          return;
        }
        allRequirements = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    category = groupCategory[0];
    categoriesNames = getCategoriesExtra();
    nameController.addListener(verifyAllRequirements);
    startTimeController.addListener(verifyAllRequirements);
    endTimeController.addListener(verifyAllRequirements);
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return verticalView(responsive);
  }

  FutureBuilder verticalView(Responsive responsive) {
    return FutureBuilder(
      future: categoriesNames,
      builder: (context, snapshot) {
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
                            TextFormGlobalWoutTitle(
                                controller: nameController,
                                textHint: "",
                                textInputType: TextInputType.name,
                                obscureText: false,
                                width: responsive.wp(50),
                                height: responsive.hp(5),
                                separation: 2,
                                fontSize: responsive.dp(2))
                          ],
                        ),
                        SizedBox(height: responsive.hp(2)),
                        Text(
                          "Tipo:",
                          style: TextStyle(
                              fontSize: responsive.dp(2.2),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).iconTheme.color),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: responsive.wp(50),
                              height: responsive.hp(25),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ListTile(
                                    title: Text(
                                      "Asesoria",
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: responsive.dp(1.7)),
                                    ),
                                    leading: Radio(
                                        activeColor: Theme.of(context)
                                                    .brightness ==
                                                Brightness.light
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).iconTheme.color,
                                        value: groupCategory[0],
                                        groupValue: category,
                                        onChanged: (value) {
                                          setState(() {
                                            categorySelected = null;
                                            category = value.toString();
                                          });
                                          verifyAllRequirements();
                                        }),
                                  ),
                                  ListTile(
                                    leading: Radio(
                                        activeColor: Theme.of(context)
                                                    .brightness ==
                                                Brightness.light
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).iconTheme.color,
                                        value: groupCategory[1],
                                        groupValue: category,
                                        onChanged: (value) {
                                          setState(() {
                                            categorySelected = null;
                                            category = value.toString();
                                          });
                                          verifyAllRequirements();
                                        }),
                                    title: Text(
                                      "Actividad\nExtracurricular",
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: responsive.dp(1.6)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: responsive.wp(43),
                              height: responsive.hp(25),
                              child: category == null ||
                                      category == groupCategory[0]
                                  ? null
                                  : Column(children: [
                                      SizedBox(
                                        height: responsive.hp(2),
                                      ),
                                      Text(
                                        "Categorias",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: responsive.dp(2.2),
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                        ),
                                      ),
                                      SizedBox(
                                        height: responsive.hp(1.5),
                                      ),
                                      SizedBox(
                                        width: responsive.wp(40),
                                        height: responsive.hp(18),
                                        child: ListView.builder(
                                          itemCount: snapshot.data.length,
                                          shrinkWrap: true,
                                          itemBuilder: ((context, index) {
                                            List<MapEntry<int, String>>
                                                entriesList =
                                                snapshot.data.entries.toList();
                                            int key = entriesList[index].key;
                                            String value =
                                                entriesList[index].value;
                                            return CategoryButton(
                                                callBackFunction: (p0) {
                                                  setState(() {
                                                    categorySelected = p0;
                                                  });
                                                  verifyAllRequirements();
                                                },
                                                isSelected:
                                                    categorySelected == key,
                                                name: value,
                                                width: responsive.wp(40),
                                                height: responsive.hp(7),
                                                number: key);
                                          }),
                                        ),
                                      ),
                                    ]),
                            )
                          ],
                        ),
                        SizedBox(height: responsive.hp(2)),
                        Center(
                          child: Text(
                            "Asesores",
                            style: TextStyle(
                                fontSize: responsive.dp(2.2),
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).iconTheme.color),
                          ),
                        ),
                        SizedBox(height: responsive.hp(1)),
                        SizedBox(
                          width: responsive.wp(60),
                          height: responsive.wp(10),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsive.dp(2.5),
                                fontWeight: FontWeight.bold),
                            initialValue: widget.user.idUser,
                            enabled: false,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                verifyAllRequirements();
                                setState(() {
                                  advisors += 1;
                                  advisorsController.add(TextEditingController()
                                    ..addListener(verifyAllRequirements));
                                });
                              },
                              icon: Icon(
                                CupertinoIcons.add_circled_solid,
                                size: responsive.wp(8),
                              ),
                            ),
                            advisors >= 2
                                ? IconButton(
                                    onPressed: () {
                                      verifyAllRequirements();
                                      setState(() {
                                        advisors -= 1;
                                        advisorsController.removeLast();
                                      });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.minus_circle_fill,
                                      size: responsive.wp(8),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: advisors >= 2
                              ? responsive.hp(8) * (advisors - 1)
                              : 0,
                          width: responsive.wp(60),
                          child: ListView.builder(
                              itemCount: advisors - 1,
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: responsive.hp(1)),
                                  child: TextFormGlobal(
                                      controller: advisorsController[index],
                                      textHint: "Asesor ${index + 2}",
                                      textInputType: TextInputType.number,
                                      obscureText: false,
                                      width: responsive.wp(60),
                                      height: responsive.wp(8),
                                      separation: 0,
                                      fontSize: responsive.dp(2)),
                                );
                              })),
                        ),
                        SizedBox(height: responsive.hp(2)),
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
                        SizedBox(height: responsive.hp(1)),
                        SizedBox(
                          width: responsive.wp(94),
                          height: responsive.hp(10),
                          child: ListView.builder(
                              itemCount: 7,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => DayButton(
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
                                      daysSelected = List<Day>.from(copyList);

                                      for (int i = 0; i < p0.length; i += 2) {
                                        daysSelected.add(Day(
                                            day: NAMEOFDAYS[index],
                                            idModuleStart: p0[i],
                                            idModuleEnd: p0[i + 1],
                                            confirmed: true));
                                      }
                                      daysSelectedString = List<String>.from(
                                          daysSelected.map((e) => e.day));
                                      verifyAllRequirements();
                                    });
                                  },
                                  width: responsive.wp(17),
                                  height: responsive.hp(10),
                                  letter: NAMEOFDAYS[index][0],
                                  number: index)),
                        ),
                        SizedBox(height: responsive.hp(3)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Center(
                                  child: Text(
                                    "Fecha inicial",
                                    style: TextStyle(
                                        fontSize: responsive.dp(2.2),
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .iconTheme
                                                .color),
                                  ),
                                ),
                                CalendarView(
                                    width: responsive.wp(40),
                                    height: responsive.hp(5),
                                    fontSize: responsive.dp(1.7),
                                    refreshData: () {},
                                    dateController: startTimeController)
                              ],
                            ),
                            Column(
                              children: [
                                Center(
                                  child: Text(
                                    "Fecha final",
                                    style: TextStyle(
                                        fontSize: responsive.dp(2.2),
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .iconTheme
                                                .color),
                                  ),
                                ),
                                CalendarView(
                                    width: responsive.wp(40),
                                    height: responsive.hp(5),
                                    fontSize: responsive.dp(1.7),
                                    refreshData: () {},
                                    dateController: endTimeController)
                              ],
                            )
                          ],
                        ),
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
                                  ProgressDialog.show(context);
                                  List<String> advisorsKeys = [
                                    widget.user.idUser
                                  ];
                                  for (var controller in advisorsController) {
                                    advisorsKeys.add(controller.text);
                                  }
                                  if (category == groupCategory[0]) {
                                    MainCounseling data = MainCounseling(
                                        name: nameController.text,
                                        startTime: DateTime.parse(
                                            startTimeController.text),
                                        endTime: DateTime.parse(
                                            endTimeController.text),
                                        advisorsKeys: advisorsKeys,
                                        type: "Asesoria",
                                        days: daysSelected);
                                    HttpResponse<Map<String, dynamic>>
                                        response = await counselingApi
                                            .postCounseling<MainCounseling>(
                                                data);
                                    ProgressDialog.dismiss(context);
                                    if (response.data == null) {
                                      Dialogs.alert(context,
                                          title: "Error",
                                          description:
                                              "Hubo un error al generar la asesoria");
                                      return;
                                    }
                                  } else {
                                    ExtraCounseling data = ExtraCounseling(
                                        name: nameController.text,
                                        startTime: DateTime.parse(
                                            startTimeController.text),
                                        endTime: DateTime.parse(
                                            endTimeController.text),
                                        extracurricularCategory:
                                            categorySelected!,
                                        advisorsKeys: advisorsKeys,
                                        type: "Actividad Extracurricular",
                                        days: daysSelected);
                                    HttpResponse<Map<String, dynamic>>
                                        response = await counselingApi
                                            .postCounseling<ExtraCounseling>(
                                                data);
                                    ProgressDialog.dismiss(context);
                                    if (response.data == null) {
                                      Dialogs.alert(context,
                                          title: "Error",
                                          description:
                                              "Hubo un error al generar la asesoria");
                                      return;
                                    }
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
      },
    );
  }
}
