import 'package:json_annotation/json_annotation.dart';

part 'get_wallet_balance.g.dart';

@JsonSerializable()
class WalletBalance {
  @JsonKey(name: 'balance')
  final dynamic dynamicBalance;

  WalletBalance(this.dynamicBalance);

  double get balance => double.tryParse("$dynamicBalance") ?? 0;

  factory WalletBalance.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$WalletBalanceToJson(this);
}
