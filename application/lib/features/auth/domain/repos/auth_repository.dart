import 'package:clean_quote_tab_todo/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String username, String password);
  Future<UserEntity> signup(String username, String password);
  UserEntity? getCurrentUser();
  Future<void> logout();
}