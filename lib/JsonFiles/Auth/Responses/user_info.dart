import 'package:delivoo_store/JsonFiles/Commons/list_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class UserInformation {
  final int id;
  final String name;
  final String email;

  @JsonKey(name: 'mobile_number')
  final String mobileNumber;

  @JsonKey(name: 'mobile_verified')
  final int mobileVerified;

  final int active;
  final String? language;
  @JsonKey(name: 'mediaurls')
  final dynamic dynamicMediaUrls;
  final notification;

  @JsonKey(name: 'remember_token')
  final rememberToken;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'referral_code')
  final String? referralCode;

  UserInformation({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.mobileVerified,
    this.dynamicMediaUrls,
    required this.active,
    required this.language,
    this.notification,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.referralCode,
  });

  factory UserInformation.fromJson(Map json) => _$UserInformationFromJson(json);

  Map toJson() => _$UserInformationToJson(this);

  ListImage? get mediaUrls {
    return (dynamicMediaUrls != null && dynamicMediaUrls is Map)
        ? ListImage.fromJson(dynamicMediaUrls)
        : null;
  }

  String? get image => mediaUrls?.images?.first.defaultImage;
}
