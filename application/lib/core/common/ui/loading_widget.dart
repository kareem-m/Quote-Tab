import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  const LoadingWidget({super.key, this.color = loadingWidgetColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color
        ),
        child: Center(
          child: CircularProgressIndicator(color: Colors.white,)
        ),
      ),
    );
  }
}