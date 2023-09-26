import 'package:asispnia/api/account_api.dart';
import 'package:asispnia/api/authentification_api.dart';
import 'package:asispnia/data/authentication_client.dart';
import 'package:asispnia/pages/counseling_page.dart';
import 'package:asispnia/pages/create_counseling.dart';
import 'package:asispnia/pages/create_private_counseling.dart';
import 'package:asispnia/pages/extracurricular_page.dart';
import 'package:asispnia/pages/principal_page.dart';
import 'package:asispnia/pages/private_counselings_page.dart';
import 'package:asispnia/pages/qr_reader.dart';
import 'package:asispnia/pages/user_page.dart';
import 'package:asispnia/widgets/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../model/http_response.dart';
import '../model/user.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';
import '../widgets/change_theme_button.dart';

class HomePage extends StatefulWidget {
  static String routeName = "home_page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final AccountApi accountApi = GetIt.instance<AccountApi>();
  final AuthenticationClient authenticationClient =
      GetIt.instance<AuthenticationClient>();
  late TabController _tabController;

  late User user;
  late Future<void> loadUserF;
  bool keepSession = GetIt.instance<bool>();

  Future<void> loadUser() async {
    final HttpResponse<User> response = await accountApi.getUserInfo();
    if (response.data != null) {
      user = response.data!;
    }
  }

  Future<void> updateUser() async {
    AccountApi api = GetIt.instance<AccountApi>();
    String? qRLink;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(
          callbackFn: (p0) {
            qRLink = p0!;
          },
        ),
      ),
    );
    if (qRLink != null) {
      String link = qRLink!.split("|")[0];
      DateTime createdAt = DateTime.parse(qRLink!.split("|")[1]);
      if (createdAt.difference(DateTime.now()).inHours > 1) {
        return;
      }
      HttpResponse<bool> response = await api.updateUserQR(link);
      if (response.data != null) {
        if (response.data == true) {
          Dialogs.alert(context,
              title: "Exito", description: "Usuario modificado correctamente");
        } else {
          Dialogs.alert(context,
              title: "Error",
              description:
                  "Verifica que el código QR sea el correcto o intenta nuevamente");
        }
      } else {
        Dialogs.alert(context,
            title: "Error",
            description:
                "Verifica que el código QR sea el correcto o intenta nuevamente");
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 1,
    );

    _tabController.addListener(() {
      setState(() {});
    });
    loadUserF = loadUser();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return principalVerticalView(responsive);
  }

  FutureBuilder principalVerticalView(Responsive responsive) {
    return FutureBuilder(
      future: loadUserF,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return DefaultTabController(
            length: 4,
            child: Scaffold(
                floatingActionButton: createFab(_tabController.index),
                appBar: AppBar(
                  actions: [
                    user.type == "Admin"
                        ? CupertinoButton(
                            onPressed: updateUser,
                            child: Icon(
                              CupertinoIcons.qrcode_viewfinder,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(context).scaffoldBackgroundColor,
                            ),
                          )
                        : Container(),
                    CupertinoButton(
                      child: Icon(
                        CupertinoIcons.person_alt_circle,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).iconTheme.color
                            : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      onPressed: () async {
                        await Navigator.pushNamed(context, UserPage.routeName);
                      },
                    ),
                  ],
                  leading: Image.asset(
                    "assets/logos/main_logo_aside_white.png",
                  ),
                  leadingWidth: responsive.wp(35),
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  bottom: PreferredSize(
                    preferredSize: Size(responsive.wp(100), responsive.hp(8)),
                    child: TabBar(
                        isScrollable: true,
                        labelPadding:
                            EdgeInsets.symmetric(vertical: responsive.wp(0)),
                        controller: _tabController,
                        indicatorColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).iconTheme.color
                                : Theme.of(context).scaffoldBackgroundColor,
                        tabs: [
                          Container(
                            width:
                                user.type != "Alumno" ? responsive.wp(10) : 0,
                            child: user.type != "Alumno"
                                ? Tab(
                                    height: responsive.hp(8),
                                    child: Icon(
                                      user.type != "Alumno"
                                          ? CupertinoIcons.search_circle
                                          : CupertinoIcons.home,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Theme.of(context).iconTheme.color
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor,
                                      size: user.type != "Alumno"
                                          ? responsive.wp(7)
                                          : 0,
                                    ),
                                  )
                                : null,
                          ),
                          Container(
                            width: user.type != "Alumno"
                                ? responsive.wp(30)
                                : responsive.wp(100 / 3),
                            child: Tab(
                              height: responsive.hp(8),
                              text: "Personal",
                              icon: Icon(
                                CupertinoIcons.person_2_square_stack,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                          Container(
                            width: user.type != "Alumno"
                                ? responsive.wp(30)
                                : responsive.wp(100 / 3),
                            child: Tab(
                              height: responsive.hp(8),
                              text: "Extracurricular",
                              icon: Icon(
                                CupertinoIcons.game_controller_solid,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                          Container(
                            width: user.type != "Alumno"
                                ? responsive.wp(30)
                                : responsive.wp(100 / 3),
                            child: Tab(
                              text: "Programada",
                              height: responsive.hp(8),
                              icon: Icon(
                                CupertinoIcons.tickets_fill,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: SafeArea(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      buildPage("Mia"),
                      buildPage("Principal"),
                      buildPage("Cursos"),
                      buildPage("Asesorias"),
                    ],
                  ),
                )),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget? createFab(final int index) {
    if (index == 3) {
      if (user.type == "Alumno") return null;
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateCounselingView(
                      user: user,
                    )),
          );
        },
        child: Icon(
          CupertinoIcons.add,
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).iconTheme.color
              : Theme.of(context).scaffoldBackgroundColor,
        ),
      );
    }
    if (index == 1) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreatePrivateCounselingView(
                      user: user,
                    )),
          );
        },
        child: Icon(
          CupertinoIcons.person_crop_circle_badge_plus,
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).iconTheme.color
              : Theme.of(context).scaffoldBackgroundColor,
        ),
      );
    }

    return null;
  }

  Widget buildPage(String s) {
    if (s == "Principal") {
      return PrincipalView(
        key: const ValueKey<int>(1),
        user: user,
      );
    }
    if (s == "Asesorias") {
      return CounselingView(
        key: const ValueKey<int>(10),
        user: user,
      );
    }
    if (s == "Cursos") {
      return const ExtracurrricularView(
        key: ValueKey<int>(11),
      );
    }
    return PrivateCounselingsView(
      user: user,
    );
  }
}
