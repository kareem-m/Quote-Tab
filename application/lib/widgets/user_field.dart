import 'package:flutter/material.dart';

enum FieldType { username , password }
enum UserState { login, signup }

class Userfield extends StatefulWidget {
  final FieldType fieldType;
  final TextEditingController controller;
  final String label;

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (!(RegExp(
      r'^[a-zA-Z0-9_.-]+$',
    ).hasMatch(value))) {
      return 'Use Valid username';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Password';
    }
    return null;
  }

  const Userfield({
    super.key,
    required this.fieldType,
    required this.controller,
    required this.label
  });

  @override
  State<Userfield> createState() => _UserfieldState();
}

class _UserfieldState extends State<Userfield> {
  
  late bool isObsure;
  
  @override
  void initState() {
    super.initState();
    isObsure = widget.fieldType == FieldType.username ? false : true;
  }
  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextInputType keyboard = switch (widget.fieldType) {
      FieldType.username => TextInputType.text,
      FieldType.password => TextInputType.visiblePassword,
    };


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),

      child: Container(
        width: size.width - 50,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(25),
        ),

        //field
        child: TextFormField(
          keyboardType: keyboard,
          controller: widget.controller,
          obscureText: isObsure,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            suffixIcon: widget.fieldType == FieldType.password
                ? IconButton(
                    onPressed: () => setState(() {
                      isObsure = !isObsure;
                    }),
                    icon: Icon(
                      isObsure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          validator: widget.fieldType == FieldType.username
              ? widget.usernameValidator
              : widget.passwordValidator,
        ),
      ),
    );
  }
}
