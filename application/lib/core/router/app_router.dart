import 'package:clean_quote_tab_todo/features/auth/presentation/screens/login_screen.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/screens/signup_screen.dart';
import 'package:clean_quote_tab_todo/shell/presentation/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void navigateToSignup(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }
  
  void navigateToHome(BuildContext context, String username){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
