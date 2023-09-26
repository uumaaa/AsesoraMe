import 'package:asispnia/data/enum_lists.dart';
import 'package:asispnia/utils/responsive.dart';
import 'package:flutter/cupertino.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({super.key});

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  int cont = 1;
  String urlAvatar = AVATARASSETS[1];
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          cont++;
          urlAvatar = AVATARASSETS[cont % AVATARASSETS.length];
        });
      },
      child: Image.asset(
        urlAvatar,
        width: responsive.wp(40),
        height: responsive.hp(22),
        fit: BoxFit.contain,
      ),
    );
  }
}
