import 'package:json_annotation/json_annotation.dart';
import 'package:delivoo_store/JsonFiles/Auth/Responses/user_info.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String token;

  @JsonKey(name: 'user')
  final UserInformation userInfo;

  LoginResponse({required this.token, required this.userInfo});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
