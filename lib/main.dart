import 'package:asispnia/helpers/dependency_injection.dart';
import 'package:asispnia/pages/accounts_user.dart';
import 'package:asispnia/pages/home_page.dart';
import 'package:asispnia/pages/user_page.dart';
import 'package:asispnia/pages/loading_page.dart';
import 'package:asispnia/theme/dark_theme.dart';
import 'package:asispnia/theme/light_theme.dart';
import 'package:asispnia/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  DependencyInjection.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider =
              Provider.of<ThemeProvider>(context, listen: true);
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darktTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const LoadingView(),
            routes: {
              UserPage.routeName: (context) => const UserPage(),
              LoadingView.routeName: (context) => const LoadingView(),
              HomePage.routeName: (context) => const HomePage(),
              AccountControllerView.routeName: (context) =>
                  const AccountControllerView(),
            },
          );
        });
  }
}
