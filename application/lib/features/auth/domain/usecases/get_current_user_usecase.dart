import 'package:clean_quote_tab_todo/features/auth/domain/entities/user_entity.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/repos/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository authRepo;

  GetCurrentUserUsecase(this.authRepo);

  UserEntity? call () {
    return authRepo.getCurrentUser();
  }
}