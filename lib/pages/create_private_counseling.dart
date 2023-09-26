import 'package:asispnia/utils/iluminance_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/account_api.dart';
import '../api/counseling_api.dart';
import '../data/authentication_client.dart';
import '../data/enum_lists.dart';
import '../model/counseling.dart';
import '../model/day.dart';
import '../model/extra_category.dart';
import '../model/http_response.dart';
import '../model/user.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';
import '../widgets/action_button_sized.dart';
import '../widgets/change_theme_button.dart';
import '../widgets/day_button.dart';
import '../widgets/dialogs.dart';
import '../widgets/text_form.dart';

class CreatePrivateCounselingView extends StatefulWidget {
  const CreatePrivateCounselingView({super.key, required this.user});
  final User user;

  @override
  State<CreatePrivateCounselingView> createState() =>
      _CreatePrivateCounselingViewState();
}

class _CreatePrivateCounselingViewState
    extends State<CreatePrivateCounselingView> {
  final AuthenticationClient apiClient = GetIt.instance<AuthenticationClient>();
  final AccountApi accountApi = GetIt.instance<AccountApi>();
  final CounselingApi counselingApi = GetIt.instance<CounselingApi>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController topicsController = TextEditingController();
  List<Day> daysSelected = [];
  List<String> daysSelectedString = [];
  List<String> topicsList = [];
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
      if (nameController.value.text.length >= 7 && daysSelected.isNotEmpty) {
        allRequirements = true;
      }
    });
  }

  void addTopic() {
    String topics = topicsController.value.text;
    if (topics.contains(",")) {
      Logs.p.i("entre");
      String topic = topics.split(",")[0];
      if (topic.length <= 5) {
        return;
      }
      setState(() {
        topicsList.add(topic);
        topicsController.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(verifyAllRequirements);
    topicsController.addListener(addTopic);
  }

  @override
  void dispose() {
    nameController.removeListener(verifyAllRequirements);
    topicsController.removeListener(addTopic);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return verticalView(responsive);
  }

  Scaffold verticalView(Responsive responsive) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("El registro de esta solicitud se hará con el ID",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: responsive.dp(1.4),
                            color: Theme.of(context).hintColor,
                          )),
                      SizedBox(
                        width: responsive.wp(20),
                        height: responsive.wp(5),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsive.dp(1.4),
                              fontWeight: FontWeight.bold),
                          initialValue: widget.user.idUser,
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Center(
                    child: Text(
                      "Datos de la asesoria",
                      style: TextStyle(
                          fontSize: responsive.dp(2.2),
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.light
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
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).iconTheme.color),
                      ),
                      TextFormGlobalWoutTitle(
                          controller: nameController,
                          textHint: "a",
                          textInputType: TextInputType.name,
                          obscureText: false,
                          width: responsive.wp(70),
                          height: responsive.hp(5),
                          separation: 2,
                          fontSize: responsive.dp(2))
                    ],
                  ),
                  SizedBox(height: responsive.hp(2)),
                  SizedBox(height: responsive.hp(2)),
                  Text(
                      "Añade temas para hacerle saber al asesor tus puntos debiles",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: responsive.dp(1.4),
                        color: Theme.of(context).hintColor,
                      )),
                  SizedBox(height: responsive.hp(1)),
                  Center(
                    child: Text(
                      "Temas",
                      style: TextStyle(
                          fontSize: responsive.dp(2.2),
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).iconTheme.color),
                    ),
                  ),
                  TextFormGlobalWoutTitle(
                      controller: topicsController,
                      textHint: "",
                      textInputType: TextInputType.name,
                      obscureText: false,
                      width: responsive.wp(50),
                      height: responsive.hp(5),
                      separation: 2,
                      fontSize: responsive.dp(2)),
                  SizedBox(height: responsive.hp(2)),
                  SizedBox(
                    height: topicsList.isEmpty
                        ? 0
                        : responsive.hp(9) * ((topicsList.length - 1) ~/ 3 + 1),
                    child: GridView.builder(
                      itemCount: topicsList.length,
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
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
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
                                      Theme.of(context).scaffoldBackgroundColor,
                                      .06)
                                  : const Color(0x00000000).darkenColor(
                                      Theme.of(context).scaffoldBackgroundColor,
                                      .06)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: responsive.wp(20.2),
                                child: Text(
                                  topicsList[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).hintColor),
                                ),
                              ),
                              SizedBox(
                                width: responsive.wp(4),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      topicsList.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    CupertinoIcons.xmark,
                                    size: responsive.wp(4),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  Text(
                      "Selecciona los dias en los cuales puedes tomar asesorias",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: responsive.dp(1.4),
                        color: Theme.of(context).hintColor,
                      )),
                  SizedBox(height: responsive.hp(2)),
                  Center(
                    child: Text(
                      "Días",
                      style: TextStyle(
                          fontSize: responsive.dp(2.2),
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.light
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
                        itemBuilder: (context, index) => DayButton(
                            selected:
                                daysSelectedString.contains(NAMEOFDAYS[index]),
                            callbackFunction: (p0) {
                              setState(() {
                                List<Day> copyList =
                                    List<Day>.from(daysSelected);
                                for (var dayInList in daysSelected) {
                                  if (dayInList.day == NAMEOFDAYS[index]) {
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
                            await ProgressDialog.show(context);
                            String name = nameController.value.text;
                            String? topicsData;
                            if (topicsList.isNotEmpty) {
                              topicsData = topicsList[0];
                              for (int i = 1; i < topicsList.length; i++) {
                                topicsData = '$topicsData,${topicsList[i]}';
                              }
                            }
                            PrivateCounseling counseling = PrivateCounseling(
                                days: daysSelected,
                                topics: topicsData,
                                advisorKey: null,
                                type: "Privada",
                                name: name,
                                startTime: DateTime.now(),
                                idAdvisedUser: widget.user.idUser,
                                advisedName: widget.user.name);
                            HttpResponse<Map<String, dynamic>> response =
                                await counselingApi.postCounseling(counseling);
                            if (response.data == null) {
                              return;
                            }
                            if (response.data!.containsKey("error")) {
                              return;
                            }
                            await ProgressDialog.dismiss(context);
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
  }
}
