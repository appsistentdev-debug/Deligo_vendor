import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo_store/JsonFiles/Wallet/Transaction/transaction_meta.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  final int id;
  final double? amount;
  final String? type;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final UserInformation? user;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? createdAtFormatted;

  Transaction(
    this.id,
    this.amount,
    this.type,
    this.dynamicMeta,
    this.createdAt,
    this.updatedAt,
    this.user,
  );

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  setup() {
    createdAtFormatted = Helper.formatDateTime(
        createdAt, true, AppConfig.fireConfig!.enableAmPm);
  }

  TransactionMeta? get meta {
    return (dynamicMeta != null && dynamicMeta is Map)
        ? TransactionMeta.fromJson(dynamicMeta)
        : null;
  }
}
