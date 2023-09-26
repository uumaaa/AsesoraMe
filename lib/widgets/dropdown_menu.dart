import 'package:flutter/material.dart';

class DropdownMenuAlter extends StatefulWidget {
  const DropdownMenuAlter(
      {super.key,
      required this.listOfItems,
      required this.selectedItem,
      required this.returnSelectedItem,
      required this.hint,
      required this.fontSize,
      required this.height,
      required this.width});
  final String selectedItem;
  final List<String> listOfItems;
  final Function(String) returnSelectedItem;
  final String hint;
  final double fontSize;
  final double height;
  final double width;
  @override
  State<DropdownMenuAlter> createState() => _DropdownMenuAlterState();
}

class _DropdownMenuAlterState extends State<DropdownMenuAlter> {
  String? selectedItemMenu;
  List<DropdownMenuItem> items = [];
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.listOfItems.length; i++) {
      items.add(
        DropdownMenuItem(
          value: widget.listOfItems[i],
          child: SizedBox(
            child: Text(
              widget.listOfItems[i],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedItem == "") {
    } else {
      selectedItemMenu = widget.selectedItem;
    }

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: DropdownButtonFormField(
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: Theme.of(context).hintColor))),
        items: items,
        value: selectedItemMenu,
        hint: Text(
          widget.hint,
          style: TextStyle(
              fontSize: widget.fontSize, color: Theme.of(context).hintColor),
        ),
        onChanged: (item) {
          setState(() {
            selectedItemMenu = item;
          });
          widget.returnSelectedItem(selectedItemMenu!);
        },
        style: TextStyle(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor),
        iconEnabledColor: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
