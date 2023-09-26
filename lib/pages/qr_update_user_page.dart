import 'package:asispnia/data/enum_lists.dart';
import 'package:asispnia/model/user.dart';
import 'package:asispnia/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/change_theme_button.dart';

class QrUpdateUser extends StatelessWidget {
  const QrUpdateUser({super.key, required this.user});
  final String user;

  @override
  Widget build(BuildContext context) {
    final String baseAPI = GetIt.instance<String>();
    Responsive responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Código QR"),
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
            padding: EdgeInsets.symmetric(vertical: responsive.hp(3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Presenta este código a --- para generar tu cambio de rol",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.dp(2.4),
                      color: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  height: responsive.hp(3),
                ),
                QrImageView(
                  data: '${baseAPI}users/$user/update|${DateTime.now()}',
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
