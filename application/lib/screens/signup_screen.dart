import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quote_tab_todo/screens/login_screen.dart';
import 'package:quote_tab_todo/screens/todo_list_screen.dart';
import 'package:quote_tab_todo/services/login_service.dart';
import 'package:quote_tab_todo/services/signup_service.dart';
import 'package:quote_tab_todo/util/constants.dart';
import 'package:quote_tab_todo/widgets/loading_widget.dart';
import 'package:quote_tab_todo/widgets/user_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

                  Text('Register', style: TextStyle(fontSize: 34)),

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

                        //signup button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              //عملت الobject
                              final signupInstance = SignupService(
                                usernameRegister: usernameController.text,
                                passwordRegister: passwordController.text,
                              );

                              setState(() {
                                isLoading = true;
                              });

                              await signupInstance.registerUser();

                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }

                              if (signupInstance.finalResponse.statusCode !=
                                  201) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: mainAppColor,
                                      title: Text('Error'),
                                      content: Text(
                                        jsonDecode(
                                          signupInstance.finalResponse.body,
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
                                final LoginService loginInstance = LoginService(
                                  usernameLogin: usernameController.text,
                                  passwordLogin: passwordController.text,
                                );
                                loginInstance.setLogin();

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TodoListScreen(
                                      username: usernameController.text,
                                    ),
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
                              'Register',
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

                  //login gate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? '),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Log in here!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) LoadingWidget(),
        ],
      ),
    );
  }
}
