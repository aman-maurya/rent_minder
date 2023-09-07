import 'package:flutter/material.dart';

import '../../utils/app_style.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  String title;
  MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Styles.appBarHeading,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Styles.appBgColor
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
