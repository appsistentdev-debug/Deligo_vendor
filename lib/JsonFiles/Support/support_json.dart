
import 'package:json_annotation/json_annotation.dart';

part 'support_json.g.dart';
@JsonSerializable()
class Support{
  final String name;
  final String email;
  final String message;

  Support({required this.name,required this.email,required this.message});

  factory Support.fromJson(Map<String, dynamic> json) =>
      _$SupportFromJson(json);

  Map<String, dynamic> toJson() => _$SupportToJson(this);
}
