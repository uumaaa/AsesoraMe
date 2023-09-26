import 'package:asispnia/data/background_assets.dart';
import 'package:asispnia/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  const CategoryButton(
      {super.key,
      required this.name,
      required this.width,
      required this.height,
      required this.number,
      required this.callBackFunction,
      required this.isSelected});
  final String name;
  final double width;
  final double height;
  final int number;
  final Function(int?) callBackFunction;
  final bool isSelected;

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return GestureDetector(
      onTap: () {
        widget.callBackFunction(widget.number);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: widget.isSelected
                    ? null
                    : Theme.of(context).disabledColor.withOpacity(.3),
                borderRadius: BorderRadius.circular(10),
                image: widget.isSelected
                    ? DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          BACKGROUNGASSETS[widget.number],
                        ),
                      )
                    : null),
            width: widget.width,
            height: widget.height,
            margin: EdgeInsets.symmetric(vertical: responsive.hp(.3)),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            width: responsive.wp(40),
            height: responsive.hp(7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name.split(" ")[0],
                  style: TextStyle(
                    fontSize: responsive.dp(1),
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                Text(
                  widget.name.split(" ")[1],
                  style: TextStyle(
                    fontSize: responsive.dp(1.4),
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
