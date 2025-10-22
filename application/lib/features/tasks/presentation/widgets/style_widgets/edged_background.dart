import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:flutter/material.dart';

class EdgedBackground extends StatelessWidget {
  const EdgedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mainAppColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
    );
  }
}
