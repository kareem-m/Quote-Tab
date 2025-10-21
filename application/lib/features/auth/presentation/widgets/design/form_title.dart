import 'package:flutter/widgets.dart';

class FormTitle extends StatelessWidget {
  const FormTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Quote Tab To-do',
      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    );
  }
}
