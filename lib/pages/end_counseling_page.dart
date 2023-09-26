import 'dart:ffi';

import 'package:asispnia/api/counseling_api.dart';
import 'package:asispnia/api/player_api.dart';
import 'package:asispnia/model/counseling.dart';
import 'package:asispnia/model/http_response.dart';
import 'package:asispnia/pages/home_page.dart';
import 'package:asispnia/utils/responsive.dart';
import 'package:asispnia/widgets/action_button_sized.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';

import '../widgets/dialogs.dart';

class EndCounselingPage extends StatefulWidget {
  final PrivateCounseling counseling;
  const EndCounselingPage({super.key, required this.counseling});

  @override
  State<EndCounselingPage> createState() => _EndCounselingPageState();
}

class _EndCounselingPageState extends State<EndCounselingPage> {
  PlayerApi apiP = GetIt.instance<PlayerApi>();
  CounselingApi counselingApi = GetIt.instance<CounselingApi>();
  bool endCounselingBool = false;

  Future<void> displayDialog() async {
    await Dialogs.acceptCounseling(context,
        title: "¿Deseas cancelar el proceso?", callbackFunction: (p0) {
      setState(() {
        endCounselingBool = p0;
      });
    },
        colorL: Theme.of(context).primaryColor,
        colorB: Theme.of(context).iconTheme.color!);
    if (endCounselingBool == false) {
      return;
    }
    if (endCounselingBool == true) {
      Navigator.pop(context);
    }
  }

  Future<void> endCounseling() async {
    ProgressDialog.show(context);
    HttpResponse<bool> responseC = await counselingApi.endCounseling(
        widget.counseling.idCounseling!,
        DateTime.now().toIso8601String(),
        widget.counseling);
    ProgressDialog.dismiss(context);
    if (responseC.data == null) {
      await Dialogs.alert(context,
          title: "Error",
          description: "Hubo un error al finalizar la operación");
      return;
    }

    await Navigator.popAndPushNamed(context, HomePage.routeName);
  }

  Future<void> endCounselingScore() async {
    ProgressDialog.show(context);
    HttpResponse<bool> response =
        await apiP.updateScore(widget.counseling.advisorKey.toString(), cont);
    if (response.data == null) {
      await Dialogs.alert(context,
          title: "Error",
          description: "Hubo un error al finalizar la operación");
      return;
    }
    HttpResponse<bool> responseC = await counselingApi.endCounseling(
        widget.counseling.idCounseling!,
        DateTime.now().toIso8601String(),
        widget.counseling);
    ProgressDialog.dismiss(context);
    if (responseC.data == null) {
      await Dialogs.alert(context,
          title: "Error",
          description: "Hubo un error al finalizar la operación");
      return;
    }

    await Navigator.popAndPushNamed(context, HomePage.routeName);
  }

  double cont = 3.0;
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.counseling.name),
        backgroundColor: Theme.of(context).primaryColor,
        leading: CupertinoButton(
            child: Icon(
              CupertinoIcons.back,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).scaffoldBackgroundColor,
            ),
            onPressed: () {
              displayDialog();
            }),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: responsive.wp(94),
            height: responsive.hp(85.6),
            margin: EdgeInsets.all(
              responsive.wp(3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: responsive.hp(2),
                ),
                Container(
                  width: responsive.hp(25),
                  height: responsive.hp(25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 4),
                  ),
                  child: Image.asset(
                    "assets/avatars/muj1.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  widget.counseling.advisorName!,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.dp(2.7),
                  ),
                ),
                Text(
                  widget.counseling.advisorKey!,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.dp(2),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(4),
                ),
                Text(
                  "Califica a tu asesor",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.dp(2.3),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                RatingBar.builder(
                  minRating: 0,
                  maxRating: 5,
                  initialRating: 3,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: responsive.hp(7),
                  glow: false,
                  updateOnDrag: true,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.amber
                        : Colors.amberAccent,
                  ),
                  onRatingUpdate: (v) {
                    setState(() {
                      cont = v;
                    });
                  },
                ),
                SizedBox(
                  height: responsive.hp(6),
                ),
                TextField(
                  cursorColor: Theme.of(context).primaryColor,
                  maxLines: 4,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 3)),
                    labelText: "Deja un comentario",
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).hintColor
                            : Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: responsive.hp(12.5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActionButtonSizedAltColor(
                      buttonContent: "Finalizar sin calificar",
                      function: endCounseling,
                      width: responsive.wp(42),
                      height: responsive.hp(5),
                      fontSize: responsive.dp(1.7),
                      isEnable: true,
                    ),
                    ActionButtonSized(
                      buttonContent: "Enviar calificación",
                      function: endCounselingScore,
                      width: responsive.wp(50),
                      height: responsive.hp(5),
                      fontSize: responsive.dp(1.7),
                      isEnable: true,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
