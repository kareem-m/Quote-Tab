import 'package:flutter/material.dart';

class ListBorder extends StatelessWidget {
  final Widget child;
  const ListBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(32),
        ),
        child: child,
      ),
    );
  }
}
