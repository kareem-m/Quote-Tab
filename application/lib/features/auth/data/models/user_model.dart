import 'package:clean_quote_tab_todo/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  UserModel({required super.username, required super.token});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(username: json['username'], token: json['token']);
  }

  UserEntity toEntity(){
    return UserEntity(username: username, token: token);
  }
}