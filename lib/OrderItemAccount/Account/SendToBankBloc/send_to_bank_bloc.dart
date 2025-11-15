// ignore_for_file: unnecessary_type_check

import 'package:bloc/bloc.dart';
import 'package:delivoo_store/JsonFiles/Wallet/Post/send_to_bank.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';

import 'send_to_bank_event.dart';
import 'send_to_bank_state.dart';

class SendToBankBloc extends Bloc<SendToBankEvent, SendToBankState> {
  ProductRepository _productRepository = ProductRepository();

  SendToBankBloc() : super(InitialSendToBankState());

  @override
  Stream<SendToBankState> mapEventToState(SendToBankEvent event) async* {
    if (event is SendToBankEvent) {
      yield* _mapUpdateProfileToState(event.sendToBank);
    }
  }

  Stream<SendToBankState> _mapUpdateProfileToState(
      SendToBank sendToBank) async* {
    yield LoadingSendToBankState();
    try {
      await _productRepository.sendToBank(sendToBank);
      yield SuccessSendToBankState();
    } catch (e) {
      yield FailureSendToBankState(e);
    }
  }
}
