import 'package:flutter/material.dart';

void showSnackIfError(BuildContext context, String? message) {
  if (!(message == null) && context.mounted) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
