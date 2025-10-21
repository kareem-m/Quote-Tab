import 'package:clean_quote_tab_todo/features/auth/domain/entities/user_entity.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/repos/auth_repository.dart';

class LoginUsecase {
  final AuthRepository authRepo;

  LoginUsecase(this.authRepo);

  Future<UserEntity> call(String username, String password) async {
    return authRepo.login(username, password);
  }
}