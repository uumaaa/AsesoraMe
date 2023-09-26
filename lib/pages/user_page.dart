import 'package:asispnia/api/account_api.dart';
import 'package:asispnia/api/player_api.dart';
import 'package:asispnia/data/authentication_client.dart';
import 'package:asispnia/data/enum_lists.dart';
import 'package:asispnia/model/http_response.dart';
import 'package:asispnia/pages/accounts_user.dart';
import 'package:asispnia/pages/home_page.dart';
import 'package:asispnia/utils/responsive.dart';
import 'package:asispnia/widgets/avatar_image.dart';
import 'package:asispnia/widgets/change_theme_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../model/player.dart';
import '../model/user.dart';
import '../utils/logs.dart';
import '../widgets/dialogs.dart';

class UserPage extends StatefulWidget {
  static const routeName = 'user_page';
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthenticationClient apiClient = GetIt.instance<AuthenticationClient>();
  final AccountApi accountApi = GetIt.instance<AccountApi>();
  final PlayerApi playerApi = GetIt.instance<PlayerApi>();
  late Future<void> userFuture;
  late Future<void> playerFuture;
  late String urlAvatar;
  late final User user;
  late final Player player;
  Future<void> signOut() async {
    apiClient.sigOutSession();
    await fbauth.FirebaseAuth.instance.signOut();
    await Navigator.popAndPushNamed(context, AccountControllerView.routeName);
  }

  int cont = 0;

  @override
  void initState() {
    super.initState();
    urlAvatar = AVATARASSETS[0];
    userFuture = loadUser();
    playerFuture = loadPlayer();
  }

  Future<void> loadUser() async {
    final HttpResponse<User> response = await accountApi.getUserInfo();
    if (response.data != null) {
      user = response.data!;
    }
  }

