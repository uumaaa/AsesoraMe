import 'package:asispnia/api/counseling_api.dart';
import 'package:asispnia/data/modules.dart';
import 'package:asispnia/model/counseling.dart';
import 'package:asispnia/model/http_response.dart';
import 'package:asispnia/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/day.dart';
import '../widgets/change_theme_button.dart';
import '../widgets/dialogs.dart';
import '../widgets/request_card_widget.dart';

class AcceptCounselingRequestView extends StatelessWidget {
  const AcceptCounselingRequestView({super.key, required this.counseling});
  final PrivateCounseling counseling;

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        actions: const [
          ChangeThemeButton(),
        ],
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
            padding: EdgeInsets.all(
              responsive.wp(3),
            ),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: counseling.requestDays!.length,
                itemBuilder: (context, item) {
                  List<MapEntry<String, List<Day>>> entriesList =
                      counseling.requestDays!.entries.toList();
                  String mapKey = entriesList[item].key;
                  List<Day> mapValue = entriesList[item].value;
                  return RequestCard(
                    responsive: responsive,
                    mapKey: mapKey,
                    mapValue: mapValue,
                    item: item,
                    counselingID: counseling.idCounseling!,
                  );
                }),
          ),
        ),
      ),
    );
  }
}
