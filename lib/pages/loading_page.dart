import 'package:asispnia/data/authentication_client.dart';
import 'package:asispnia/pages/accounts_user.dart';
import 'package:asispnia/pages/home_page.dart';
import 'package:asispnia/pages/user_page.dart';
import 'package:asispnia/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';

class LoadingView extends StatefulWidget {
  static const routeName = 'loading_view';
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  final AuthenticationClient apiClient = GetIt.instance<AuthenticationClient>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    final String? token = await apiClient.accesToken;
    Logs.p.i(token ?? "");
    if (token == null) {
      await Navigator.popAndPushNamed(context, AccountControllerView.routeName);
      return;
    } else {
      await Navigator.popAndPushNamed(context, HomePage.routeName);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Image.asset(
          'assets/logos/main_logo_white.png',
          color: Theme.of(context).scaffoldBackgroundColor,
          height: responsive.hp(20),
        ),
      ),
    );
  }
}
