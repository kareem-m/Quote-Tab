import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quote_tab_todo/models/user.dart';
import 'package:quote_tab_todo/screens/signup_screen.dart';
import 'package:quote_tab_todo/screens/todo_list_screen.dart';
import 'package:quote_tab_todo/services/login_service.dart';
import 'package:quote_tab_todo/util/constants.dart';
import 'package:quote_tab_todo/widgets/loading_widget.dart';
import 'package:quote_tab_todo/widgets/user_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: mainAppColor,
      //عامل الحوار دا عشان اخلي app bar صغيرة جدا عشان اخلي لون شريط الحالة ابيض
      //..
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(backgroundColor: mainAppColor),
      ),
      //..
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            //background
            child: Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.cover,
              alignment: AlignmentGeometry.centerRight,
            ),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //title
                  Text(
                    'Quote Tab To-do',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 30),

                  Text('Login', style: TextStyle(fontSize: 34)),

                  SizedBox(height: 25),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //username field
                        Userfield(
                          fieldType: FieldType.username,
                          controller: usernameController,
                          label: 'Username',
                        ),

                        //password field
                        Userfield(
                          fieldType: FieldType.password,
                          controller: passwordController,
                          label: 'Password',
                        ),

                        SizedBox(height: 10),

                        //login button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = User(usernameController.text, passwordController.text);
                              final loginInstance = LoginService(user: user);

                              setState(() {
                                isLoading = true;
                              });

                              await loginInstance.loginUser();

                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }

                              if (loginInstance.finalResponse.statusCode !=
                                  200) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: mainAppColor,
                                      title: Text('Error'),
                                      content: Text(
                                        jsonDecode(
                                          loginInstance.finalResponse.body,
                                        )['message'],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                await loginInstance.setLoginOnStorage();

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TodoListScreen(username: usernameController.text,),
                                  ),
                                );
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              secondAppColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  //line
                  SizedBox(width: size.width - 50, child: Divider()),

                  //register gate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account yet? '),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up here!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if(isLoading)
            LoadingWidget()
        ],
      ),
    );
  }
}
