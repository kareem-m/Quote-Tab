import 'package:flutter/material.dart';
import 'package:quote_tab_todo/util/constants.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  const LoadingWidget({super.key, this.color = mainAppColor});

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