import 'package:delivoo_store/JsonFiles/Wallet/Transaction/transaction.dart';
import 'package:delivoo_store/JsonFiles/Wallet/get_wallet_balance.dart';
import 'package:delivoo_store/JsonFiles/base_list_response.dart';
import 'package:delivoo_store/OrderItemAccount/Account/WalletBloc/wallet_event.dart';
import 'package:delivoo_store/OrderItemAccount/Account/WalletBloc/wallet_state.dart';
import 'package:delivoo_store/OrderItemAccount/ProductRepository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(LoadingWalletInitialState());

  ProductRepository _repository = ProductRepository();

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is FetchWalletBalanceEvent) {
      yield* _mapFetchWalletBalanceToState();
    } else if (event is FetchWalletTransactionsEvent) {
      yield* _mapFetchWalletTransactionsToState(event.page);
    }
  }

  Stream<WalletState> _mapFetchWalletBalanceToState() async* {
    yield LoadingWalletLoadingState();
    try {
      WalletBalance walletBalance = await _repository.getBalance();
      yield WalletBalanceLoaded(walletBalance.balance);
    } catch (e) {
      print("FetchWalletBalanceEvent: $e");
      yield WalletBalanceLoaded(0);
    }
  }

  Stream<WalletState> _mapFetchWalletTransactionsToState(int page) async* {
    yield LoadingWalletLoadingState();
    try {
      BaseListResponse<Transaction> transactionResponse =
          await _repository.getTransactions(page);
      transactionResponse.data
          .removeWhere((element) => element.type == "withdraw");
      for (Transaction transaction in transactionResponse.data)
        transaction.setup();
      yield WalletTransactionsLoaded(transactionResponse);
    } catch (e) {
      print("FetchWalletTransactionsEvent: $e");
      yield WalletTransactionsFailed();
    }
  }
}
