import 'package:asispnia/api/counseling_api.dart';
import 'package:asispnia/data/modules.dart';
import 'package:asispnia/model/counseling.dart';
import 'package:asispnia/model/http_response.dart';
import 'package:asispnia/utils/iluminance_color.dart';
import 'package:asispnia/widgets/extra_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hexcolor/hexcolor.dart';

import '../model/user.dart';
import '../utils/logs.dart';
import '../utils/responsive.dart';
import '../widgets/private_card_widget.dart';
import 'create_private_counseling.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key, required this.user});
  final User user;

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  final CounselingApi counselingApi = GetIt.instance<CounselingApi>();
  late Future<List<PrivateCounseling>> future;
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    if (context.isLandscape) {
      return Container();
    } else {
      return verticalView(responsive);
    }
  }

  Future<List<int>> getPrivateCounselingsIDs() async {
    HttpResponse<List<int>> response =
        await counselingApi.getPrivateCounselingsUser(widget.user.idUser);
    if (response.data != null) {
      return response.data!;
    } else {
      return [];
    }
  }

  Future<List<PrivateCounseling>> getPrivateCounselings() async {
    List<int> idCounselings = await getPrivateCounselingsIDs();
    List<PrivateCounseling> privCounselings = [];
    for (var id in idCounselings) {
      HttpResponse<PrivateCounseling> response =
          await counselingApi.getPrivateCounselingByID(id);
      if (response.data != null) {
        privCounselings.add(response.data!);
      }
    }
    return privCounselings;
  }

  @override
  void initState() {
    super.initState();
    future = getPrivateCounselings();
  }

  FutureBuilder verticalView(Responsive responsive) =>
      FutureBuilder<List<PrivateCounseling>>(
        future: future,
        builder: (BuildContext context,
            AsyncSnapshot<List<PrivateCounseling>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  width: responsive.wp(94),
                  height: responsive.hp(76),
                  margin: EdgeInsets.all(
                    responsive.wp(3),
                  ),
                  child: snapshot.data!.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "¿Necesitas ayuda sobre un tema en específico?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.dp(3),
                              ),
                            ),
                            SizedBox(
                              height: responsive.hp(4),
                            ),
                            Text(
                              "¡Crea una asesoria privada sobre el tema que desees y deja que un politecnico te ayude!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.dp(1.8),
                              ),
                            ),
                            SizedBox(
                              height: responsive.hp(4),
                            ),
                            Text(
                              "Para crear una solicitud de asesoria presiona el boton",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.dp(2.5),
                              ),
                            ),
                            SizedBox(
                              height: responsive.hp(2),
                            ),
                            Icon(
                              CupertinoIcons.person_crop_circle_fill_badge_plus,
                              size: responsive.wp(15),
                            ),
                            SizedBox(
                              height: responsive.hp(2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "o toca",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).hintColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: responsive.dp(2.1),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreatePrivateCounselingView(
                                          user: widget.user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    " acá",
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Theme.of(context).iconTheme.color
                                          : Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.dp(2.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, item) => PrivateCardWidget(
                                responsive: responsive,
                                data: snapshot.data![item],
                              )),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      );
}
