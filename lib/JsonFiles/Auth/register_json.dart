import 'package:json_annotation/json_annotation.dart';

part 'register_json.g.dart';

@JsonSerializable()
class RegisterUser {
  final String name;
  final String email;
  final String role;

  @JsonKey(name: 'mobile_number')
  final String mobileNumber;

  RegisterUser({
    required this.name,
    required this.email,
    required this.role,
    required this.mobileNumber,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserToJson(this);
}
