import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formKeyProvider = Provider.autoDispose((ref){
  return GlobalKey<FormState>();
});

final usernameControllerProvider = Provider.autoDispose((ref){
  final cont = TextEditingController();
  ref.onDispose(() => cont.dispose());
  return cont;
});

final passwordControllerProvider = Provider.autoDispose((ref){
  final cont = TextEditingController();
  ref.onDispose(() => cont.dispose());
  return cont;
});

final isObscureNotifierProvider = NotifierProvider<IsObscureNotifier, bool>((){
  return IsObscureNotifier();
});

class IsObscureNotifier extends Notifier<bool>{
  @override
  bool build() {
    return true;
  }

  void change(){
    state = !state;
  }
}