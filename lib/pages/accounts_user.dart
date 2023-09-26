import 'package:asispnia/pages/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/change_theme_button.dart';
import 'login_page.dart';

class AccountControllerView extends StatefulWidget {
  static String routeName = "account_controller";
  const AccountControllerView({super.key});

  @override
  State<AccountControllerView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AccountControllerView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            ChangeThemeButton(),
          ],
          title: const Text("Cuenta"),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          bottom: TabBar(
              indicatorColor: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).scaffoldBackgroundColor,
              tabs: [
                Tab(
                  icon: Icon(
                    CupertinoIcons.news,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                  text: "Registrarse",
                ),
                Tab(
                  icon: Icon(
                    CupertinoIcons.person,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                  text: "Iniciar Sesión",
                ),
              ]),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildPage("Registrarse"),
            buildPage("Iniciar Sesion"),
          ],
        ),
      ),
    );
  }

  Widget buildPage(String s) {
    if (s == "Registrarse") {
      return RegisterView();
    } else {
      return LoginView();
    }
  }
}