  Future<void> loadPlayer() async {
    final HttpResponse<Player> response = await playerApi.getPlayerInfo();
    if (response.data != null) {
      player = response.data!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive(context);
    if (context.isLandscape) {
      return horizontalView(responsive);
    } else {
      return verticalView(responsive);
    }
  }

  FutureBuilder horizontalView(Responsive responsive) {
    return FutureBuilder(
      future: Future.wait([userFuture, playerFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton.extended(
                mouseCursor: MaterialStateMouseCursor.textable,
                tooltip: "Editar",
                label: Text(
                  "Editar",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(
                  CupertinoIcons.square_pencil,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).iconTheme.color
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () async {
                  await Dialogs.changeInfoPlayer(
                    context,
                    title: "Cambia tus datos",
                    id: user.idUser,
                    name: user.name,
                    username: user.username,
                    type: user.type,
                  );
                }),
            appBar: AppBar(
                leading: CupertinoButton(
                  child: Icon(
                    CupertinoIcons.home,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                  onPressed: () async {
                    await Navigator.popAndPushNamed(
                        context, HomePage.routeName);
                  },
                ),
                actions: [
                  const ChangeThemeButton(),
                  CupertinoButton(
                    child: Icon(
                      CupertinoIcons.power,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).iconTheme.color
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    onPressed: () async {
                      await signOut();
                    },
                  ),
                ],
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(responsive.wp(1.2)),
                          child: Column(
                            children: [
                              Image.asset(
                                urlAvatar,
                                width: responsive.wp(40),
                                height: responsive.hp(50),
                                fit: BoxFit.contain,
                              ),
                              SizedBox(
                                width: responsive.wp(40),
                                height: responsive.hp(30),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              user.username,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: responsive.dp(2.5)),
                                            ),
                                            Text(
                                              user.name,
                                              style: TextStyle(
                                                fontSize: responsive.dp(1.5),
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "Matricula",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: responsive.dp(1.7)),
                                            ),
                                            Text(
                                              user.idUser,
                                              style: TextStyle(
                                                  fontSize: responsive.dp(1.5),
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "Rol",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: responsive.dp(1.7)),
                                            ),
                                            Text(
                                              user.type,
                                              style: TextStyle(
                                                fontSize: responsive.dp(1.5),
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: responsive.hp(8),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Puntos",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: responsive.dp(1.7)),
                                            ),
                                            Text(
                                              '${player.points}',
                                              style: TextStyle(
                                                fontSize: responsive.dp(1.5),
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "Nivel",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: responsive.dp(1.7)),
                                            ),
                                            Text(
                                              '${player.level}',
                                              style: TextStyle(
                                                fontSize: responsive.dp(1.5),
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: responsive.wp(55),
                          height: responsive.hp(100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                color: Theme.of(context).primaryColor,
                                width: double.infinity,
                                height: responsive.hp(17),
                                child: Center(
                                  child: Text(
                                    "Logros",
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Theme.of(context).iconTheme.color
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor,
                                        fontSize: responsive.dp(2.8),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: responsive.hp(30),
                              ),
                              Container(
                                color: Theme.of(context).primaryColor,
                                width: double.infinity,
                                height: responsive.hp(17),
                                child: Center(
                                  child: Text(
                                    "Mis actividades",
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Theme.of(context).iconTheme.color
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor,
                                        fontSize: responsive.dp(2.8),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            child: Center(
              child: SizedBox(
                height:
                    context.isLandscape ? responsive.wp(7) : responsive.wp(16),
                width:
                    context.isLandscape ? responsive.wp(7) : responsive.wp(16),
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  FutureBuilder verticalView(Responsive responsive) {
    return FutureBuilder(
      future: Future.wait([loadPlayer(), loadUser()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton.extended(
                mouseCursor: MaterialStateMouseCursor.textable,
                tooltip: "Editar",
                label: Text(
                  "Editar",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(
                  CupertinoIcons.square_pencil,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).iconTheme.color
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  Dialogs.changeInfoPlayer(
                    context,
                    title: "Cambia tus datos",
                    id: user.idUser,
                    name: user.name,
                    username: user.username,
                    type: user.type,
                  );
                }),
            appBar: AppBar(
                leading: CupertinoButton(
                  child: Icon(
                    CupertinoIcons.home,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                  onPressed: () async {
                    await Navigator.popAndPushNamed(
                        context, HomePage.routeName);
                  },
                ),
                actions: [
                  const ChangeThemeButton(),
                  CupertinoButton(
                    child: Icon(
                      CupertinoIcons.power,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).iconTheme.color
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    onPressed: () async {
                      await signOut();
                    },
                  ),
                ],
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [AvatarWidget()],
                        ),
                        SizedBox(
                          width: responsive.wp(45),
                          height: responsive.hp(25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Matricula",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            fontWeight: FontWeight.w600,
                                            fontSize: responsive.dp(1.7)),
                                      ),
                                      Text(
                                        user.idUser,
                                        style: TextStyle(
                                            fontSize: responsive.dp(1.5),
                                            color: Theme.of(context).hintColor),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Rol",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            fontWeight: FontWeight.w600,
                                            fontSize: responsive.dp(1.7)),
                                      ),
                                      Text(
                                        user.type,
                                        style: TextStyle(
                                          fontSize: responsive.dp(1.5),
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    user.username,
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: responsive.dp(2.5)),
                                  ),
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: responsive.dp(1.5),
                                      color: Theme.of(context).hintColor,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Puntos",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            fontWeight: FontWeight.w600,
                                            fontSize: responsive.dp(1.7)),
                                      ),
                                      Text(
                                        '${player.points}',
                                        style: TextStyle(
                                          fontSize: responsive.dp(1.5),
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Nivel",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            fontWeight: FontWeight.w600,
                                            fontSize: responsive.dp(1.7)),
                                      ),
                                      Text(
                                        '${player.level}',
                                        style: TextStyle(
                                          fontSize: responsive.dp(1.5),
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Container(
                      width: double.infinity,
                      height: responsive.hp(7),
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(
                          "Mis logros",
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(context).scaffoldBackgroundColor,
                              fontSize: responsive.dp(2.8),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: responsive.hp(30),
                      padding: EdgeInsets.all(responsive.wp(2)),
                      child: GridView.builder(
                          itemCount: player.achievements.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 2 / 3,
                                  crossAxisSpacing: responsive.wp(2)),
                          itemBuilder: (context, item) {
                            return Column(
                              children: [
                                Image.asset(
                                  "assets/achievements/${player.achievements[item].url}.png",
                                ),
                                Text(
                                  player.achievements[item].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Theme.of(context).iconTheme.color
                                          : Theme.of(context).hintColor),
                                )
                              ],
                            );
                          }),
                    ),
                    Container(
                      width: double.infinity,
                      height: responsive.hp(7),
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(
                          "Mis actividades",
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context).iconTheme.color
                                  : Theme.of(context).scaffoldBackgroundColor,
                              fontSize: responsive.dp(2.8),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            child: Center(
              child: SizedBox(
                height:
                    context.isLandscape ? responsive.wp(7) : responsive.wp(16),
                width:
                    context.isLandscape ? responsive.wp(7) : responsive.wp(16),
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
