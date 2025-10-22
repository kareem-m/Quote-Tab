import 'package:clean_quote_tab_todo/core/common/ui/loading_widget.dart';
import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/providers/auth_providers.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/widgets/buttons/signup_button.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/widgets/design/form_title.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/widgets/design/image_background.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/widgets/forms/signup_form.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/widgets/gates/login_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authNotifer = ref.watch(authNotifierProvider);
    final isLoading = authNotifer.isLoading;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainAppColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(backgroundColor: mainAppColor),
      ),

      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ImageBackground(),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FormTitle(),
                  SizedBox(height: 30,),
                  Text('Register', style: TextStyle(fontSize: 34)),
                  SizedBox(height: 25,),
                  SignupForm(),
                  SizedBox(height: 10,),
                  SignupButton(),
                  SizedBox(width: size.width - 50, child: Divider()),
                  LoginGate()
                ],
              ),
            ),
          ),
          if(isLoading) LoadingWidget()
        ],
      ),
    );
  }
}
