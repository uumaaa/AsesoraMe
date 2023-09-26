import 'package:asispnia/api/counseling_api.dart';
import 'package:asispnia/model/counseling.dart';
import 'package:asispnia/widgets/calendar_widget.dart';
import 'package:asispnia/widgets/extra_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../model/http_response.dart';

import '../utils/logs.dart';
import '../utils/responsive.dart';

class ExtracurrricularView extends StatefulWidget {
  const ExtracurrricularView({super.key});

  @override
  State<ExtracurrricularView> createState() => _ExtracurrricularViewState();
}

class _ExtracurrricularViewState extends State<ExtracurrricularView> {
  final CounselingApi counselingApi = GetIt.instance<CounselingApi>();
  final TextEditingController dateController = TextEditingController();

  Future<List<ExtraCounseling>> getExtras() async {
    List<ExtraCounseling> extras = [];
    List<int> idExtras = [];
    HttpResponse<List<int>> response =
        await counselingApi.getExtraCounselings();
    if (response.data != null) {
      idExtras = response.data!;
    }
    for (var idExtra in idExtras) {
      HttpResponse<ExtraCounseling> counselingResponse =
          await counselingApi.getExtraCounselingByID(idExtra);
      if (counselingResponse.data != null) {
        extras.add(counselingResponse.data!);
      }
    }
    return extras;
  }

  Future<Map<String, List<ExtraCounseling>>> getCategoriesExtra() async {
    List<ExtraCounseling> extras = await getExtras();
    Map<String, List<ExtraCounseling>> map = {};
    for (var extra in extras) {
      if (!map.containsKey(extra.extracurricularName)) {
        map[extra.extracurricularName!] = [extra];
      } else {
        map[extra.extracurricularName]!.add(extra);
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return FutureBuilder(
      future: Future.wait([getCategoriesExtra()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (context.isLandscape) {
            return Container();
          } else {
            return verticalView(responsive, snapshot.data![0]);
          }
        }
        return SingleChildScrollView(
          child: SafeArea(
            child: Container(
              height: responsive.hp(80),
              width: responsive.wp(100),
              padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(
                    vertical: responsive.hp(1),
                  ),
                  child: Center(
                    child: LoadingExtraCard(
                      width: responsive.wp(90),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SingleChildScrollView verticalView(Responsive responsive,
          Map<String, List<ExtraCounseling>> categoriesExtra) =>
      SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: responsive.hp(80),
            width: responsive.wp(100),
            padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
            child: ListView.builder(
                itemCount: categoriesExtra.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  List<MapEntry<String, List<ExtraCounseling>>> entriesList =
                      categoriesExtra.entries.toList();
                  String key = entriesList[index].key;
                  List<ExtraCounseling> value = entriesList[index].value;
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.hp(1),
                    ),
                    child: Center(
                      child: ExtraCard(
                        elements: value,
                        number: index,
                        width: responsive.wp(90),
                        mainText: key.split(" ")[1],
                        extraText: key.split(" ")[0],
                      ),
                    ),
                  );
                }),
          ),
        ),
      );
}
