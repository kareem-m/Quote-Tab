import 'package:flutter/material.dart';

class DividerLine extends StatelessWidget {
  final double? width;
  final double? thickness;
  const DividerLine({
    super.key,
    this.width,
    this.thickness
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width,child: Divider(thickness: thickness,),);
  }
}