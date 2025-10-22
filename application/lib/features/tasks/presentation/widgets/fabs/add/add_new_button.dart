import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/providers/text_providers.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/fabs/add/modal_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewButton extends ConsumerWidget {
  const AddNewButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return FloatingActionButton(
      backgroundColor: addNewButtonColor,
      onPressed: () {
        Future.delayed(const Duration(milliseconds: 50), (){
          ref.read(textFocusNodeProvider).requestFocus();
        });
        modalBottom(context);
      },
      child: Icon(Icons.add),
    );
  }
}