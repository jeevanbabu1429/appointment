// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String? email;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String?,
    );
  }
}

class LoginResponseModel {
  final String token;
  final UserModel user;

  LoginResponseModel({
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

// NEW: Register response
class RegisterResponseModel {
  final String message;
  final UserModel user;

  RegisterResponseModel({
    required this.message,
    required this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message']?.toString() ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
