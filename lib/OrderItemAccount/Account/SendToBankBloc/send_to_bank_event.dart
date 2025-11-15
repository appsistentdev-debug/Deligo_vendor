import 'package:delivoo_store/JsonFiles/Wallet/Post/send_to_bank.dart';
import 'package:equatable/equatable.dart';

class SendToBankEvent extends Equatable {
  final SendToBank sendToBank;
  SendToBankEvent(this.sendToBank);

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
