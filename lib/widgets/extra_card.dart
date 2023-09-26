import 'dart:math';

import 'package:asispnia/data/background_assets.dart';
import 'package:asispnia/model/counseling.dart';
import 'package:asispnia/pages/extra_info_page.dart';
import 'package:asispnia/utils/iluminance_color.dart';
import 'package:asispnia/utils/responsive.dart';
import 'package:flutter/material.dart';

class ExtraCard extends StatefulWidget {
  const ExtraCard({
    super.key,
    required this.width,
    required this.mainText,
    required this.extraText,
    required this.number,
    required this.elements,
  });
  final double width;
  final String mainText;
  final String extraText;
  final int number;
  final List<ExtraCounseling> elements;

  @override
  State<ExtraCard> createState() => _ExtraCardState();
}

class _ExtraCardState extends State<ExtraCard> {
  late bool isFront;
  late bool flipXAxis;
  @override
  void initState() {
    super.initState();
    isFront = true;
    flipXAxis = false;
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return GestureDetector(
      onDoubleTap: () => setState(() => isFront = !isFront),
      child: AnimatedSwitcher(
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(
          children: [widget!, ...list],
        ),
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut.flipped,
        child: isFront ? frontCard(responsive, context) : backCard(responsive),
      ),
    );
  }

  Stack backCard(Responsive responsive) {
    return Stack(
      children: [
        Container(
          key: const ValueKey<int>(1),
          height: widget.width * 2 / 3,
          width: widget.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(BACKGROUNGASSETS[widget.number % 7]),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(50)),
        ),
        Transform.translate(
          offset: Offset(widget.width * 4 / 10, 0),
          child: Container(
            padding: EdgeInsets.all(responsive.wp(2)),
            height: widget.width * 2 / 3,
            width: widget.width * 6 / 10,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.elements.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: responsive.dp(1.2), bottom: responsive.hp(2)),
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExtraInfoView(
                                  counseling: widget.elements[index])),
                        );
                      },
                      child: Text(
                        widget.elements[index].name,
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).iconTheme.color
                                    : Theme.of(context).scaffoldBackgroundColor,
                            fontSize: responsive.dp(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container frontCard(Responsive responsive, BuildContext context) {
    return Container(
      key: const ValueKey<int>(0),
      height: widget.width * 2 / 3,
      width: widget.width,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurStyle: BlurStyle.outer,
                color: Colors.black.withOpacity(.8),
                offset: const Offset(0, 0),
                blurRadius: 5)
          ],
          image: DecorationImage(
            image: AssetImage(BACKGROUNGASSETS[widget.number % 7]),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50)),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.extraText,
            style: TextStyle(
                fontSize: responsive.dp(1.6),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.w600),
          ),
          Text(
            widget.mainText,
            style: TextStyle(
                fontSize: responsive.dp(4.1),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      )),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(isFront) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}

class LoadingExtraCard extends StatelessWidget {
  const LoadingExtraCard({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return loadingCard(responsive, context);
  }

  Container loadingCard(Responsive responsive, BuildContext context) {
    return Container(
      key: const ValueKey<int>(2),
      height: width * 2 / 3,
      width: width,
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xffffffff)
                  .brightenColor(Theme.of(context).scaffoldBackgroundColor, .1)
              : const Color(0xffffffff)
                  .darkenColor(Theme.of(context).scaffoldBackgroundColor, .03),
          borderRadius: BorderRadius.circular(50)),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xffffffff).brightenColor(
                      Theme.of(context).scaffoldBackgroundColor, .07)
                  : const Color(0xffffffff).darkenColor(
                      Theme.of(context).scaffoldBackgroundColor, .06),
            ),
            width: responsive.wp(30),
            height: responsive.hp(4),
          ),
          SizedBox(
            height: responsive.hp(2.2),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xffffffff).brightenColor(
                      Theme.of(context).scaffoldBackgroundColor, .05)
                  : const Color(0xffffffff).darkenColor(
                      Theme.of(context).scaffoldBackgroundColor, .08),
            ),
            width: responsive.wp(70),
            height: responsive.hp(6),
          )
        ],
      )),
    );
  }
}
