import 'dart:async';
import 'dart:developer';

import 'package:clean_quote_tab_todo/core/common/providers/prefs_provider.dart';
import 'package:clean_quote_tab_todo/features/auth/data/datasources/api_data_source.dart';
import 'package:clean_quote_tab_todo/features/auth/data/repos/auth_repo_impl.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/entities/user_entity.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/repos/auth_repository.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/usecases/login_usecase.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/usecases/logout_usecase.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/usecases/signup_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider<ApiDataSource>((ref) => ApiDataSource());

final authRepoProvider = Provider<AuthRepository>((ref){
  final prefs = ref.watch(prefsProvider);
  final api = ref.watch(apiProvider);

  return AuthRepoImpl(apiDataSource: api, prefs: prefs);
});

//usecases providers

final loginProvider = Provider<LoginUsecase>((ref){
  return LoginUsecase(ref.watch(authRepoProvider));
});

final signupProvider = Provider<SignupUsecase>((ref){
  return SignupUsecase(ref.watch(authRepoProvider));
});

final getUserProvider = Provider<GetCurrentUserUsecase>((ref){
  return GetCurrentUserUsecase(ref.watch(authRepoProvider));
});

final logoutProvider = Provider<LogoutUsecase>((ref){
  return LogoutUsecase(ref.watch(authRepoProvider));
});

//auth notifier

final authNotifierProvider = AsyncNotifierProvider<AuthNotifer, UserEntity?>((){
  return AuthNotifer();
});

class AuthNotifer extends AsyncNotifier<UserEntity?>{
  @override
  FutureOr<UserEntity?> build() {
    final getCurrentUser = ref.read(getUserProvider);
    log(getCurrentUser.call()?.username ?? 'no current user');
    return getCurrentUser.call();
  }

  Future<void> signup (String username, String password) async {
    state = const AsyncValue.loading();

    try{
      final signupUsecase = ref.read(signupProvider);
      final result = await signupUsecase.call(username, password);
      state = AsyncValue.data(result);
    }
    catch(e){
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login (String username, String password) async {
    state = AsyncValue.loading();

    try {
      final loginUsecase = ref.read(loginProvider);
      final result = await loginUsecase.call(username, password);
      state = AsyncValue.data(result);
    }
    catch(e){
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}