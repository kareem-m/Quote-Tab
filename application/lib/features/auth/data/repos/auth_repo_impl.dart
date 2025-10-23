import 'package:clean_quote_tab_todo/features/auth/data/datasources/api_data_source.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/entities/user_entity.dart';
import 'package:clean_quote_tab_todo/features/auth/domain/repos/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepoImpl implements AuthRepository {
  final ApiDataSource apiDataSource;
  final SharedPreferences prefs;

  AuthRepoImpl({required this.apiDataSource, required this.prefs});

  @override
  Future<UserEntity> login(String username, String password) async {
    final user = await apiDataSource.loginUser(username.trim(), password);

    prefs.setBool('isLoggedIn', true);
    prefs.setString('currentUsername', user.username);
    prefs.setString('token', user.token);

    return user.toEntity();
  }

  @override
  Future<UserEntity> signup(String username, String password) async {
    final user = await apiDataSource.registerUser(username.trim(), password);

    prefs.setBool('isLoggedIn', true);
    prefs.setString('currentUsername', user.username);
    prefs.setString('token', user.token);

    return user.toEntity();
  }

  @override
  UserEntity? getCurrentUser() {
    final username = prefs.getString('currentUsername');
    final token = prefs.getString('token');

    if(username != null && token != null && username.isNotEmpty && token.isNotEmpty){
      return UserEntity(username: username, token: token);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    prefs.setBool('isLoggedIn', false);
    prefs.setString('currentUsername', '');
    prefs.setString('token', '');
  }
}
