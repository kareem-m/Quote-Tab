import 'package:clean_quote_tab_todo/features/auth/domain/repos/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository authRepo;

  LogoutUsecase(this.authRepo); 

  Future<void> call () async {
    authRepo.logout();
  }
}