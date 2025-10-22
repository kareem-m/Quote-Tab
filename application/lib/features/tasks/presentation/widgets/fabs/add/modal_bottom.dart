import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/fabs/add/add_text_field.dart';
import 'package:flutter/material.dart';

modalBottom(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsetsGeometry.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 15,
          right: 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(child: AddTextField()),
          ),
        ),
      );
    },
  );
}
