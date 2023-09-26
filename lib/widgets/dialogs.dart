import 'package:asispnia/data/modules.dart';
import 'package:asispnia/pages/qr_update_user_page.dart';
import 'package:asispnia/widgets/text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/enum_lists.dart';
import '../utils/responsive.dart';
import 'dropdown_menu.dart';

abstract class ProgressDialog {
  static show(BuildContext context) {
    Responsive responsive = Responsive(context);
    showCupertinoDialog(
        context: context,
        builder: (_) => WillPopScope(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                child: Center(
                  child: SizedBox(
                    height: context.isLandscape
                        ? responsive.wp(7)
                        : responsive.wp(16),
                    width: context.isLandscape
                        ? responsive.wp(7)
                        : responsive.wp(16),
                    child: CircularProgressIndicator(
                      semanticsLabel: "Cargando",
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              onWillPop: () async => false,
            ));
  }

  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}

abstract class Dialogs {
  static alert(BuildContext context,
      {required String title, required String description}) async {
    Responsive responsive = Responsive(context);
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shadowColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: responsive.dp(3),
                    fontWeight: FontWeight.bold),
              ),
              content: Text(
                description,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pop(_);
                  },
                  child: SizedBox(
                    width: responsive.wp(10),
                    height: responsive.hp(10),
                    child: Center(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: responsive.dp(2),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }

  static createDayOfCounseling(BuildContext context,
      {required String title,
      required String description,
      required Function(bool) callbackFunction}) async {
    Responsive responsive = Responsive(context);
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shadowColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: responsive.dp(3),
                    fontWeight: FontWeight.bold),
              ),
              content: Text(
                description,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pop(_);
                  },
                  child: SizedBox(
                    width: responsive.wp(18),
                    height: responsive.hp(5),
                    child: Center(
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: responsive.dp(1.4),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    callbackFunction(true);
                    Navigator.pop(_);
                  },
                  child: SizedBox(
                    width: responsive.wp(18),
                    height: responsive.hp(5),
                    child: Center(
                      child: Text(
                        "Actualizar",
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: responsive.dp(1.4),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }

  static acceptCounseling(BuildContext context,
      {required String title,
      required Function(bool) callbackFunction,
      Color colorL = Colors.purple,
      Color colorB = Colors.deepPurple}) async {
    Responsive responsive = Responsive(context);
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shadowColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? colorB
                        : colorL,
                    fontSize: responsive.dp(3),
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    callbackFunction(false);
                    Navigator.pop(_);
                  },
                  child: SizedBox(
                    width: responsive.wp(18),
                    height: responsive.hp(5),
                    child: Center(
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? colorB == Colors.deepPurple
                                        ? Theme.of(context).iconTheme.color
                                        : Theme.of(context).primaryColor
                                    : Theme.of(context).hintColor,
                            fontSize: responsive.dp(1.4),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    callbackFunction(true);
                    Navigator.pop(_);
                  },
                  child: SizedBox(
                    width: responsive.wp(18),
                    height: responsive.hp(5),
                    child: Center(
                      child: Text(
                        "Aceptar",
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? colorB
                                    : colorL,
                            fontSize: responsive.dp(1.4),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }

  static changeInfoPlayer(BuildContext context,
      {required String title,
      required String id,
      required String name,
      required String username,
      required String type}) async {
    Responsive responsive = Responsive(context);
    final TextEditingController idController = TextEditingController(text: id);
    final TextEditingController nameController =
        TextEditingController(text: name);
    final TextEditingController usernameController =
        TextEditingController(text: username);

    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              scrollable: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shadowColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: responsive.dp(3),
                    fontWeight: FontWeight.bold),
              ),
              content: Column(
                children: [
                  Text(
                    "Matricula",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: responsive.dp(1.5)),
                  ),
                  SizedBox(
                    height: responsive.hp(5),
                    width: responsive.wp(70),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsive.hp(1.8),
                          fontWeight: FontWeight.bold),
                      initialValue: id,
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    "Matricula",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: responsive.dp(1.5)),
                  ),
                  SizedBox(
                    height: responsive.hp(5),
                    width: responsive.wp(70),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsive.hp(1.8),
                          fontWeight: FontWeight.bold),
                      initialValue: name,
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    "Nombre de usuario",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: responsive.dp(1.5)),
                  ),
                  SizedBox(
                    height: responsive.hp(5),
                    width: responsive.wp(70),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: responsive.hp(1.8),
                          fontWeight: FontWeight.bold),
                      initialValue: username,
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Column(
                    children: [
                      Text(
                        'Rol',
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: responsive.hp(1.65),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(5),
                        width: responsive.wp(70),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: responsive.hp(1.8),
                              fontWeight: FontWeight.bold),
                          initialValue: "Alumno",
                          enabled: false,
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      type == "Alumno"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QrUpdateUser(
                                                user: id,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    '¡Vuelvete asesor!',
                                    style: TextStyle(
                                      color: Theme.of(context).iconTheme.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pop(_);
                  },
                  child: SizedBox(
                    width: responsive.wp(20),
                    height: responsive.hp(10),
                    child: Center(
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: responsive.dp(2),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(_);
                  },
                  child: SizedBox(
                    width: responsive.wp(20),
                    height: responsive.hp(10),
                    child: Center(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: responsive.dp(2),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }

  static selectModules(BuildContext context,
      {required String title,
      required Function(List<int>) callbackFunction}) async {
    final Responsive responsive = Responsive(context);
    List<bool> isSelected = List<bool>.generate(30, (index) => false);
    List<int> isInPair = [];
    List<int> modulesSelected = [];
    void sortModules() {
      int frstIndex = modulesSelected[modulesSelected.length - 2];
      int scndIndex = modulesSelected[modulesSelected.length - 1];
      isInPair.add(frstIndex);
      isInPair.add(scndIndex);
      if (frstIndex < scndIndex) {
        return;
      }
      modulesSelected[modulesSelected.length - 2] = scndIndex;
      modulesSelected[modulesSelected.length - 1] = frstIndex;
    }

    await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                scrollable: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shadowColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  title,
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: responsive.dp(2),
                      fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: responsive.wp(80),
                  height: responsive.hp(37),
                  child: GridView.builder(
                      itemCount: modules.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 80,
                              childAspectRatio: 4 / 5,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                      itemBuilder: (context, item) {
                        return GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                isSelected[item] = !isSelected[item];
                                if (isSelected[item]) {
                                  modulesSelected.add(modules[item].idModule);
                                }
                                if (!isSelected[item]) {
                                  modulesSelected
                                      .remove(modules[item].idModule);
                                  isInPair.remove(modules[item].idModule);
                                  if (isInPair.length % 2 == 1) {
                                    isInPair.removeLast();
                                  }
                                }
                                if (modulesSelected.length % 2 == 0 &&
                                    modulesSelected.isNotEmpty) {
                                  sortModules();
                                }
                              },
                            );
                          },
                          child: Container(
                            color: isInPair.contains(modules[item].idModule)
                                ? Theme.of(context).indicatorColor
                                : isSelected[item]
                                    ? Theme.of(context).secondaryHeaderColor
                                    : Theme.of(context).disabledColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  modules[item].idModule.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.dp(2),
                                      color: isSelected[item]
                                          ? Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Theme.of(context)
                                                  .iconTheme
                                                  .color
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor
                                          : Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Theme.of(context)
                                                  .iconTheme
                                                  .color
                                              : Theme.of(context).primaryColor),
                                ),
                                Text(
                                  modules[item].startHour,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: responsive.dp(1.3),
                                      color: isSelected[item]
                                          ? Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Theme.of(context)
                                                  .iconTheme
                                                  .color
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor
                                          : Theme.of(context).hintColor),
                                ),
                                Text(
                                  modules[item].endHour,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: responsive.dp(1.3),
                                      color: isSelected[item]
                                          ? Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Theme.of(context)
                                                  .iconTheme
                                                  .color
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor
                                          : Theme.of(context).hintColor),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(_);
                    },
                    child: SizedBox(
                      width: responsive.wp(15),
                      height: responsive.hp(5),
                      child: Center(
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: responsive.dp(1.5),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: modulesSelected.length % 2 == 0
                        ? () {
                            callbackFunction(modulesSelected);
                            Navigator.pop(_);
                          }
                        : null,
                    child: SizedBox(
                      width: responsive.wp(15),
                      height: responsive.hp(5),
                      child: Center(
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: modulesSelected.length % 2 == 0
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(context).disabledColor,
                              fontSize: responsive.dp(1.5),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        });
  }

  static selectModulesRestricted(BuildContext context,
      {required String title,
      required Function(List<int>) callbackFunction,
      required List<int> firstModules,
      required List<int> lastModules}) async {
    final Responsive responsive = Responsive(context);
    List<bool> isSelected = List<bool>.generate(30, (index) => false);
    List<int> isInPair = [];
    List<int> modulesSelected = [];
    void sortModules() {
      int frstIndex = modulesSelected[modulesSelected.length - 2];
      int scndIndex = modulesSelected[modulesSelected.length - 1];
      isInPair.add(frstIndex);
      isInPair.add(scndIndex);
      if (frstIndex < scndIndex) {
        return;
      }
      modulesSelected[modulesSelected.length - 2] = scndIndex;
      modulesSelected[modulesSelected.length - 1] = frstIndex;
    }

    await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                scrollable: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shadowColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  title,
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: responsive.dp(2),
                      fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: responsive.wp(80),
                  height: responsive.hp(37),
                  child: GridView.builder(
                      itemCount: modules.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 80,
                              childAspectRatio: 4 / 5,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                      itemBuilder: (context, item) {
                        bool isEnable = false;
                        for (int i = 0; i < firstModules.length; i++) {
                          if (modules[item].idModule >= firstModules[i] &&
                              modules[item].idModule <= lastModules[i]) {
                            isEnable = true;
                          }
                        }
                        return GestureDetector(
                          onTap: isEnable
                              ? () {
                                  setState(
                                    () {
                                      isSelected[item] = !isSelected[item];
                                      if (isSelected[item]) {
                                        modulesSelected
                                            .add(modules[item].idModule);
                                      }
                                      if (!isSelected[item]) {
                                        modulesSelected
                                            .remove(modules[item].idModule);
                                        isInPair.remove(modules[item].idModule);
                                        if (isInPair.length % 2 == 1) {
                                          isInPair.removeLast();
                                        }
                                      }
                                      if (modulesSelected.length % 2 == 0 &&
                                          modulesSelected.isNotEmpty) {
                                        sortModules();
                                      }
                                    },
                                  );
                                }
                              : null,
                          child: Container(
                            color: isEnable
                                ? isInPair.contains(modules[item].idModule)
                                    ? Theme.of(context).indicatorColor
                                    : isSelected[item]
                                        ? Theme.of(context).secondaryHeaderColor
                                        : Theme.of(context).disabledColor
                                : Theme.of(context).disabledColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  modules[item].idModule.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.dp(2),
                                      color: isEnable
                                          ? isSelected[item]
                                              ? Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                  : Theme.of(context)
                                                      .scaffoldBackgroundColor
                                              : Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                  : Theme.of(context)
                                                      .primaryColor
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor),
                                ),
                                Text(
                                  modules[item].startHour,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: responsive.dp(1.3),
                                      color: isEnable
                                          ? isSelected[item]
                                              ? Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                  : Theme.of(context)
                                                      .scaffoldBackgroundColor
                                              : Theme.of(context).hintColor
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor),
                                ),
                                Text(
                                  modules[item].endHour,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: responsive.dp(1.3),
                                      color: isEnable
                                          ? isSelected[item]
                                              ? Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                  : Theme.of(context)
                                                      .scaffoldBackgroundColor
                                              : Theme.of(context).hintColor
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(_);
                    },
                    child: SizedBox(
                      width: responsive.wp(15),
                      height: responsive.hp(5),
                      child: Center(
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: responsive.dp(1.5),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: modulesSelected.length % 2 == 0
                        ? () {
                            callbackFunction(modulesSelected);
                            Navigator.pop(_);
                          }
                        : null,
                    child: SizedBox(
                      width: responsive.wp(15),
                      height: responsive.hp(5),
                      child: Center(
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: modulesSelected.length % 2 == 0
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(context).disabledColor,
                              fontSize: responsive.dp(1.5),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        });
  }
}
