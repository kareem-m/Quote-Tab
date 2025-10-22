import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textFocusNodeProvider = Provider.autoDispose<FocusNode>((ref){
  final node = FocusNode();
  ref.onDispose(() => node.dispose());
  return node;
});

final textControllerProvider = Provider.autoDispose<TextEditingController>((ref){
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});