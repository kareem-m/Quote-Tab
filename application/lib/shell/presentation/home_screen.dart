import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:clean_quote_tab_todo/features/quotes/presentation/widgets/quote_widget.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/appbar_widgets/refresh_icon.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/fabs/add/add_new_button.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/fabs/trash_button.dart';
import 'package:clean_quote_tab_todo/shell/providers/quote_swith_provider.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/style_widgets/edged_background.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/style_widgets/list_border.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/style_widgets/welcome_text.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/todos/todos_list.dart';
import 'package:clean_quote_tab_todo/shell/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      backgroundColor: appBarColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Quote Todo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [RefreshIcon()],
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            //edged background
            EdgedBackground(),

            Column(
              children: [
                WelcomeText(),
                if(ref.watch(quoteSwitchNotifierProvider)) QuoteWidget(),
                ListBorder(child: TodosList()),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TrashButton(),
          SizedBox(width: 20,),
          AddNewButton()
        ],
      ),
    );
  }
}